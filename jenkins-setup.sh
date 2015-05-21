#!/bin/bash

GERRIT_NAME=$1
GERRIT_WEBURL=$2
JENKINS_WEBURL=$3
NEXUS_WEBURL=$4

# Replace '/' in url to '\/'
[ "${GERRIT_WEBURL%/}" = "${GERRIT_WEBURL}" ] && GERRIT_WEBURL="${GERRIT_WEBURL}/"
while [ -n "${GERRIT_WEBURL}" ]; do
GERRIT_URL="${GERRIT_URL}${GERRIT_WEBURL%%/*}\/"
GERRIT_WEBURL="${GERRIT_WEBURL#*/}"
done

# Setup gerrit-trigger.xml
cp /usr/local/etc/gerrit-trigger.xml ${JENKINS_HOME}/gerrit-trigger.xml
sed -i "s/{GERRIT_NAME}/${GERRIT_NAME}/g" ${JENKINS_HOME}/gerrit-trigger.xml
sed -i "s/{GERRIT_URL}/${GERRIT_URL}/g" ${JENKINS_HOME}/gerrit-trigger.xml

# Setup credentials.xml
cp /usr/local/etc/credentials.xml ${JENKINS_HOME}/credentials.xml

# Setup maven installation
cp /usr/local/etc/hudson.tasks.Maven.xml ${JENKINS_HOME}/hudson.tasks.Maven.xml
mkdir -p /var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation
unzip -q /usr/local/etc/apache-maven-3.2.2-bin.zip -d /var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation
mv /var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation/apache-maven-3.2.2 \
   /var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation/Maven-3.2.2
cp /usr/local/etc/.installedFrom \
   /var/jenkins_home/tools/hudson.tasks.Maven_MavenInstallation/Maven-3.2.2/.installedFrom

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

# Setup nexus as maven mirror if defined
if [ ${#NEXUS_WEBURL} -gt 0 ]; then
  # Replace '/' in url to '\/'
  [ "${NEXUS_WEBURL%/}" = "${NEXUS_WEBURL}" ] && NEXUS_WEBURL="${NEXUS_WEBURL}/"
  while [ -n "${NEXUS_WEBURL}" ]; do
  NEXUS_URL="${NEXUS_URL}${NEXUS_WEBURL%%/*}\/"
  NEXUS_WEBURL="${NEXUS_WEBURL#*/}"
  done
  NEXUS_URL="${NEXUS_URL%\\/}"

  # Setup maven repository mirror
  mkdir -p ${JENKINS_HOME}/.m2
  cp /usr/local/etc/settings.xml ${JENKINS_HOME}/.m2/settings.xml
  sed -i "s/{{NEXUS_URL}}/${NEXUS_URL}/g" ${JENKINS_HOME}/.m2/settings.xml
fi
