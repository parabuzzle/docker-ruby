# This docker file sets up the rails app container
#
# https://docs.docker.com/reference/builder/

FROM ruby:2.3.1
MAINTAINER Mike Heijmans <parabuzzle@gmail.com>

# Add env variables
ENV PORT 80

ENV APP_HOME /webapp

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y htop git software-properties-common && \
    gem install bundler --wrappers --bindir /usr/local/bin

ADD gosu /usr/local/sbin/gosu
RUN chmod a+x /usr/local/sbin/gosu

# Install required apt-get packages
RUN apt-get install curl wget
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install -y nodejs \
                       build-essential \
                       chrpath libssl-dev \
                       libxft-dev libfreetype6 \
                       libfreetype6-dev \
                       libfontconfig1 \
                       libfontconfig1-dev

# switch to tmp for handling the bundle
WORKDIR /tmp

# install phantomjs
COPY phantomjs-2.1.1-linux-x86_64.tar.bz2 .
RUN tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN mv phantomjs-2.1.1-linux-x86_64 /usr/local/share
RUN ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/

# switch to the application directory for exec commands
WORKDIR $APP_HOME
