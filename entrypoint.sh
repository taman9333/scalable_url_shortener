#!/bin/sh
set -e

bundle exec ruby seeds/seed_counter.rb

exec "$@"
