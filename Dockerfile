FROM ubuntu:16.04

MAINTAINER  Brian Hopkins <brianhh1230@gmail.com>

ENV TERM linux
ENV ENV DEBIAN_FRONTEND noninteractive

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY build_host_setup_debian.sh /usr/local/bin/

# Install Server Dependencies for Mycroft
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install git && \
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
  pip install supervisor && \
  ./scripts/install-mimic.sh


# Set environment variables.
ENV HOME /mycroft

# Define working directory.
WORKDIR /mycroft

ENV PYTHONPATH $PYTHONPATH:/mycroft/ai/mycroft/client/speech/main.py
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai/mycroft/client/messagebus/service/main.py
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai/mycroft/client/skills/main.py

EXPOSE 8000

CMD ["/bin/bash"]
