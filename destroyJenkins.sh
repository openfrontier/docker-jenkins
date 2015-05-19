#!/bin/bash

JENKINS_NAME=${JENKINS_NAME:-jenkins}
JENKINS_VOLUME=${JENKINS_VOLUME:-jenkins-volume}

docker stop ${JENKINS_NAME}
docker rm -v ${JENKINS_NAME}
docker rm -v ${JENKINS_VOLUME}
