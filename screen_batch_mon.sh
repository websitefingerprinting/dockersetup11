#!/bin/bash
host=c1


port=443
wfd=null


fingerprint=3D78AD56A9D95CF08CB3FFCF96DD7F0C9565368E

time=1s
date +"%H:%M:%S"  
sleep ${time}

# end time  
date +"%H:%M:%S"  


echo "begin"

LOG_DIR=/home/jgongac/tor-config

pushd /home/jgongac/dockersetup11
# make clean

# kill all finished screen sessions
# screen -ls | grep Dsctached | cut -d. -f1 | awk '{print $1}' | xargs kill

# create sessions

host_num=12


for i in $(seq 1 $host_num);
do
   screen -dmS "tbb$i" -L -Logfile ${LOG_DIR}/${host}_tbb${i}_screen.log make run tag=${host}_tbb$i  port=${port} wfd=${wfd} cert="${cert}" fingerprint=${fingerprint};
   sleep 2;
done
