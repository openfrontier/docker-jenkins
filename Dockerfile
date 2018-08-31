FROM jenkins:1.651.3
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
  audit-trail:2.2 \
  copyartifact \
  email-ext:2.44 \
  envinject:1.92.1 \
  gerrit-trigger \
  git \
  git-parameter \
  ldap \
  matrix-auth \
  maven-plugin \
  parameterized-trigger \
  swarm

# Add groovy setup config
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

# Generate jenkins ssh key.
COPY generate_key.sh /usr/local/bin/generate_key.sh

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
