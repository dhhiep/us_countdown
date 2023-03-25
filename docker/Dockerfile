FROM ruby:2.7.2-alpine3.13

ENV BUILD_PACKAGES bash build-base openssh git tzdata nodejs yarn postgresql-dev imagemagick gcompat
ENV TZ=Asia/Ho_Chi_Minh

RUN apk add --update --no-cache $BUILD_PACKAGES \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && rm -rf /var/cache/* && mkdir /var/cache/apk

ARG BUNDLER_VERSION
RUN gem install bundler -v $BUNDLER_VERSION

ARG WORKSPACE
WORKDIR $WORKSPACE

COPY Gemfile Gemfile.lock ./
RUN bundle config --local without development:test && bundle install --jobs 4 --retry 3 --quiet && bundle clean --force

COPY package.json yarn.lock ./
RUN yarn install

COPY ./ ./
RUN RAILS_ENV=production bundle exec rake assets:precompile

ARG RAILS_PORT
ENV RAILS_PORT=$RAILS_PORT
EXPOSE $RAILS_PORT
CMD docker/scripts/entry_point.sh
