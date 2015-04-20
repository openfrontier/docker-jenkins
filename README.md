# Jenkins Docker Image
Official Jenkins docker plus some necessary plugins in order to integrating with gerrit.
  Additional plugins including:
    gerrit-trigger:2.12.0
    git-client:1.16.1
    git:2.3.5
    scm-api:0.2
## create Jenkins docker
    createJenkins.sh
## basic setup for connecting Jenkins with Gerrit.
    setupJenkins.sh $Gerrit-Admin-Id $Gerrit-Admin-Email
## Destroy all (Use with caution!)
    cleanJenkins.sh
