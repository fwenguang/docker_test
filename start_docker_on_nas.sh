#!/bin/bash

current_dir=$(cd $(dirname $0); pwd)

container_name="${USER}_devel_pytorch"
image_name="yellow.hub.cambricon.com/pytorch/devel/x86_64/pytorch:v1.0-devel-x86_64-ubuntu18.04"

function usage() {
  echo "Usage:"
  echo "-c|--container_name     [docker container name. Default: ${container_name}]"
  echo "-i|--image_name         [devel docker image name. Default: ${image_name}]"
  exit -1
}

ARGS=`getopt -o c:i:h -l container_name:,image_name:,help -- "$@"`
eval set -- "${ARGS}"

while true
do
  case "$1" in
    -c|--container_name)
      container_name=$2
      shift 2
      ;;
    -i|--image_name)
      image_name=$2
      shift 2
      ;;
    -h|--help)
      usage
      shift 1
      ;;
    --)
      shift
      break
      ;;
    *)
      usage
      ;;
  esac
done

if [ "X${container_name}" == "X" ];then
  echo "please set container_name."
  usage
fi

NAS_HOME="/projs/framework/$(whoami)"
docker ps -a|grep -w ${container_name} > /dev/null 2>&1
if [ $? -eq 0 ];then
    echo "Found docker container: ${container_name} . Start it."
    docker start ${container_name}
    docker exec -it -w ${NAS_HOME} --use-nas-user ${container_name} /bin/bash
    docker exec -it ${container_name} /bin/bash
    if [ $? != 0 ];then
      echo "Maybe old dockerExec, will try to start docker again..."
      # docker exec -it -w ${NAS_HOME} --user=${USER} ${container_name} /bin/bash
      docker exec -it --user=${USER} ${container_name} /bin/bash
    fi
    exit 0
fi


BASIC_PARAM="--name=${container_name} --network=host --cap-add=sys_ptrace --shm-size=150gb"
DEVICES_LIST=""
for dev in `ls /dev/*|grep cambricon_`
do
    DEVICES_LIST="${DEVICES_LIST} --device=${dev} "
done
VOLUME_DIRS="-v /data:/data -v /tools:/tools -v /algo:/algo -v /projs/framework/${USER}:/projs/framework/${USER}"
CNMON_PATH=`which cnmon`
if [ "X${CNMON_PATH}" != "X" ];then
  VOLUME_DIRS="${VOLUME_DIRS} -v ${CNMON_PATH}:${CNMON_PATH}"
fi

echo "Start docker container[${container_name}] using image[${image_name}]."
docker run -dit ${BASIC_PARAM} ${DEVICES_LIST} ${VOLUME_DIRS} ${image_name}
docker exec -it ${container_name} /bin/bash -c "mkdir -p /home/${USER};chown `id -u`:`id -g` /home/${USER}"
docker cp ~/.ssh ${container_name}:/home/${USER}/.ssh
docker exec -it -w ${NAS_HOME} --use-nas-user ${container_name} /bin/bash
#docker exec -it ${container_name} /bin/bash
#if [ $? != 0 ];then
#  echo "Maybe old dockerExec, will try to start docker again..."
#  # docker exec -it -w ${NAS_HOME} --user=${USER} ${container_name} /bin/bash
#  docker exec -it --user=${USER} ${container_name} /bin/bash
#fi
