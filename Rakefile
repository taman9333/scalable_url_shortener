# Rakefile
require 'rake'
require_relative 'initializers/mongo'

namespace :db do
  desc "Create index on short_url"
  task :create_index do
    Collections.urls.indexes.create_one({ short_url: 1 })
    puts "Index on 'short_url' created successfully."
  end
end