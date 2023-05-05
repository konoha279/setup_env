#!/bin/bash
RED='\033[0;31m'
PURP='\033[0;35m'
WHITE="\[\033[0;37m\]"

if [[ $EUID -ne 0 ]]; then
	printf "${RED}This script must be run as root.\n${WHITE}"
	printf "${PURP}Usage: ${RED}sudo ./setup.sh\n${WHITE}"
	exit
else
	sudo apt-get update
	sudo apt-get install \
	    ca-certificates \
	    curl \
	    gnupg
	sudo mkdir -m 0755 -p /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg
	echo \
	  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  	sudo apt-get update
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	# check version
	docker-compose --version
fi
