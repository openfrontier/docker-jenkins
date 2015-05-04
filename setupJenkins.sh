#!/bin/bash
set -e
GERRIT_ADMIN_UID=${GERRIT_ADMIN_UID:-$1}
GERRIT_ADMIN_EMAIL=${GERRIT_ADMIN_EMAIL:-$2}
CHECKOUT_DIR=./git

JENKINS_NAME=${JENKINS_NAME:-jenkins}
GERRIT_NAME=${GERRIT_NAME:-gerrit}
GERRIT_SSH_HOST=${GERRIT_SSH_HOST:-$3}
GERRIT_WEBURL=${GERRIT_WEBURL:-$4}
JENKINS_WEBURL=${JENKINS_WEBURL:-$5}

#create ssh key.
##TODO: check key existence before create one.
docker exec ${JENKINS_NAME} ssh-keygen -q -N '' -t rsa  -f /var/jenkins_home/.ssh/id_rsa

#gather server rsa key
##TODO: This is not an elegant way.
[ -f ~/.ssh/known_hosts ] && mv ~/.ssh/known_hosts ~/.ssh/known_hosts.bak
ssh-keyscan -p 29418 -t rsa ${GERRIT_SSH_HOST} > ~/.ssh/known_hosts
#create jenkins account in gerrit.
##TODO: check account existence before create one.
docker exec ${JENKINS_NAME} cat /var/jenkins_home/.ssh/id_rsa.pub | ssh -p 29418 ${GERRIT_ADMIN_UID}@${GERRIT_SSH_HOST} gerrit create-account --group "'Non-Interactive Users'" --full-name "'Jenkins Server'" --ssh-key - jenkins

#checkout project.config from All-Project.git
mkdir ${CHECKOUT_DIR}
git init ${CHECKOUT_DIR}
cd ${CHECKOUT_DIR}
git config user.name  ${GERRIT_ADMIN_UID}
git config user.email ${GERRIT_ADMIN_EMAIL}
git remote add origin ssh://${GERRIT_ADMIN_UID}@${GERRIT_SSH_HOST}:29418/All-Projects 
git fetch -q origin refs/meta/config:refs/remotes/origin/meta/config
git checkout meta/config

#add label.Verified
git config -f project.config label.Verified.function MaxWithBlock
git config -f project.config --add label.Verified.defaultValue  0
git config -f project.config --add label.Verified.value "-1 Fails"
git config -f project.config --add label.Verified.value "0 No score"
git config -f project.config --add label.Verified.value "+1 Verified"
##commit and push back
git commit -a -m "Added label - Verified"
git push origin meta/config:meta/config

#Change global access right
##Remove anonymous access right.
git config -f project.config --unset access.refs/*.read "group Anonymous Users"
##add Jenkins access and verify right
git config -f project.config --add access.refs/heads/*.read "group Non-Interactive Users"
git config -f project.config --add access.refs/tags/*.read "group Non-Interactive Users"
git config -f project.config --add access.refs/heads/*.label-Code-Review "-1..+1 group Non-Interactive Users"
git config -f project.config --add access.refs/heads/*.label-Verified "-1..+1 group Non-Interactive Users"
##add project owners' right to add verify flag
git config -f project.config --add access.refs/heads/*.label-Verified "-1..+1 group Project Owners"
##commit and push back
git commit -a -m "Change access right." -m "Add access right for Jenkins. Remove anonymous access right"
git push origin meta/config:meta/config

cd -
rm -rf ${CHECKOUT_DIR}

#Setup gerrit-trigger plugin and restart jenkins
docker exec ${JENKINS_NAME} jenkins-setup.sh ${GERRIT_NAME} ${GERRIT_WEBURL} ${JENKINS_WEBURL}
docker restart ${JENKINS_NAME}

