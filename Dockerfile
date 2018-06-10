FROM ubuntu:17.10

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

# Install Server Dependencies for Mycroft
RUN set -x \
	&& sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get -y install git python3 python3-pip locales future msm \
	# Checkout Mycroft
	&& git clone https://github.com/MycroftAI/mycroft-core.git /opt/mycroft \
	&& cd /opt/mycroft \
	&& mkdir /opt/mycroft/skills \
	# git fetch && git checkout dev && \ this branch is now merged to master
	&& /opt/mycroft/./dev_setup.sh --allow-root -sm \
	&& mkdir /opt/mycroft/scripts/logs \
	&& touch /opt/mycroft/scripts/logs/mycroft-bus.log \
	&& touch /opt/mycroft/scripts/logs/mycroft-voice.log \
	&& touch /opt/mycroft/scripts/logs/mycroft-skills.log \
	&& touch /opt/mycroft/scripts/logs/mycroft-audio.log \
	&& apt-get -y autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /opt/mycroft
COPY startup.sh /opt/mycroft
ENV PYTHONPATH $PYTHONPATH:/mycroft/ai

RUN /bin/bash -c "source /opt/mycroft/.venv/bin/activate" \
    chmod +x /opt/mycroft/start-mycroft.sh \
	&& chmod +x /opt/mycroft/startup.sh \
	&& /bin/bash /opt/mycroft/start-mycroft.sh all

EXPOSE 8181

ENTRYPOINT ["/bin/bash", "/opt/mycroft/startup.sh"]
