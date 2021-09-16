FROM ubuntu

RUN apt install \
    curl \
    wget

ENV HOME="/home/orasdiscover"
RUN mkdir -p $HOME/scripts

COPY ./scripts $HOME/scripts
RUN chmod ugo+rwx $HOME/scripts/demo_discover.sh


