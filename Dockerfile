# Use a standard Ruby image based on Debian
FROM ruby:3.1.1-bullseye

# Install git and other build dependencies
RUN apt-get update -qq && apt-get install -y git build-essential

# Set the working directory
WORKDIR /srv/jekyll

# Copy your project files
COPY . .

# Install the gems into a vendor directory
RUN bundle install --path vendor/bundle

# Expose the Jekyll port
EXPOSE 4000

# Define the default command to serve the site
CMD ["bundle", "exec", "jekyll", "serve", "--host=0.0.0.0"]

