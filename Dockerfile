FROM ubuntu:16.04

ENV TERM linux
ENV ENV DEBIAN_FRONTEND noninteractive

#For now copying deb files over to install
COPY pair.sh /usr/local/bin

# Install Server Dependencies for Mycroft
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -yq --no-install-recommends \
  supervisor \
  apt-transport-https \
  dnsmasq \
  avrdude \
  jq \
  pulseaudio \
  alsa-utils && \
  cd /usr/local/bin && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F3B1AA8B && \
  bash -c 'echo "deb http://repo.mycroft.ai/repos/apt/debian debian main" > /etc/apt/sources.list.d/repo.mycroft.ai.list' && \
  apt-get update && \
  apt-get install -yq mycroft-core && \
  apt-get install -f && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  service mycroft-messagebus start && \
  service mycroft-skills start


WORKDIR /home/mycroft
EXPOSE 8181
RUN ["chmod", "+x", "/usr/local/bin/pair.sh"]
ENTRYPOINT ["/usr/local/bin/pair.sh"]
