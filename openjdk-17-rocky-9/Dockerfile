FROM rockylinux:9

LABEL maintainer="Ian Young <ian@iay.org.uk>"

#
# Build arguments and their defaults.
#
ARG java=java-17-openjdk
ARG mavenver=3.8.4

#
# Pull in Java, and commonly required tools.
#
RUN yum -y install git rpm-build rpm-sign wget which \
    ${java} ${java}-devel ${java}-headless && \
    yum clean all

#
# Default GPG agent configuration.
#
ADD gpg-agent.conf /etc/gnupg/

#
# Bash profile.
#
ADD profile.d/ /etc/profile.d/

#
# Install latest version of Maven.
#
WORKDIR /opt
RUN wget --no-verbose  https://archive.apache.org/dist/maven/maven-3/${mavenver}/binaries/apache-maven-${mavenver}-bin.tar.gz && \
    tar xfz apache-maven-${mavenver}-bin.tar.gz && \
    rm *.tar.gz

#
# Bootstrap script.
#
ADD bootstrap.sh /etc/bootstrap.sh

#
# Do all our work as a normal user, in a home directory.
#
RUN adduser user
ENV userdir=/home/user
WORKDIR ${userdir}

#
# By default, run a login shell.
#
CMD ["/bin/bash", "/etc/bootstrap.sh"]
