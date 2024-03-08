FROM ruby:2.7-buster

ENV RAILS_ROOT /var/www/reader
ENV RAILS_ENV production

WORKDIR $RAILS_ROOT

COPY Gemfile* ./
COPY config/credentials/production.key ./config/credentials/
COPY install-mysql-client.sh /

RUN /install-mysql-client.sh
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -qq -y yarn mysql-client && gem install bundler --version=2.1.4 --no-document
RUN bundle config set --local without 'development test'
RUN bundle install --jobs 20 --retry 5
RUN yarn install --silent --no-progress --no-audit --no-optional
RUN yarn install --check-files

COPY . .

ENV PORT 3100
EXPOSE 3100

CMD rails server --port=3100
