FROM ubuntu:16.04

ENV TERM linux
ENV ENV DEBIAN_FRONTEND noninteractive


COPY build_host_setup_debian.sh /usr/local/bin/
COPY mycroft-core-amd64_0.8.12-1.deb /usr/local/bin
COPY mimic-amd64_1.2.0.2-1.deb /usr/local/bin

# Install Server Dependencies for Mycroft
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -yq --no-install-recommends \
  supervisor \
  dnsmasq \
  avrdude \
  jq \
  pulseaudio \
  alsa-utils && \
  cd /usr/local/bin && \
  /bin/bash build_host_setup_debian.sh && \
  mkdir /mycroft && \
  TOP=/mycroft && \
  cd /mycroft && \

  # Checkout Mycroft
  git clone https://github.com/MycroftAI/mycroft-core.git /mycroft/ai/ && \
  cd /mycroft/ai && \
  # git fetch && git checkout dev && \ this branch is now merged to master
  easy_install pip==7.1.2 && \
  pip install -r requirements.txt --trusted-host pypi.mycroft.team && \
  dpkg -i /usr/local/bin/mimic-amd64_1.2.0.2-1.deb && \
  mkdir /mycroft/ai/mimic && \
  mkdir /mycroft/ai/mimic/bin && \
  mv /usr/local/bin/mimic /mycroft/ai/mimic/bin && \
  dpkg -i /usr/local/bin/mycroft-core-amd64_0.8.12-1.deb && \
  apt-get install -f && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
WORKDIR /mycroft/ai
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai
EXPOSE 8181
CMD ["/mycroft/ai/mycroft.sh start -c"]
