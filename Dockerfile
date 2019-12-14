FROM ubuntu:18.04

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive
RUN set -x

# Install system packages required by Mycroft
RUN apt-get update \
  && sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
  && apt-get -y install sudo locales curl git python3 python3-pip \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl https://forslund.github.io/mycroft-desktop-repo/mycroft-desktop.gpg.key | apt-key add - 2> /dev/null
RUN echo "deb http://forslund.github.io/mycroft-desktop-repo bionic main" > /etc/apt/sources.list.d/mycroft-desktop.list
RUN apt-get update \
  && apt-get -y install mimic \
  && apt-get clean

# Install python packages
RUN pip3 install future msm

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai

# Clone and checkout Mycroft repository
WORKDIR /opt/mycroft
RUN git clone https://github.com/MycroftAI/mycroft-core.git .
RUN chmod +x ./start-mycroft.sh
RUN mkdir skills

# Install using wizard
# y: use master branch
# n: automatically update on Mycroft launch
# y: add helper commands to PATH
# n: check code style when submitting
RUN echo ynyn | CI=true ./dev_setup.sh --allow-root -sm
RUN mkdir scripts/logs
RUN touch scripts/logs/mycroft-bus.log
RUN touch scripts/logs/mycroft-voice.log
RUN touch scripts/logs/mycroft-skills.log
RUN touch scripts/logs/mycroft-audio.log
COPY startup.sh .
RUN chmod +x ./startup.sh

RUN echo "PATH=$PATH:/opt/mycroft/bin" >> $HOME/.bashrc \
  && echo "source /opt/mycroft/.venv/bin/activate" >> $HOME/.bashrc

EXPOSE 8181

ENTRYPOINT "/opt/mycroft/startup.sh"
