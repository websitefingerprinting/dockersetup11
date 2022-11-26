# all: build test stop

# this is to forward X apps to host:
# See: http://stackoverflow.com/a/25280523/1336939
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth

# paths
BASE_PATH=/home/docker
GUEST_SSH=/home/docker/.ssh
DOCKERSETUP_PATH=/home/docker/dockersetup
TORCONFIG_PATH=/home/docker/tor-config
# TBB_PATH=/home/docker/tor-browser_en-US/

# Configuration
# !! Remember to check the crawler folder name
HOST_CRAWL_PATH=${HOME}/AlexaCrawler
HOST_TORCONFIG_PATH=${HOME}/tor-config
HOST_SSH=${HOME}/.ssh
HOST=${HOME}

ENV_VARS = \
	--env="DISPLAY=${DISPLAY}" 					\
	--env="XAUTHORITY=${XAUTH}"					\
	--env="VIRTUAL_DISPLAY=$(VIRTUAL_DISPLAY)"  \
	--env="START_XVFB=true"                    \

VOLUMES = \
	--volume=${XSOCK}:${XSOCK}					                    \
	--volume=${XAUTH}:${XAUTH}					                    \
	--volume=${HOST_SSH}:${GUEST_SSH}			                    \
	--volume=${HOST}/AlexaCrawler:${BASE_PATH}/AlexaCrawler	        \
	--volume=${HOST}/wfdef:${BASE_PATH}/wfdef                       \
	--volume=${HOST_TORCONFIG_PATH}:${TORCONFIG_PATH}               \
 	--volume=`pwd`:${DOCKERSETUP_PATH}  							\



port=443
tag=tbb1

start=0
end=100

m=5
b=2
mode=clean
open=0

fingerprint=3D78AD56A9D95CF08CB3FFCF96DD7F0C9565368E




## null
wfd=null
cert=""
## wfgan
# wfd=wfgan
# cert=cert=LubkJsz3j1Fx7lXaWFZok2yJdomEyBC41QZ4YBYdNmD+Kue8JcWBa6UIo6c7s+lyWe+tCA tol=0.4
## tamaraw
# wfd=tamaraw
# cert=cert=5iFm0lM0PMawmxtTtYSBwjkVODPrMLYz0DK960xPrrIUDl6uPObHGgan69FUFsDM4cwKSg nseg=100 rho-server=6 rho-client=14
## front
# wfd=front
# cert=cert=BsW9EOnSWm4I3lOQBHJ8LXwr84/Qch79DE/+NTvUWQCsipdE/hSbxd+JWAeC0LKQpUGkCQ w-min=1.0 w-max=14.0 n-server=6000 n-client=6000

# wfd=tamaraw
# cert=cert=zWHuJU+yPk8SSlz7WV/DQla7eNKOymD2K/7Rl5Rb/0Aa205YsxXVbPlgOvX8IPnpwp8AEw nseg=100 rho-server=4 rho-client=14

## randomwt
# wfd=randomwt
# cert=cert=nXfBSILXXb8XNlKrbURlXJermVoAdphZrojPPZ1RGQPxqZkKQB8lIcGyrBunJrRyrLjPBA n-client-real=0 n-server-real=0 n-client-fake=0 n-server-fake=0 p-fake=0.0
# wfd=randomwt
# cert=cert=8a20VdeVCADR12iCE4peEBSs0DVfcxz0cDWdcnRBTJFtVJ4EVp2BxedEhHeAtsIJ430rAQ n-client-real=4 n-server-real=45 n-client-fake=8 n-server-fake=90 p-fake=0.4

## regulator
# wfd=regulator
# cert=cert=CVKlw8ZvSbz/gRMYIfjUpbLgXSkcKjlJ/kHjSy/YcWlwiioOp0ZN0Qfv77DK3JGF2N/sFA r=277 d=0.94 t=3.55 n=3550 u=3.95 c=1.77

#commandline arguments
CRAWL_PARAMS=--start ${start} --end ${end} -m ${m} -b ${b} \
--open ${open} --headless\
--who ${tag} --mode ${mode} \
--tbblog ${TORCONFIG_PATH}/torclient-${tag}.log  \
-w sites/Tranco_26Oct_2022_top10k_filtered_cp.list \
--randomize 
# -l ${BASE_PATH}/AlexaCrawler/list/extra.list -s

# Make routines
build:
	@docker build -t tbcrawl11 --rm .

init:
	@mkdir -p ${HOST}/AlexaCrawler/dump
	@mkdir -p ${HOST}/tor-config
	@chmod 777 ${HOST}/AlexaCrawler/dump
	@chmod 777 ${HOST}/tor-config
run:
	@docker run -it --rm --name ${tag} ${ENV_VARS} ${VOLUMES}  --shm-size 2g --net=bridge  \
	--privileged tbcrawl11 ${DOCKERSETUP_PATH}/Entrypoint.sh "$(wfd)" "$(tag)" "$(port)" "$(fingerprint)" "$(cert)" "crawler.py $(CRAWL_PARAMS)"
shell:
	@docker run -it --rm --name ${tag} ${ENV_VARS} ${VOLUMES}  --shm-size 2g --net=bridge  \
	--privileged tbcrawl11 /bin/bash
clean:
# 	@rm -rf ${HOST_CRAWL_PATH}/dump/*
	@rm -rf ${HOST_CRAWL_PATH}/parsed/*
	@rm -rf ${HOST_TORCONFIG_PATH}/torclient-*.log
	@rm -rf ${HOST_TORCONFIG_PATH}/*_screen.log
	@rm -rf ${HOST_TORCONFIG_PATH}/pyserver*.log
	@rm -rf ${HOST_TORCONFIG_PATH}/tunnel-client-*/pt_state/obfs4proxy.log
stop:
	@docker stop `docker ps -a -q -f ancestor=tbcrawl11`
	@docker rm `docker ps -a -q -f ancestor=tbcrawl11`

destroy:
	@docker rmi -f tbcrawl11

reset: stop destroy
