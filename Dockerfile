FROM jenkins:1.651.1-alpine
MAINTAINER zsx <thinkernel@gmail.com>

# Install plugins
COPY plugins.txt /usr/local/etc/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/local/etc/plugins.txt

# Add gerrit-trigger config
COPY gerrit.groovy /usr/share/jenkins/ref/init.groovy.d/gerrit.groovy

# Add credentials plugin config file
COPY credentials.xml /usr/local/etc/credentials.xml

# Add maven installation config file
COPY hudson.tasks.Maven.xml /usr/local/etc/hudson.tasks.Maven.xml

# Add Jenkins URL and system admin e-mail config file
COPY jenkins.model.JenkinsLocationConfiguration.xml /usr/local/etc/jenkins.model.JenkinsLocationConfiguration.xml

# Add setup script.
COPY jenkins-setup.sh /usr/local/bin/jenkins-setup.sh

# Add cloud setting in config file.
COPY config.xml /usr/local/etc/config.xml

# Generate jenkins ssh key.
COPY generate_key.sh /usr/local/bin/generate_key.sh

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
