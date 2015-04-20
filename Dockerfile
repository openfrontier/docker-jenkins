FROM jenkins
MAINTAINER zsx <thinkernel@gmail.com>

COPY plugins.txt /plugins.txt
RUN /usr/local/bin/plugins.sh /plugins.txt
