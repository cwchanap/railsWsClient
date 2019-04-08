FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs sqlite3
RUN mkdir /
WORKDIR /
COPY Gemfile /Gemfile
COPY Gemfile.lock /Gemfile.lock
RUN bundle install
COPY . /

EXPOSE 16255

CMD ["rails", "server", "-b", "0.0.0.0"]