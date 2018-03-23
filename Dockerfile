FROM ubuntu:17.10

ENV TERM linux
ENV ENV DEBIAN_FRONTEND noninteractive


# Install Server Dependencies for Mycroft
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -yq --no-install-recommends \
  apt-transport-https \
  curl \
  wget \
  locales \
  software-properties-common && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F3B1AA8B && \
  bash -c 'echo "deb http://repo.mycroft.ai/repos/apt/debian debian main" > /etc/apt/sources.list.d/repo.mycroft.ai.list' && \
  apt-get update && \
  apt-get install -yq --no-install-recommends \
  supervisor \
  libicu-dev \
  git \
  python \
  python-dev \
  python-setuptools \
  python-virtualenv \
  python-gobject-dev \
  virtualenvwrapper \
  libtool \
  libffi-dev \
  libssl-dev \
  autoconf \
  automake \
  bison \
  swig \
  libglib2.0-dev \
  s3cmd \
  portaudio19-dev \
  mpg123 \
  screen \
  flac \
  pkg-config \
  automake \
  libjpeg-dev \
  libfann-dev \
  build-essential \
  jq \
  dnsmasq \
  avrdude \
  jq \
  pulseaudio \
  alsa-utils \
  mimic && \
  cd /usr/local/bin && \
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
  /mycroft/ai/./dev_setup.sh --allow-root -sm && \
  apt-get install -f && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir /mycroft/ai/scripts/logs && \
  touch /mycroft/ai/scripts/logs/mycroft-bus.log && \
  touch /mycroft/ai/scripts/logs/mycroft-voice.log && \
  touch /mycroft/ai/scripts/logs/mycroft-skills.log && \
  touch /mycroft/ai/scripts/logs/mycroft-audio.log && \
  /mycroft/ai/scripts/prepare_msm.sh && \
  msm default


# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /mycroft/ai
ADD startup.sh /mycroft/ai
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai
EXPOSE 8181
RUN ["chmod", "+x", "/mycroft/ai/start-mycroft.sh"]
RUN ["chmod", "+x", "/mycroft/ai/startup.sh"]
RUN ["/bin/bash", "/mycroft/ai/start-mycroft.sh", "all"]
ENTRYPOINT ["/bin/bash", "/mycroft/ai/startup.sh"]
