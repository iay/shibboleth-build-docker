FROM openjdk:14

MAINTAINER Ian Young <ian@iay.org.uk>

#
# Build arguments and their defaults.
#
ARG mavenver=3.6.3

#
# Pull in commonly required tools.
#
RUN yum -y install git rpm-build rpm-sign wget which && \
    yum clean all

#
# Default GPG agent configuration.
#
ADD gpg-agent.conf /etc/gnupg/

#
# Install latest version of Maven.
#
WORKDIR /opt
RUN wget --no-verbose  https://apache.osuosl.org/maven/maven-3/${mavenver}/binaries/apache-maven-${mavenver}-bin.tar.gz && \
    tar xfz apache-maven-${mavenver}-bin.tar.gz && \
    rm *.tar.gz
ENV M2_HOME=/opt/apache-maven-${mavenver}
ENV M2=${M2_HOME}/bin
ENV PATH=${M2}:${PATH}

#
# Do all our work as a normal user, in a home directory.
#
RUN adduser user
USER user
ENV userdir=/home/user
WORKDIR ${userdir}

#
# By default, run a login shell.
#
CMD ["/bin/bash", "--login"]
