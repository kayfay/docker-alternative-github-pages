#!/bin/bash

# Reports version, tests installation, provides help details
# Creates git clone for docker installation
set -o errexit

# Create log variables
LOG_DIR=/var/log/
LOG_FILE=docker_install.log
LOG_PATH="$LOG_DIR$LOG_FILE"

# Test for docker install
BIN_PATH=/usr/bin/docker

if [ -f "$BIN_PATH" ]
then
  echo "Is docker installed, has docker_install been executed?"
  echo "docker_orientation run without docker install" >> "$LOGPATH"
  exit 1
fi

# Report version
docker --version

# Report info about installation
docker info

# Configure docker with git
docker pull alpine/git &
wait $1

docker run -ti --rm -v ${HOME}:/root -v \
  ${pwd}:/git alpine/git \
  clone https://github.com/alpine-docker/git.git &
wait $1

docker run -ti --rm -v $(pwd):/git -v $HOME/.ssh:/root/.ssh alpine/git &
wait $1

echo -n "Enter repo (e.g., user/repo): "
read name

git clone git@github.com:"$name" &
wait $1

# List all images
docker image ls

# List currently spawned containers
docker container ls --all

echo "Edit files;"
echo "alias git=docket run -ti --rm -v $(pwd):/git -v $HOME/.ssh:/root/.ssh alpine/git"
echo "git add ."
echo "git status"
echo 'git commit -m "test"'
echo "git push -u origin master"
echo "When done."

exit
