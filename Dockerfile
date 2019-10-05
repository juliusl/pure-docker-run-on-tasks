FROM alpine

ENV HOME="/home/test"

RUN mkdir $HOME $HOME/.ssh $HOME/scripts

# Comment the next line if you want to simulate a failure in the tasks.yaml file
COPY ./config $HOME/.ssh/
COPY ./scripts $HOME/scripts/

# I'm running from a windows machine so when I authored the .sh it used windows line endings, this 
# fixes that
RUN apk add dos2unix & dos2unix $HOME/scripts/*.sh
RUN chmod ugo+rwx $HOME/scripts/validate-ssh.sh
