FROM jenkins/jenkins:lts
MAINTAINER zsx <thinkernel@gmail.com>

# Install docker binary
USER root

ENV DOCKER_BUCKET download.docker.com
ENV DOCKER_VERSION 17.09.0-ce

RUN curl -fSL "https://${DOCKER_BUCKET}/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" -o /tmp/docker-ce.tgz \
        && tar -xvzf /tmp/docker-ce.tgz --directory="/usr/local/bin" --strip-components=1 docker/docker \
	&& rm /tmp/docker-ce.tgz

USER jenkins

# Install plugins
RUN /usr/local/bin/install-plugins.sh \
  copyartifact \
  docker-build-publish \
  docker-workflow \
  gerrit-trigger \
  git \
  git-parameter \
  ldap \
  matrix-auth \
  maven-plugin \
  parameterized-trigger \
  swarm \
  workflow-aggregator

# Add groovy setup config
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

# Add Jenkins URL and system admin e-mail config file
COPY jenkins.model.JenkinsLocationConfiguration.xml /usr/local/etc/jenkins.model.JenkinsLocationConfiguration.xml

# Add setup script.
COPY jenkins-setup.sh /usr/local/bin/jenkins-setup.sh

# Generate jenkins ssh key.
COPY generate_key.sh /usr/local/bin/generate_key.sh

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
