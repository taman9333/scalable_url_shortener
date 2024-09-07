require_relative '../initializers/etcd'

def seed_counter
  initial_value = '0'

  # Check if the key exists
  kvs = Etcd.client.get(COUNTER_KEY).kvs
  if kvs.empty?
    # If the key does not exist, set the initial value
    Etcd.client.put(COUNTER_KEY, initial_value)
    puts "Seeded #{COUNTER_KEY} with value #{initial_value}"
  else
    puts "#{COUNTER_KEY} already exists with value #{kvs.first.value}"
  end
end

seed_counter