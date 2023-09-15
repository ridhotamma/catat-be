# Use an official Ruby runtime as a parent image
FROM ruby:3.2.2

# Set the working directory in the container
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    postgresql-client

# install bundler version
RUN gem install bundler:2.4.19

# Install Rails and Bundler
RUN gem install rails bundler

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
