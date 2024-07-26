require 'mongo'

Mongo::Logger.logger.level = Logger::WARN

MONGO_CLIENT = Mongo::Client.new(['127.0.0.1:27017'], database: 'url_shortener')
