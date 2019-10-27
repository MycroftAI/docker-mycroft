FROM ubuntu:18.04

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

# Install packages required by Mycroft
RUN set -x \
  && sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
  && apt-get update \
  && apt-get -y install git python3 python3-pip locales sudo \
  && pip3 install future msm \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl https://forslund.github.io/mycroft-desktop-repo/mycroft-desktop.gpg.key | apt-key add - 2> /dev/null \
  && echo "deb http://forslund.github.io/mycroft-desktop-repo bionic main" > /etc/apt/sources.list.d/mycroft-desktop.list
RUN apt-get update && apt-get install -y mimic

# Clone and checkout Mycroft repository
RUN git clone https://github.com/MycroftAI/mycroft-core.git /opt/mycroft
WORKDIR /opt/mycroft
RUN mkdir /opt/mycroft/skills
RUN CI=true ./dev_setup.sh --allow-root -sm
RUN mkdir /opt/mycroft/scripts/logs
RUN touch /opt/mycroft/scripts/logs/mycroft-bus.log
RUN touch /opt/mycroft/scripts/logs/mycroft-voice.log
RUN touch /opt/mycroft/scripts/logs/mycroft-skills.log
RUN touch /opt/mycroft/scripts/logs/mycroft-audio.log

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /opt/mycroft
COPY startup.sh /opt/mycroft
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai

RUN echo "PATH=$PATH:/opt/mycroft/bin" >> $HOME/.bashrc \
  && echo "source /opt/mycroft/.venv/bin/activate" >> $HOME/.bashrc

RUN chmod +x /opt/mycroft/start-mycroft.sh \
  && chmod +x /opt/mycroft/startup.sh

EXPOSE 8181

ENTRYPOINT "/opt/mycroft/startup.sh"
