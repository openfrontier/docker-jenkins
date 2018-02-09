# Jenkins Docker Image
Official Jenkins docker plus some plugins and scripts in order to integrating with the Gerrit.  
Additional plugins include:
* docker-build-publish
* docker-plugin
* gerrit-trigger
* git
* ldap
* matrix-auth
* maven-plugin
* parameterized-trigger
* swarm

## Features
* Demonstrate how to integrate Jenkins with Gerrit.
* Demonstrate how to configure Jenkins [docker-plugin](https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin) to utilise other docker images as the slave nodes.
* There's a [sample image](https://hub.docker.com/r/openfrontier/jenkins-slave/) which demonstrate how to build a jenkins-slave image for Jenkins docker-plugin.
* There's another [project](https://github.com/openfrontier/ci) which privdes sample scripts about how to combine this image with [Gerrit image](https://hub.docker.com/r/openfrontier/gerrit/) and other images to create a ci system.

## Create Jenkins container
* Please refer to the [project](https://github.com/openfrontier/jenkins-docker) shell file <createJenkins.sh>.

## Basic setup for integrating Jenkins with Gerrit.

    #A public ssh key should be imported to Gerrit first as the <Gerrit admin uid>'s public key.
    setupJenkins.sh \
      <Gerrit admin uid> \
      <Gerrit admin email> \
      <Gerrit ssh ip/name> \
      <Gerrit canonicalWebUrl> \
      <Jenkins WebUrl> \
      <Nexus public repoUrl>

    sample:
    setupJenkins.sh \
      gerrit \
      gerrit@demo.org \
      172.17.42.1 \
      http://ci.demo.org/gerrit \
      http://ci.demo.org/jenkins \
      http://ci.demo.org/nexus/content/groups/public

## Destroy Jenkins container (Use with caution!)
* Please refer to the [project](https://github.com/openfrontier/jenkins-docker) shell file <destroyJenkins.sh>.

## Upgrade Jenkins container (Use with caution!)
* Please refer to the [project](https://github.com/openfrontier/jenkins-docker) shell file <upgradeJenkins.sh>.

## Additional environment variables that allow fine tune Jenkins runtime configuration are:
    LDAP_SERVER (required), the LDPA URI, i.e. ldap-host:389
    LDAP_ROOTDN (required), the LDAP BASE_DN
    LDAP_USER_SEARCH_BASE (optional), base organization unit to use to search for users
    LDAP_USER_SEARCH (optional), LDAP object field to use for the search query
    LDAP_GROUP_SEARCH_BASE (optional), base organization unit to use to search for groups
    LDAP_GROUP_SEARCH_FILTER (optional), filter to use querying for groups
    LDAP_GROUP_MEMBERSHIP_FILTER (optional), filter to use when writing queries to verify if a user is member of a group
    LDAP_MANAGER_DN (optional), LDAP adim user
    LDAP_MANAGER_PASSWORD (optional), LDAP admin password
    LDAP_INHIBIT_INFER_ROOTDN (required), flag indicating if ROOT_DN should be infered
    LDAP_DISPLAY_NAME_ATTRIBUTE_NAME (optional), LDAP object field used as a display name
    LDAP_DISABLE_MAIL_ADDRESS_RESOLVER (required), flag indicating if the email address resolver should be disabled
    LDAP_MAIL_ADDRESS_ATTRIBUTE_NAME (optional), LDAP object field used as a email address
    LDAP_GROUP_NAME_ADMIN (optional), LDAP admin group. Default to administrators.
