FROM amazoncorretto:17-al2

LABEL maintainer="Ian Young <ian@iay.org.uk>"

#
# Build arguments and their defaults.
#
ARG MAVEN_VERSION

#
# Pull in commonly required tools.
#
RUN yum -y install git procps-ng rpm-build rpm-sign sudo wget which && \
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
RUN wget --no-verbose https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar xfz apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
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
