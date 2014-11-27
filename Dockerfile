# ezHire.ru
#
# VERSION               0.0.0

FROM      ubuntu:trusty

MAINTAINER Mikhail Petrov <me@mixael.ru>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev wget nodejs

# Ruby
RUN wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz && tar -xvzf ruby-2.1.3.tar.gz
RUN cd ruby-2.1.3 && ./configure --disable-install-doc --disable-install-rdoc  --prefix=/usr/local && make && make install
RUN gem install bundler

# Nginx
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository ppa:nginx/stable
RUN apt-get update
RUN apt-get install -y nginx

ADD ./ /ezhire/
ADD .docker/cache/vendor/bundle /ezhire/vendor/bundle
RUN rm -rf /ezhire/.docker /ezhire/log/* /ezhire/tmp/*/*

RUN rm /etc/nginx/sites-enabled/default
ADD ./config/nginx/ezhire.conf /etc/nginx/sites-enabled/ezhire

WORKDIR /ezhire/
ENV RAILS_ENV production

RUN bundle install --path vendor/bundle

RUN bundle exec rake assets:precompile

# Clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm -rf ruby-2.1.3*

# ENTRYPOINT bin/run
