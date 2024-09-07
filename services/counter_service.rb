require 'securerandom'
require 'thread'
require 'etcdv3'
require_relative '../initializers/etcd'

class CounterService
  RANGE_SIZE = 1000

  class << self
    # This method will be called only once during server boot-up (in config.ru)
    # to pre-initialize the counter range before handling any requests.
    def initialize_counter_range
      self.counter_range = get_counter_range
      self.counter = counter_range.first
    end

    def get_next_counter
      # Mutex prevents race conditions in a multi-threaded web server environment,
      # mutex ensures that only one thread can modify the counter at a time,
      # maintaining the integrity and uniqueness of assigned counter values.
      counter_mutex.synchronize do
        current_counter = counter
        if current_counter >= counter_range.last
          self.counter_range = get_counter_range
          self.counter = counter_range.first
          current_counter = counter
        end
        self.counter += 1
        current_counter
      end
    end

    private

    attr_accessor :counter_range, :counter
    attr_reader :counter_mutex

    def get_counter_range
      loop do
        current_value = Etcd.client.get(COUNTER_KEY).kvs.first&.value.to_i
        new_value = current_value + RANGE_SIZE

        # Distributed counter allocation using ETCD's transactional operations:
        # 1. We attempt to atomically update the counter in ETCD.
        # 2. The transaction compares the current value in ETCD with what we read earlier.
        # 3. If they match (i.e., no other instance has updated it), we increment the counter.
        # 4. This ensures that even in a distributed environment with multiple server instances,
        #    we maintain a consistent and collision-free counter allocation.
        # 5. If the transaction fails, the loop will retry, reading the new current value.
        txn = Etcd.client.transaction do |txn|
          txn.compare = [
            txn.value(COUNTER_KEY, :equal, current_value.to_s),
          ]
          txn.success = [
            txn.put(COUNTER_KEY, new_value.to_s)
          ]
        end

        if txn.succeeded
          puts "Instance #{ENV['SERVICE_NAME']} obtained counter range #{current_value} to #{new_value - 1}"
          return (current_value...new_value)
        end
      end
    end

    def counter_mutex
      @counter_mutex ||= Mutex.new
    end
  end
end
