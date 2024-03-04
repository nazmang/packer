#!/bin/bash

# Root User Config
ROOT_PW="${ROOT_PASSWORD:-kali-root!}"
ROOT_SSH="${ROOT_SSH_KEY}"

# Custom User Config
KALI_USR="${KALI_USER:-kali}"
KALI_SSH="${KALI_SSH_KEY:-$ROOT_SSH}"
KALI_HOME="/home/$KALI_USR"

# Root SSH Configuration
mkdir -p /root/.ssh/
echo $ROOT_SSH >> /root/.ssh/authorized_keys
echo root:$ROOT_PW | /usr/sbin/chpasswd

# Custom User SSH Configuration
mkdir -p $KALI_HOME/.ssh/
echo $ROOT_SSH >> $KALI_HOME/.ssh/authorized_keys

# OpenSSH Config
mkdir /etc/ssh/default_keys
mv /etc/ssh/ssh_host_* /etc/ssh/default_keys
dpkg-reconfigure openssh-server
sed -i 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
systemctl enable --now ssh.service