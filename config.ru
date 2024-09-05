require './server'

$stdout.sync = true

# Initialize the counter range during server boot-up
CounterService.initialize_counter_range

run Sinatra::Application
