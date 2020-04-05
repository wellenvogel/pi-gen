#!/bin/bash -eu
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR || exit 1

BUILD_OPTS="$*"

DOCKER="docker"

if ! ${DOCKER} ps >/dev/null 2>&1; then
	DOCKER="sudo docker"
fi
if ! ${DOCKER} ps >/dev/null; then
	echo "error connecting to docker:"
	${DOCKER} ps
	exit 1
fi

CONFIG_FILE=""
if [ -f "${DIR}/config" ]; then
	CONFIG_FILE="${DIR}/config"
fi

TAG=""
while getopts "c:t:" flag
do
	case "${flag}" in
		c)
			CONFIG_FILE="${OPTARG}"
			;;
		t)
			TAG="${OPTARG}"
			;;
		*)
			;;
	esac
done

# Ensure that the configuration file is an absolute path
if test -x /usr/bin/realpath; then
	CONFIG_FILE=$(realpath -s "$CONFIG_FILE")
fi

# Ensure that the confguration file is present
if test -z "${CONFIG_FILE}"; then
	echo "Configuration file need to be present in '${DIR}/config' or path passed as parameter"
	exit 1
else
	# shellcheck disable=SC1090
	source "${CONFIG_FILE}"
fi

LOCAL_CFG="_config"

[ -f $LOCAL_CFG ] && rm -f $LOCAL_CFG

cp $CONFIG_FILE $LOCAL_CFG || exit 1

CONTAINER_NAME=${CONTAINER_NAME:-pigen_work}
CONTINUE=${CONTINUE:-0}
PRESERVE_CONTAINER=${PRESERVE_CONTAINER:-1}

if [ -z "${IMG_NAME}" ]; then
	echo "IMG_NAME not set in 'config'" 1>&2
	echo 1>&2
exit 1
fi

#inside container
WORK_DIR="/work/${IMG_NAME}"
DEPLOY_DIR="/deploy"
# Ensure the Git Hash is recorded before entering the docker container
GIT_HASH=${GIT_HASH:-"$(git rev-parse HEAD)"}

CONTAINER_EXISTS=$(${DOCKER} ps -a --filter name="${CONTAINER_NAME}" -q)
CONTAINER_RUNNING=$(${DOCKER} ps --filter name="${CONTAINER_NAME}" -q)
if [ "${CONTAINER_RUNNING}" != "" ]; then
	echo "The build is already running in container ${CONTAINER_NAME}. Aborting."
	exit 1
fi
if [ "${CONTAINER_EXISTS}" != "" ] && [ "${CONTINUE}" != "1" ]; then
	echo "Container ${CONTAINER_NAME} already exists and you did not specify CONTINUE=1. Aborting."
	echo "You can delete the existing container like this:"
	echo "  ${DOCKER} rm -v ${CONTAINER_NAME}"
	exit 1
fi
# Modify original build-options to allow config file to be mounted in the docker container
BUILD_OPTS="$(echo "${BUILD_OPTS:-}" | sed -E 's@\-c\s?([^ ]+)@-c '$LOCAL_CFG'@')"


${DOCKER} build -t pi-gen "${DIR}"
trap 'echo "signalhandler:... please wait " && ${DOCKER} stop -t 2 ${CONTAINER_NAME}' SIGINT SIGTERM 0
if [ "${CONTAINER_EXISTS}" != "" ]; then
	${DOCKER} start ${CONTAINER_NAME}
else
	${DOCKER} run --name "${CONTAINER_NAME}" --privileged -d \
		--volume "${DIR}":/pi-gen:ro \
		pi-gen \
		bash -c "while true ; do sleep 1; done"
fi
( time ${DOCKER} exec ${CONTAINER_NAME} \
	bash -e -o pipefail -c "dpkg-reconfigure qemu-user-static &&
	cd /pi-gen; WORK_DIR=$WORK_DIR DEPLOY_DIR=$DEPLOY_DIR GIT_HASH=$GIT_HASH ./build.sh ${BUILD_OPTS}" )
echo "stopping ${CONTAINER_NAME}"
${DOCKER} stop -t 2 ${CONTAINER_NAME}
if [ "$TAG" = "" ] ; then
	echo "build finished, no image created, container=$CONTAINER_NAME"
	exit 0
fi
echo "commiting to ${TAG}"
${DOCKER} commit "${CONTAINER_NAME}" "${TAG}"
