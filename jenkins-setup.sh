#!/bin/bash

GERRIT_NAME=$1
GERRIT_WEBURL=$2
JENKINS_WEBURL=$3
NEXUS_REPO=$4

# Setup Jenkins Docker
cp /usr/local/etc/config.xml ${JENKINS_HOME}/config.xml
