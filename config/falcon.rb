load 'config/environment.rb'
require_relative '../initializers/etcd'

Falcon::Controller.run do |options|
  options.bindings << {
    protocol: "http",
    hostname: "0.0.0.0",
    port: 9292,
  }
end
