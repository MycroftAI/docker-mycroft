FROM dorowu/ubuntu-desktop-lxde-vnc:latest

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

# Install Server Dependencies for Mycroft
RUN apt-get update -y
RUN apt-get install -y git python3 python3-pip python3-dev python3-setuptools python3-virtualenv python-gobject-2-dev libtool libffi-dev libssl-dev autoconf automake bison swig libglib2.0-dev portaudio19-dev mpg123 flac curl libicu-dev pkg-config automake libjpeg-dev libfann-dev build-essential jq python-pip sudo bash locales alsa-base alsa-utils
# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN pip3 install git+https://github.com/mycroftAI/mycroft-core.git
RUN mkdir -p /opt/mycroft/skills
RUN mkdir -p $HOME/.mycroft
RUN msm default
RUN mkdir /etc/mycroft
COPY startup.sh /opt/mycroft/
EXPOSE 8181

ENTRYPOINT ["/bin/bash", "/opt/mycroft/startup.sh"]
