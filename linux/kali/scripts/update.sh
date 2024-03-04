#!/bin/bash

apt-get -y -qq update
DEBIAN_FRONTEND=noninteractive apt-get -y -qq dist-upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y -qq install linux-headers-$(uname -r)

apt-get -y autoclean && apt-get -y clean 

