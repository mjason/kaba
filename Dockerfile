FROM ruby:3.3-alpine

# Set the working directory to /kaba
WORKDIR /kaba

# Copy the Gemfile, Gemfile.lock into the container
COPY Gemfile Gemfile.lock kaba.gemspec ./

# Required in kaba.gemspec
COPY lib/kaba/version.rb /kaba/lib/kaba/version.rb
COPY Gemfile /kaba/Gemfile
COPY Gemfile.lock /kaba/Gemfile.lock

# Install application dependencies
RUN apk add --no-cache build-base git && bundle install

# Copy the rest of our application code into the container.
# We do this after bundle install, to avoid having to run bundle
# every time we do small fixes in the source code.
COPY . .

# Install the gem locally from the project folder
RUN gem build kaba.gemspec && \
    gem install ./kaba-*.gem --no-document

RUN rm -rf /kaba

# Set the working directory to /workdir
WORKDIR /workdir

# Set the entrypoint to run the installed binary in /workdir
# Example:  docker run -it -v "$PWD:/workdir" kaba
ENTRYPOINT ["kaba"]