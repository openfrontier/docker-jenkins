FROM jenkins
MAINTAINER zsx <thinkernel@gmail.com>

# Install plugins
COPY plugins.txt /usr/local/etc/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/local/etc/plugins.txt

# Add gerrit-trigger plugin config file
COPY gerrit-trigger.xml /usr/local/etc/gerrit-trigger.xml

# Add credentials plugin config file
COPY credentials.xml /usr/local/etc/credentials.xml

# Add maven installation config file
COPY hudson.tasks.Maven.xml /usr/local/etc/hudson.tasks.Maven.xml
COPY apache-maven-3.2.2-bin.zip /usr/local/etc/apache-maven-3.2.2-bin.zip
COPY maven.installedFrom /usr/local/etc/.installedFrom

# Add Jenkins URL and system admin e-mail config file
COPY jenkins.model.JenkinsLocationConfiguration.xml /usr/local/etc/jenkins.model.JenkinsLocationConfiguration.xml

# Add Nexus repository mirror config file
COPY maven.settings.xml /usr/local/etc/settings.xml

# Add setup script.
COPY jenkins-setup.sh /usr/local/bin/jenkins-setup.sh
