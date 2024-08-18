#!/bin/sh
set -e

rake db:create_index

bundle exec ruby seeds/seed_counter.rb

exec "$@"
