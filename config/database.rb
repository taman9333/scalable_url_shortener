require 'mongo'

class MongoDB
  def self.client
    @client ||= begin
      Mongo::Client.new(
        ENV['MONGO_URL'],
        max_pool_size: ENV.fetch('MONGO_MAX_POOL_SIZE', 10).to_i,
        min_pool_size: ENV.fetch('MONGO_MIN_POOL_SIZE', 5).to_i
      )
    rescue Mongo::Error => e
    puts "Failed to connect to MongoDB: #{e.message}"
    raise
    end
  end
end
