# Docker install
Automated the install of docker on Debian to use manging my github pages on a seperate github account, because this one's messy and my domain points to a cleaner github account.

```
git clone REPO
chmod +x docker_post-install.sh docker_install.sh docker_orientation.sh 
su
./docker_post-install.sh; ./docker_install.sh
exit
./docker_orientation.sh
```

Run post-install script to add docker as a root user, 
the install script to install and configure, 
the orientation script to install a containerized docker.


### Why?
There are a few ways of switching Github accounts that I could have chosen, it seamed running it in a container on Docker would be a quick and easy way to do it.  Visiting Http://allen.tools might be clearer.
