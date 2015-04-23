# Jenkins Docker Image
Official Jenkins docker plus some plugins and scripts in order to integrating with the Gerrit.
  Additional plugins include:
    gerrit-trigger:2.12.0
    git-client:1.16.1
    git:2.3.5
    scm-api:0.2
## create Jenkins container
    createJenkins.sh
## basic setup for integrating Jenkins with Gerrit.
    setupJenkins.sh <Gerrit admin uid> <Gerrit admin email>
    (A ssh public key of this script's runner should be added to Gerrit first as the <Gerrit admin uid>'s public key.)
## Destroy Jenkins container (Use with caution!)
    cleanJenkins.sh
