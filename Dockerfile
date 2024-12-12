FROM ruby:3.1.6-bullseye

ENV RAILS_ROOT /var/www/reader
ENV RAILS_ENV production

WORKDIR $RAILS_ROOT

COPY Gemfile* ./
COPY config/credentials/production.key ./config/credentials/

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -qq -y python yarn default-mysql-client && gem install bundler --version=2.5.23 --no-document
RUN bundle config set --local without 'development test'
RUN bundle install --jobs 20 --retry 5
RUN yarn install --silent --no-progress --no-audit --no-optional
RUN yarn install --check-files

COPY . .

RUN bundle exec rake assets:precompile && ln -s /var/www/reader/public/packs/ packs && bundle exec rake 'assets:clean[3]'

RUN rm -rf test/* tmp/* log/* db/* public/assets node_modules

EXPOSE 3000

CMD rm -rf tmp/pids && rails server --port 3000 --binding 0.0.0.0
