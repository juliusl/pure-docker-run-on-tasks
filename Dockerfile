FROM docker

RUN apt-get update && apt-get -y install \
    curl \
    wget

ENV HOME="/home/orasdiscover"
RUN mkdir -p $HOME/scripts

COPY ./scripts $HOME/scripts
VOLUME 
RUN chmod +x $HOME/scripts/demo_discover.sh

