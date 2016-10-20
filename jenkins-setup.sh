#!/bin/bash

GERRIT_NAME=$1
GERRIT_WEBURL=$2
JENKINS_WEBURL=$3
NEXUS_REPO=$4

# Replace '/' in url to '\/'
[ "${JENKINS_WEBURL%/}" = "${JENKINS_WEBURL}" ] && JENKINS_WEBURL="${JENKINS_WEBURL}/"
while [ -n "${JENKINS_WEBURL}" ]; do
JENKINS_URL="${JENKINS_URL}${JENKINS_WEBURL%%/*}\/"
JENKINS_WEBURL="${JENKINS_WEBURL#*/}"
done

# Setup Jenkins url and system admin e-mail
cp /usr/local/etc/jenkins.model.JenkinsLocationConfiguration.xml \
  ${JENKINS_HOME}/jenkins.model.JenkinsLocationConfiguration.xml
sed -i "s/{JENKINS_URL}/${JENKINS_URL}/g" \
  ${JENKINS_HOME}/jenkins.model.JenkinsLocationConfiguration.xml

# Setup Jenkins Docker
cp /usr/local/etc/config.xml ${JENKINS_HOME}/config.xml
