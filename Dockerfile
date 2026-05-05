FROM ruby:latest

WORKDIR /site

RUN gem install bundler

EXPOSE 4000

CMD [ "/site/entry_point.sh" ]

# docker build . -t jekyll-local
# docker run --rm -it -p4000:4000 -v$PWD:/site jekyll-local
