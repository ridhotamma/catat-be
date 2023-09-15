#!/bin/sh


# Start the Ruby on Rails app.
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails server -p 3000