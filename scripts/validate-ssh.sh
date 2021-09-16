#!/bin/bash

if [ -f "$HOME/.ssh/ssh_config" ]
then
        echo "Found folder"
        exit 0
else
        echo "Did not find folder"
        exit 1
fi
