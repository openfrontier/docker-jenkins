#!/bin/bash
set -e
ADMIN_ID=$1
ADMIN_EMAIL=$2
CHECKOUT_DIR=./git

#create ssh key.
##TODO: check key existence before create one.
docker exec jenkins-master ssh-keygen -q -N '' -t rsa  -f /var/jenkins_home/.ssh/id_rsa

#gather server rsa key
[ -f ~/.ssh/known_hosts ] && mv ~/.ssh/known_hosts ~/.ssh/known_hosts.bak
ssh-keyscan -p 29418 -t rsa localhost > ~/.ssh/known_hosts
#create jenkins account in gerrit.
##TODO: check account existence before create one.
docker exec jenkins-master cat /var/jenkins_home/.ssh/id_rsa.pub | ssh -p 29418 ${ADMIN_ID}@localhost gerrit create-account --group "'Non-Interactive Users'" --full-name "'Jenkins Server'" --ssh-key - jenkins

#checkout project.config from All-Project.git
mkdir ${CHECKOUT_DIR}
git init ${CHECKOUT_DIR}
cd ${CHECKOUT_DIR}
git config user.email ${ADMIN_EMAIL}
git remote add origin ssh://${ADMIN_ID}@localhost:29418/All-Projects 
git fetch -q origin refs/meta/config:refs/remotes/origin/meta/config
git checkout meta/config
#add label.Verified
git config -f project.config label.Verified.function MaxWithBlock
git config -f project.config --add label.Verified.defaultValue  0
git config -f project.config --add label.Verified.value "-1 Fails"
git config -f project.config --add label.Verified.value "0 No score"
git config -f project.config --add label.Verified.value "+1 Verified"
#commit and push back
git commit -a -m "Added label - Verified"
git push origin meta/config:meta/config

#Change global access right
##Remove anonymous access right.
git config -f project.config --unset access.refs/*.read "group Anonymous Users"
##add Jenkins access right
git config -f project.config --add access.refs/heads/*.read "group Non-Interactive Users"
git config -f project.config --add access.refs/tags/*.read "group Non-Interactive Users"
git config -f project.config --add access.refs/heads/*.label-Code-Review "-1..+1 group Non-Interactive Users"
git config -f project.config --add access.refs/heads/*.label-Verified "-1..+1 group Non-Interactive Users"
#commit and push back
git commit -a -m "Change access right." -m "Add access right for Jenkins. Remove anonymous access right"
git push origin meta/config:meta/config

cd -
rm -rf ${CHECKOUT_DIR}

#Install plugins
#TODO:this is not a good way to install plugins. Should be rewrite by using docker way.
cp ./plugins/*.hpi ~/jenkins_volume/plugins/
docker restart jenkins-master
