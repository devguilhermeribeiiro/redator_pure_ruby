# Use the official Ruby image as the base image
FROM ruby:3.2.8

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN gem install bundler -v 2.5.16

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies (gems)
RUN bundle install

# Copy the entire application into the container
COPY . .

# Expose the port the app runs on
EXPOSE 4567

# Define the command to run the app
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "4567"]
