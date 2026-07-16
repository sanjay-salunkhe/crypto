# syntax=docker/dockerfile:1

ARG RUBY_VERSION=4.0.5
FROM docker.io/library/ruby:$RUBY_VERSION-slim

WORKDIR /rails

# Install dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libvips \
    libyaml-dev \
    pkg-config \
    libpq-dev \
    postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Dev environment
ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle

# Copy Gemfiles
COPY Gemfile ./

# Install gems (no frozen mode)
RUN bundle install

# Copy app
COPY . .

# Entrypoint
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]