FROM ubuntu:16.04

ENV TERM linux
ENV ENV DEBIAN_FRONTEND noninteractive

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -yq --no-install-recommends \
  apt-transport-https && \
  mkdir /mycroft && \
  TOP=/mycroft && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y \
  libssl-dev \
  git && \
  cd /mycroft && \

  # Checkout Mycroft
  git clone https://github.com/MycroftAI/mycroft-core.git /mycroft/ai/ && \
  cd /mycroft/ai && \
  /bin/bash build_host_setup_docker.sh

#For now copying deb files over to install
COPY build_host_setup_debian.sh /usr/local/bin/
COPY mycroft-core-amd64_0.8.20-1.deb /usr/local/bin

# Install Server Dependencies for Mycroft
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -yq --no-install-recommends \
  software-properties-common && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F3B1AA8B && \
  bash -c 'echo "deb http://repo.mycroft.ai/repos/apt/debian debian-unstable main" > /etc/apt/sources.list.d/repo.mycroft.ai.list' && \
  apt-get update && \
  apt-get install -yq --no-install-recommends \
  mimic \
  supervisor \
  dnsmasq \
  avrdude \
  jq \
  pulseaudio \
  alsa-utils && \

  # Move To Mycroft Folder
  cd /mycroft/ai && \
  easy_install pip==7.1.2 && \
  pip install -r requirements.txt --trusted-host pypi.mycroft.team && \
  dpkg -i /usr/local/bin/mycroft-core-amd64_0.8.20-1.deb && \
  apt-get install -f && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
WORKDIR /mycroft/ai
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai
EXPOSE 8181
CMD ["/mycroft/ai/mycroft.sh start -c"]
