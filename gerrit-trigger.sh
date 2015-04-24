#!/bin/bash

URL=$2

# Replace '/' in url to '\/'
[ "${URL%/}" = "${URL}" ] && URL="${URL}/"
while [ -n "${URL}" ]; do
REPLACE_URL="${REPLACE_URL}${URL%%/*}\/"
URL="${URL#*/}"
done

# Setup gerrit-trigger.xml
cp /usr/local/etc/gerrit-trigger.xml ${JENKINS_HOME}/gerrit-trigger.xml
sed -i "s/{GERRIT_NAME}/$1/g" ${JENKINS_HOME}/gerrit-trigger.xml
sed -i "s/{GERRIT_WEBURL}/${REPLACE_URL}/g" ${JENKINS_HOME}/gerrit-trigger.xml
