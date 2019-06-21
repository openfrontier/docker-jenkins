# Jenkins Docker Image

Official Jenkins docker plus some plugins and scripts in order to integrating with the Gerrit.  
Additional plugins include:

* ansible
* copyartifact
* config-file-provider
* docker-build-publish
* docker-plugin
* docker-workflow
* gerrit-trigger
* git
* git-parameter
* gitlab-plugin
* kubernetes
* ldap
* matrix-auth
* maven-plugin
* parameterized-trigger
* pipeline-maven
* script-security
* swarm
* terraform
* workflow-aggregator

## Features

* Demonstrate how to integrate Jenkins with Gerrit OpenLDAP.
* Auto-configuring credentials and Maven settings file in Jenkins.
* There's a [Jenkins slave/agent image](https://hub.docker.com/r/openfrontier/jenkins-swarm-slave/) which demonstrate how to build a jenkins-slave image for the Jenkins swarm plugin.

## Run Jenkins container

  ```shell
    docker volume create jenkins-home
    docker run \
        -e JAVA_OPTS="t-Duser.timezone=Asia/Shanghai -Djenkins.install.runSetupWizard=false -Xms2048m -Xmx3584" \
        -e JENKINS_OPTS=--prefix=/jenkins \
        -e ROOT_URL=http://your.jenkins.example.com/jenkins/ \
        -v jenkins-home:/var/jenkins_home \
        -p 8080:8080 \
        -p 50000:50000 \
        -d openfrontier/jenkins
  ```

## Environment variables for integrating Jenkins with Gerrit

    GERRIT_HOST_NAME Gerrit server's hostname
    GERRIT_FRONT_END_URL The url used to redirect to Gerrit in Browsers.
    GERRIT_SSH_PORT (optional) Gerrit server's ssh port. Default: 29418.
    GERRIT_USERNAME (optional) User name for ssh to Gerrit. Default: jenkins.
    GERRIT_EMAIL (optional) Gerrit user's email. Default: empty.
    GERRIT_SSH_KEY_FILE (optional) Location of the rsa key for ssh to Gerrit. Default: /var/jenkins_home/.ssh/id_rsa.
    GERRIT_SSH_KEY_PASSWORD (optional) Passphrase of the ssh key. Default: null.

## Environment variables for integrating with Openldap

    LDAP_SERVER (required), the LDPA URI, i.e. ldap-host:389
    LDAP_ROOTDN (required), the LDAP BASE_DN
    LDAP_INHIBIT_INFER_ROOTDN (required if LDAP_ROOTDN is empty), flag indicating if ROOT_DN should be infered
    LDAP_USER_SEARCH_BASE (optional), base organization unit to use to search for users
    LDAP_USER_SEARCH (optional), LDAP object field to use for the search query
    LDAP_GROUP_SEARCH_BASE (optional), base organization unit to use to search for groups
    LDAP_GROUP_SEARCH_FILTER (optional), filter to use querying for groups
    LDAP_GROUP_MEMBERSHIP_STRATEGY (required), the strategy to determine a user's groups, FromGroupSearchLDAPGroupMembershipStrategy or FromUserRecordLDAPGroupMembershipStrategy
    LDAP_GROUP_MEMBERSHIP_SEARCH_FILTER (optional), filter to use when writing queries to verify if a user is member of a group, used when LDAP_GROUP_MEMBERSHIP_STRATEGY is FromGroupSearchLDAPGroupMembershipStrategy
    LDAP_USER_RECORD_ATTRIBUTE_NAME (optional), the attribute name that is used to determine the groups to which a user belongs, used when LDAP_GROUP_MEMBERSHIP_STRATEGY is FromUserRecordLDAPGroupMembershipStrategy
    LDAP_MANAGER_DN (optional), LDAP adim user
    LDAP_MANAGER_PASSWORD (optional), LDAP admin password
    LDAP_INHIBIT_INFER_ROOTDN (required), flag indicating if ROOT_DN should be infered
    LDAP_DISPLAY_NAME_ATTRIBUTE_NAME (optional), LDAP object field used as a display name
    LDAP_DISABLE_MAIL_ADDRESS_RESOLVER (required), flag indicating if the email address resolver should be disabled
    LDAP_MAIL_ADDRESS_ATTRIBUTE_NAME (optional), LDAP object field used as a email address
    LDAP_GROUP_NAME_ADMIN (optional), LDAP admin group. Default to administrators.

## Environment variables for maven and nexus integration

    NEXUS_REPO (optional) Nexus repository url. This will create a maven settings config file in Jenkins for you and mirror all maven site to this url.
    NEXUS_USER (optional) Username for push artifacts to Nexus repository. This will create a username password credential for you in Jenkins.
    NEXUS_PASS (optional) Password for push artifacts to Nexus repository.
