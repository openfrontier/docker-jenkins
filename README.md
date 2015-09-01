# Jenkins Docker Image
Official Jenkins docker plus some plugins and scripts in order to integrating with the Gerrit.  
Additional plugins include:
* gerrit-trigger:2.13.0
* git-client:1.19.0
* git:2.4.0
* scm-api:0.2
* junit:1.8
* maven-plugin:2.11
* docker-plugin:0.12.1
* durable-task:1.6
* token-macro:1.10
* ssh-slaves:1.10
* ldap:1.11
* ssh-credentials:1.11
* credentials:1.22
* authentication-tokens:1.1
* docker-commons:1.2
* docker-build-publish:1.0

## Features
* Demonstrate how to integrate Jenkins with Gerrit.
* Domonstrate how to configure Jenkins [docker-plugin](https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin) to utilise other docker images as the slave nodes.
* There's a [sample image](https://hub.docker.com/r/openfrontier/jenkins-slave/) which demonstrate how to build a jenkins-slave image for Jenkins docker-plugin.
* There's another [project](https://github.com/openfrontier/ci) which privdes sample scripts about how to combine this image with [Gerrit image](https://hub.docker.com/r/openfrontier/gerrit/) and other images to create a ci system.

## create Jenkins container
    createJenkins.sh
## basic setup for integrating Jenkins with Gerrit.
    #A public ssh key of this script's runner should be added to Gerrit first as the <Gerrit admin uid>'s public key.
    setupJenkins.sh <Gerrit admin uid> <Gerrit admin email> <Gerrit ssh ip/name> <Gerrit canonicalWebUrl> <Jenkins WebUrl> <Nexus public repoUrl>
    e.g. setupJenkins.sh gerrit gerrit@demo.org 172.17.42.1 http://ci.demo.org/gerrit http://ci.demo.org/jenkins http://ci.demo.org/nexus/content/groups/public
## Destroy Jenkins container (Use with caution!)
    destroyJenkins.sh
## Upgrade Jenkins container (Use with caution!)
    upgradeJenkins.sh
