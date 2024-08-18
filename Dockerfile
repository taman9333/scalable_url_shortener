FROM ruby:3.1.5

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

WORKDIR /url_shortener

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

RUN chmod +x /url_shortener/entrypoint.sh

EXPOSE 9292

ENTRYPOINT ["/url_shortener/entrypoint.sh"]

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0"]