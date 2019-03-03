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

# Install docker-machine
base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  install /tmp/docker-machine /usr/local/bin/docker-machine &
wait $1

# Write versions to log
docker --version >> "$LOG_PATH"
docker-machine version >> "$LOG_PATH"

# Install bash completion scripts
TAB_COMP_DIR="/etc/bash_completion.d"
if [ ! -d "$TAB_COMP_DIR" ]
then
  mkdir "$TAB_COMP_DIR"
fi

base=https://raw.githubusercontent.com/docker/machine/v0.16.0
for i in docker-machine-prompt.bash docker-machine-wrapper.bash docker-machine.bash
do
  wget "$base/contrib/completion/bash/${i}" -P /etc/bash_completion.d
done

source /etc/bash_completion.d/docker-machine-prompt.bash
echo 'Make sure to run "source /etc/bash_completion.d/docker-machine-prompt.bash"'

echo "Docker installed."
echo 'Type "docker run hello-world" to test.'

exit
