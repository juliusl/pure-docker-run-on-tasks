FROM ubuntu

ENV HOME="/home/orasdiscover"
RUN mkdir -p $HOME/scripts

COPY ./scripts $HOME/scripts/demo_discover.sh
RUN chmod ugo+rwx $HOME/scripts/demo_discover.sh


