# ezHire.ru
#
# VERSION               0.0.0

FROM      ubuntu:trusty

MAINTAINER Mikhail Petrov <me@mixael.ru>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

# Ruby
RUN apt-get install -y build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev wget
RUN wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz && tar -xvzf ruby-2.1.3.tar.gz
RUN cd ruby-2.1.3 && ./configure --disable-install-doc --disable-install-rdoc  --prefix=/usr/local && make && make install
RUN gem install bundler
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
