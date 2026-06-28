FROM ruby:latest

WORKDIR /site

RUN gem install bundler

EXPOSE 4000

CMD [ "/site/docker-entry.sh"]
