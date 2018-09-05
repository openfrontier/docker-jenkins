FROM jenkins:1.651.3
MAINTAINER zsx <thinkernel@gmail.com>

# Install docker binary
USER root

#ENV DOCKER_BUCKET download.docker.com
#ENV DOCKER_VERSION 17.09.0-ce

#RUN curl -fSL "https://${DOCKER_BUCKET}/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" -o /tmp/docker-ce.tgz \
#        && tar -xvzf /tmp/docker-ce.tgz --directory="/usr/local/bin" --strip-components=1 docker/docker \
#	&& rm /tmp/docker-ce.tgz

# Patch scripts about plugins from 2.x
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
COPY jenkins-support /usr/local/bin/jenkins-support

USER jenkins

# Install plugins
RUN /usr/local/bin/install-plugins.sh \
  ## Append 
  ivy:1.22 \
  swarm \
  ## -
  ant:1.3 \
  credentials:2.1.4 \
  cron_column:1.4 \
  cvs:2.12 \
  external-monitor-job:1.4 \
  git-client:1.19.6 \
  git-parameter:0.6.0 \
  javadoc:1.4 \
  job-import-plugin:1.3.1 \
  jquery:1.11.2-0 \
  junit:1.15 \
  ldap:1.12 \
  mailer:1.17 \
  mapdb-api:1.0.9.0 \
  matrix-auth:1.4 \
  matrix-project:1.7.1 \
  maven-plugin:2.13 \
  antisamy-markup-formatter:1.5 \
  pam-auth:1.3 \
  scm-api:1.2 \
  script-security:1.21 \
  ######################### SonarQube
  ssh-agent:1.13 \
  ssh-credentials:1.12 \
  ssh-slaves:1.11 \
  StashBranchParameter:0.2.0 \
  analysis-core:1.78 \
  subversion:2.6 \
  token-macro:1.12.1 \
  translation:1.15 \
  windows-slaves:1.1 \
  ## triangle
  uno-choice:1.4 \
  bouncycastle-api:1.648.3 \
  branch-api:1.10 \ 
  build-user-vars-plugin:1.5 \
  categorized-view:1.8 \
  conditional-buildstep:1.3.5 \
  configurationslicing:1.45 \
  description-setter:1.10 \
  disk-usage:0.28 \
  cloudbees-folder:5.12 \
  git-server:1.7 \
  icon-shim:2.0.3 \
  jobConfigHistory:2.14 \
  multiple-scms:0.6 \
  next-executions:1.0.11 \
  parameterized-trigger:2.31 \
  workflow-scm-step:2.2 \
  workflow-step-api:2.2 \
  plain-credentials:1.2 \
  run-condition:1.0 \
  #################### scriptler plugin 
  stashNotifier:1.10.4 \
  structs:1.2 \
  text-finder:1.10 \
  timestamper:1.8.4 \
  ## circular
  audit-trail:2.2 \
  email-ext:2.44 \
  envinject:1.92.1 \
  git:2.5.3 \
  jobcopy-builder:1.3.0 \
  log-parser:2.0 \
  multi-branch-project-plugin:0.5.1 \
  template-project:1.5.2 \
  ws-cleanup:0.29
  
# Add groovy setup config
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

# Generate jenkins ssh key.
COPY generate_key.sh /usr/local/bin/generate_key.sh

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
