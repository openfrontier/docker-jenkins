FROM jenkins
MAINTAINER zsx <thinkernel@gmail.com>

# Install plugins
COPY plugins.txt /usr/local/etc/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/local/etc/plugins.txt

# Add setting up scripts of gerrit-trigger plugin
COPY gerrit-trigger.xml /usr/local/etc/gerrit-trigger.xml
COPY gerrit-trigger.sh /usr/local/bin/gerrit-trigger.sh
