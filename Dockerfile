FROM ubuntu:16.04

ENV TERM linux
ENV ENV DEBIAN_FRONTEND noninteractive



# Install Server Dependencies for Mycroft
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -yq --no-install-recommends \
  apt-transport-https \
  python-pip \
  curl \
  wget \
  software-properties-common && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F3B1AA8B && \
  bash -c 'echo "deb http://repo.mycroft.ai/repos/apt/debian debian-unstable main" > /etc/apt/sources.list.d/repo.mycroft.ai.list' && \
  apt-get update && \
  apt-get install -yq mycroft-core && \
  apt-get install -f && \
  apt-get upgrade mycroft-core

#For now copying deb files over to install
COPY pair.sh /home/mycroft

WORKDIR /home/mycroft
EXPOSE 8181
RUN ["chmod", "+x", "/home/mycroft/pair.sh"]
