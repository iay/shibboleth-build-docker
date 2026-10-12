FROM rockylinux:8

LABEL maintainer="Ian Young <ian@iay.org.uk>"

#
# Build arguments and their defaults.
#
ARG java=java-17-openjdk
ARG MAVEN_VERSION

#
# Pull in Java, and commonly required tools.
#
RUN yum -y install git procps-ng rpm-build rpm-sign wget which sudo \
    ${java} ${java}-devel ${java}-headless && \
    yum clean all

#
# System configuration.
#
# Includes:
# - Bootstrap script.
# - Default GPG agent configuration.
# - Bash profile.
# - sudo rules.
#
ADD etc /etc

#
# Install latest version of Maven.
#
WORKDIR /opt
RUN wget --no-verbose  https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar xfz apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    rm *.tar.gz

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
