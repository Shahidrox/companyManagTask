FROM ruby:3.0.3

ENV APP_ROOT /hiring_task

WORKDIR $APP_ROOT
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
COPY . $APP_ROOT

RUN apt-get update && apt-get install -y nodejs \
    yarn \
    build-essential libpq-dev postgresql-client

RUN gem install bundler -v 2.2.32
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install

RUN chmod +x init.sql

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]


EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]