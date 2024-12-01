require './server'
require './config/cors'

$stdout.sync = true

# Initialize the counter range during server boot-up
CounterService.initialize_counter_range

Cors.configure(self)

run Sinatra::Application
