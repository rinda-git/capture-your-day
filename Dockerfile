# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.11
FROM ruby:${RUBY_VERSION}-slim AS base

ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development:test"

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libpq5 \
      libvips \
      postgresql-client \
    && rm -rf /var/lib/apt/lists/*


FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      ca-certificates \
      curl \
      gnupg \
      build-essential \
      git \
      libpq-dev \
      libyaml-dev \
      pkg-config \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
       | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
       | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -y nodejs \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists/*

# Gem
COPY Gemfile Gemfile.lock ./
RUN bundle install

# JS
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# アプリ
COPY . .

# assets
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

FROM base

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

RUN useradd -m rails && chown -R rails:rails /app
USER rails

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]