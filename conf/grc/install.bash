#!/usr/bin/env bash

mkdir -p ~/.grc

if [[ -e ~/.grc/grc.conf ]] ; then
    cat ~/.grc/grc.conf | grep colcon > /dev/null
    if [[ ! $? ]] ; then
        echo "Appending grc.conf to ~/.grc/grc.conf"
        cat grc.conf >> ~/.grc/grc.conf
    else
        echo "~/.grc/grc.conf already has a rule for colcon"
    fi
else
    echo "Appending grc.conf to ~/.grc/grc.conf"
    cat grc.conf >> ~/.grc/grc.conf
fi

if [[ -e ~/.grc/conf.colcon ]] ; then
    echo "~/.grc/conf.colcon already exsists, not overwriting"
else
    echo "Copying conf.colcon to ~/.grc/conf.colcon"
    cp conf.colcon ~/.grc/conf.colcon
fi
