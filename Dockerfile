FROM ubuntu:17.10

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

# Install Server Dependencies for Mycroft
RUN set -x \
	&& sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -yq --no-install-recommends \
		alsa-utils \
		apt-transport-https \
		autoconf \
		automake \
		avrdude \
		bison \
		build-essential \
		curl \
		dnsmasq \
		flac \
		git \
		jq \
		libicu-dev \
		libfann-dev \
		libffi-dev \
		libglib2.0-dev \
		libjpeg-dev \
		libssl-dev \
		libtool \
		locales \
		mpg123 \
		pkg-config \
		portaudio19-dev \
		pulseaudio \
		python \
		python-dev \
		python-setuptools \
		python-virtualenv \
		python-gobject-dev \
		s3cmd \
		screen \
		software-properties-common \
		sudo \
		supervisor \
		swig \
		virtualenvwrapper \
		wget \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F3B1AA8B \
	&& bash -c 'echo "deb http://repo.mycroft.ai/repos/apt/debian debian main" > /etc/apt/sources.list.d/repo.mycroft.ai.list' \
	&& apt-get update \
	&& apt-get install -yq --no-install-recommends \
		mimic \
	# Checkout Mycroft
	&& git clone https://github.com/MycroftAI/mycroft-core.git /opt/mycroft \
	&& cd /opt/mycroft \
	&& mkdir /opt/mycroft/skills \
	# git fetch && git checkout dev && \ this branch is now merged to master
	&& easy_install pip \
	&& pip install -r requirements.txt --trusted-host pypi.mycroft.team \
	&& /opt/mycroft/./dev_setup.sh --allow-root -sm \
	&& mkdir /opt/mycroft/scripts/logs \
	&& touch /opt/mycroft/scripts/logs/mycroft-bus.log \
	&& touch /opt/mycroft/scripts/logs/mycroft-voice.log \
	&& touch /opt/mycroft/scripts/logs/mycroft-skills.log \
	&& touch /opt/mycroft/scripts/logs/mycroft-audio.log \
	&& /opt/mycroft/msm/msm default \
	&& apt-get install -f \
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

RUN chmod +x /opt/mycroft/start-mycroft.sh \
	&& chmod +x /opt/mycroft/startup.sh \
	&& /bin/bash /opt/mycroft/start-mycroft.sh all

EXPOSE 8181

ENTRYPOINT ["/bin/bash", "/opt/mycroft/startup.sh"]
