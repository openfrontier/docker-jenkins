#!/bin/bash

GERRIT_WEBURL=$2
JENKINS_WEBURL=$3

# Replace '/' in url to '\/'
[ "${GERRIT_WEBURL%/}" = "${GERRIT_WEBURL}" ] && GERRIT_WEBURL="${GERRIT_WEBURL}/"
while [ -n "${GERRIT_WEBURL}" ]; do
GERRIT_URL="${GERRIT_URL}${GERRIT_WEBURL%%/*}\/"
GERRIT_WEBURL="${GERRIT_WEBURL#*/}"
done

# Setup gerrit-trigger.xml
cp /usr/local/etc/gerrit-trigger.xml ${JENKINS_HOME}/gerrit-trigger.xml
sed -i "s/{GERRIT_NAME}/$1/g" ${JENKINS_HOME}/gerrit-trigger.xml
sed -i "s/{GERRIT_URL}/${GERRIT_URL}/g" ${JENKINS_HOME}/gerrit-trigger.xml

# Setup credentials.xml
cp /usr/local/etc/credentials.xml ${JENKINS_HOME}/credentials.xml

# Setup maven installation
cp /usr/local/etc/hudson.tasks.Maven.xml ${JENKINS_HOME}/hudson.tasks.Maven.xml

# Replace '/' in url to '\/'
[ "${JENKINS_WEBURL%/}" = "${JENKINS_WEBURL}" ] && JENKINS_WEBURL="${JENKINS_WEBURL}/"
while [ -n "${JENKINS_WEBURL}" ]; do
JENKINS_URL="${JENKINS_URL}${JENKINS_WEBURL%%/*}\/"
JENKINS_WEBURL="${JENKINS_WEBURL#*/}"
done

# Setup Jenkins url and system admin e-mail
cp /usr/local/etc/jenkins.model.JenkinsLocationConfiguration.xml ${JENKINS_HOME}/jenkins.model.JenkinsLocationConfiguration.xml
sed -i "s/{JENKINS_URL}/${JENKINS_URL}/g" ${JENKINS_HOME}/jenkins.model.JenkinsLocationConfiguration.xml
