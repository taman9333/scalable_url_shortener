require 'mongo'

MONGO_CLIENT = Mongo::Client.new(ENV['MONGO_URL'])
