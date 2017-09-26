FROM ubuntu:16.04


ENV TERM linux
ENV ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -yq --no-install-recommends \
  apt-transport-https \
  python-pip \
  git \
  python-setuptools \
  curl \
  wget \
  sudo  \
  software-properties-common

RUN \
useradd -m mycroftai && echo "mycroftai:mycroftai" | chpasswd && adduser mycroftai sudo && \
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


COPY host_setup.sh /usr/local/bin/

USER mycroftai

# Install Server Dependencies for Mycroft
RUN \
  sudo sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  sudo apt-get update && \
  sudo apt-get -y upgrade && \
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F3B1AA8B && \
  sudo bash -c 'echo "deb http://repo.mycroft.ai/repos/apt/debian debian main" > /etc/apt/sources.list.d/repo.mycroft.ai.list' && \
  sudo apt-get update && \
  sudo apt-get install -f && \
  cd /usr/local/bin && \
  sudo /bin/bash host_setup.sh && \

  # Checkout Mycroft
  git clone https://github.com/MycroftAI/mycroft-core.git /home/mycroftai/mycroft-core && \
  cd /home/mycroftai/mycroft-core && \
  sudo easy_install pip==7.1.2 && \
  sudo pip install -r requirements.txt --trusted-host pypi.mycroft.team && \
  echo $(id -u) && \
  whoami && \
  pwd && \
  ls -lah && \
  /bin/bash dev_setup.sh && \
  sudo apt-get install -f && \
  sudo apt-get clean && \
  sudo rm -rf /var/lib/apt/lists/*

ENV PYTHONPATH $PYTHONPATH:/home/mycroftai
EXPOSE 8181
ENTRYPOINT ["tail", "-f", "/home/mycroftai/mycroft-core/scripts/logs/mycroft-skills.log"]
