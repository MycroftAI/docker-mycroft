FROM ubuntu:16.04

ENV TERM linux
ENV ENV DEBIAN_FRONTEND noninteractive

#For now copying deb files over to install
COPY build_host_setup_debian.sh /usr/local/bin/


# Install Server Dependencies for Mycroft
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -yq --no-install-recommends apt-transport-https && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F3B1AA8B && \
  bash -c 'echo "deb http://repo.mycroft.ai/repos/apt/debian debian main" > /etc/apt/sources.list.d/repo.mycroft.ai.list' && \
  apt-get update && \
  apt-get install -yq --no-install-recommends \
  supervisor \
  mimic \
  curl \
  wget \
  locales \
  software-properties-common \
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
  mkdir /opt/mycroft && \
  mkdir /opt/mycroft/skills && \



  # Checkout Mycroft
  git clone https://github.com/MycroftAI/mycroft-core.git /mycroft/ai/ && \
  cd /mycroft/ai && \
  # git fetch && git checkout dev && \ this branch is now merged to master
  easy_install pip && \
  pip install -r requirements.txt --trusted-host pypi.mycroft.team && \
  /mycroft/ai/./dev_setup.sh --allow-root && \
  apt-get install -f && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Set the locale
ENV LANG en_US.UTF-8

WORKDIR /mycroft/ai
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai
EXPOSE 8181
RUN ["/bin/bash", "/mycroft/ai/start-mycroft.sh", "all"]
ENTRYPOINT ["tail", "-f", "/mycroft/ai/scripts/logs/mycroft-skills.log"]
