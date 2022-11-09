# This dockerfile allows to run an crawl inside a docker container

# Pull base image.
#FROM ubuntu:18.04
FROM python:3.7

# Install required packages.
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install sudo build-essential autoconf git zip unzip xz-utils apt-utils psmisc vim
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install firefox-esr xvfb
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install libtool libevent-dev libssl-dev zlib1g  zlib1g-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install python3 python3-dev python3-setuptools python3-pip
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install net-tools ethtool tshark libpcap-dev iw tcpdump


RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone


# Install python requirements.
RUN pip install --upgrade pip
RUN pip install numpy
RUN pip install pandas
RUN pip install selenium
RUN pip install scapy 
RUN pip install stem
RUN pip install psutil
RUN pip install requests
RUN pip install grpcio-tools==1.33.2
RUN pip install tbselenium
# RUN pip install torch==1.7.0+cpu torchvision==0.8.1+cpu torchaudio==0.7.0 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install torch==1.5.0+cpu torchvision==0.6.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install joblib
RUN pip install scikit-learn==0.23.2
RUN pip install pyvirtualdisplay
RUN pip install tcconfig

# # add host user to container
RUN adduser --system --group --disabled-password --gecos '' --shell /bin/bash docker


# download geckodriver
ADD https://github.com/mozilla/geckodriver/releases/download/v0.31.0/geckodriver-v0.31.0-linux64.tar.gz /bin/
RUN tar -zxvf /bin/geckodriver* -C /bin/
ENV PATH /bin/geckodriver:$PATH


# Set the display
ENV DISPLAY $DISPLAY

