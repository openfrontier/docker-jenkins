#!/bin/bash
set -e
JENKINS_NAME=${JENKINS_NAME:-jenkins}
JENKINS_VOLUME=${JENKINS_VOLUME:-jenkins-volume}
GERRIT_NAME=${GERRIT_NAME:-gerrit}
JENKINS_IMAGE_NAME=${JENKINS_IMAGE_NAME:-openfrontier/jenkins}
JENKINS_OPTS=${JENKINS_OPTS:---prefix=/jenkins}
TIMEZONE=${TIMEZONE:-Asia/Shanghai}
CI_NETWORK=${CI_NETWORK:-ci-network}

# Create Jenkins volume.
if [ -z "$(docker ps -a | grep ${JENKINS_VOLUME})" ]; then
    docker run \
    --name ${JENKINS_VOLUME} \
    --entrypoint="echo" \
    ${JENKINS_IMAGE_NAME} \
    "Create Jenkins volume."
fi

# Start Jenkins.
docker run \
--name ${JENKINS_NAME} \
--net ${CI_NETWORK} \
-p 50000:50000 \
--volumes-from ${JENKINS_VOLUME} \
-e JAVA_OPTS="-Duser.timezone=${TIMEZONE}" \
-e LDAP_SERVER=${LDAP_SERVER} \
-e LDAP_ROOTDN=${LDAP_ACCOUNTBASE} \
-e LDAP_INHIBIT_INFER_ROOTDN=false \
-e LDAP_DISABLE_MAIL_ADDRESS_RESOLVER=false \
-e GERRIT_HOST_NAME=${GERRIT_NAME} \
-e GERRIT_FRONT_END_URL=http://${HOST_NAME}/gerrit \
--restart=unless-stopped \
-d ${JENKINS_IMAGE_NAME} ${JENKINS_OPTS}
