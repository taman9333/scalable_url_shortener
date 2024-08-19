require 'mongo'

MONGO_CLIENT = Mongo::Client.new(
  ENV['MONGO_URL'],
  max_pool_size: 20,
  min_pool_size: 5
)
