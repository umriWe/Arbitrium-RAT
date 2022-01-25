#!/bin/bash


printf "
    _         _     _ _        _                   ____      _  _____ 
   / \   _ __| |__ (_) |_ _ __(_)_   _ _ __ ___   |  _ \    / \|_   _|
  / _ \ |  __|  _ \| | __|  __| | | | |  _   _ \  | |_) |  / _ \ | |  
 / ___ \| |  | |_) | | |_| |  | | |_| | | | | | | |  _ <  / ___ \| |  
/_/   \_\_|  |_.__/|_|\__|_|  |_|\__,_|_| |_| |_| |_| \_\/_/   \_\_|  

"



if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi


SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH




if [ "$1" == "" ]
then
    echo "No Dockerfile. Usage: run main.py to handle the setup or ./setup.sh abs_path_Dockerfile"
    exit 1
fi



if ! command -v docker &> /dev/null
then
    echo "[+] Docker installation ..."
	apt update
	apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
	printf '%s\n' "deb https://download.docker.com/linux/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg
    apt update
	apt install -y docker-ce docker-ce-cli containerd.io
fi



if ! docker images 2>&1 | grep arbitrium-rat
then
	echo "[+] Building docker image ..."
	docker build -f "$1" -t benchaliah/arbitrium-rat .
	echo "[!] Installation finished"
	exit
else
	echo "[!] Already installed, use main.py if you wish to customize the existing image"
	exit 1
fi
