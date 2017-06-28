FROM ubuntu:16.04

ENV TERM linux
ENV ENV DEBIAN_FRONTEND noninteractive

#For now copying deb files over to install
COPY pair.sh /usr/local/bin

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common

# Install Server Dependencies for Mycroft
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  add-apt-repository ppa:mycroft-ai/mycroft-ai && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -yq --no-install-recommends \
  apt-transport-https \
  mycroft-core && \
  apt-get install -f && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  service mycroft-messagebus start && \
  service mycroft-skills start


WORKDIR /home/mycroft
EXPOSE 8181
RUN ["chmod", "+x", "/usr/local/bin/pair.sh"]
CMD ["/bin/bash"]
