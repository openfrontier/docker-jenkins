#!/bin/bash
set -e
JENKINS_NAME='jenkins-master'
LOCAL_VOLUME=~/jenkins_volume
docker stop $JENKINS_NAME
docker rm -v $JENKINS_NAME
rm -rf ${LOCAL_VOLUME}
