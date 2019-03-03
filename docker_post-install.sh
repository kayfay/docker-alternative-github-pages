#!/usr/bin/env bash
# https://docs.docker.com/install/linux/linux-postinstall/
# Steps for configuing user and groups as a docker user to run 
# the Docker daemon as a Unix socket. 
# For additional config options see URL.

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

# Add user
echo "docker added as user with group docker"
groupadd docker
usermod -a -G docker $USER

echo "re-evaluate membership logout of current session (e.g., pkill -u username)"
echo "Test with docker run hello-world"

# Configure at startup
echo "Select option"
echo "1. Configure docker on startup."
echo "2. Disable docker on startup."
echo "0. Exit"
read startup

case $startup in
1*)
  systemctl enable docker
;;
2*)
  systemctl disable docker
;;
*)
;;
esac

exit
