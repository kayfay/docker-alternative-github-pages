#!/bin/bash
# https://docs.docker.com/install/linux/docker-ce/debian/#upgrade-docker-ce-1
# Adapted from documention to install docker on debian

# Creates log files in /var/log
LOG_DIR=/var/log/
LOG_FILE=docker_install.log
LOG_PATH="$LOG_DIR$LOG_FILE"
ROOT_UID=0

if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Script must be run as root user, (invoke su before running)."
  exit 1
fi

# Set up Repo
# Update the apt package index
apt update &
wait $1

# Install packages for apt over HTTP
apt-get -y install apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  software-properties-common &
wait $1

# Add Docker's GPG key
CURL="/usr/bin/curl"
GPG_URL="https://download.docker.com/linux/debian/gpg"
CURLARGS="-f -s -S -L"
$CURL $CURLARGS $GPG_URL | apt-key add -

# Setup repo
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" &
wait $1

# Write to log repo set up verification data
apt-key fingerprint 0EBFCD88 >> "$LOG_PATH" &
echo "Verify matching" >> "$LOG_PATH"
echo "9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88" >> "$LOG_PATH"
echo "Repository set up."
wait $1

# Update the apt package index
apt update &
wait $1
apt-get -y install docker-ce docker-ce-cli containerd.io &
wait $1


cat "Docker installed." >> "$LOG_PATH"
echo "Docker installed."
echo 'Type "docker run hello-world" to test.'

exit
