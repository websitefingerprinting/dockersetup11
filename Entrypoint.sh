#!/bin/bash

# configures and runs a crawl (inside a docker container)
# IMPORTANT: If this file is changed, docker container needs to be rebuilt
DEVICE=eth0
BASE='/home/docker'

AUTO_CONFIG_PATH='/home/docker/tor-browser_en-US/Browser/defaults/pref/ '
TORRC_CONFIG_PATH='/home/docker/tor-browser_en-US/Browser/'
TORRC_PATH='/home/docker/tor-browser_en-US/Browser/TorBrowser/Data/Tor/torrc'


PT='wfdef'

wfd=$1
tag=$2
port=$3
fingerprint=$4
cert=$5
crawler=$6


# set offloads
ifconfig ${DEVICE} mtu 1500
ethtool -K ${DEVICE} tx off rx off tso off gso off gro off lro off

# cp TBB repository to container's own space
echo "Get TBB"
pushd ${BASE}
cp ./dockersetup/tor-browser_en-US.tar.xz ${BASE}/tor-browser_en-US-cp.tar.xz
tar -xf tor-browser_en-US-cp.tar.xz -C ${BASE}
chmod -R 777 ${BASE}/tor-browser_en-US/
rm ${BASE}/tor-browser_en-US-cp.tar.xz

# cp PT repository to container's own space.
echo "Get WFDefProxy"
cp -r /home/docker/${PT} /home/docker/${PT}-cp
chmod -R 777 /home/docker/${PT}-cp

# set user profile js file
cp /home/docker/dockersetup/autoconfig.js ${AUTO_CONFIG_PATH}
cp /home/docker/dockersetup/firefox.cfg ${TORRC_CONFIG_PATH}


# echo 'UseBridges 1' > ${TORRC_PATH}
# echo 'Bridge '${wfd}' 40.121.250.145:'${port}' '${fingerprint}' '${cert}'' >> ${TORRC_PATH}
echo 'ClientTransportPlugin '${wfd}' exec /home/docker/'${PT}'-cp/obfs4proxy/obfs4proxy' >> ${TORRC_PATH}



if [ "${wfd}" == "wfgan" ]; then
	echo "Start pyserver..."
	python3 /home/${PT}/transports/wfgan/grpc/py/server.py --log /home/docker/tor-config/pyserver_${tag}.log -c observer &
	sleep 5
fi


# # launch crawler
pushd ${BASE}/AlexaCrawler
export MOZ_HEADLESS=1

## TBB11 requires non-root to run 
sudo -u docker -H python ${crawler}
