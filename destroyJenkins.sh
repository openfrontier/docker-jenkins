#!/bin/bash

JENKINS_NAME=${JENKINS_NAME:-jenkins-master}
LOCAL_VOLUME=~/jenkins_volume${SUFFIX}

docker stop $JENKINS_NAME
docker rm -v $JENKINS_NAME
rm -rf "${LOCAL_VOLUME}"
