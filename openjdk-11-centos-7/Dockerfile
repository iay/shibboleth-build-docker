#
# The base image is CentOS 7 because that's what I use on most of my
# servers.
#
FROM centos:7

LABEL maintainer="Ian Young <ian@iay.org.uk>"

#
# Build arguments and their defaults.
#
ARG java=java-11-openjdk
ARG mavenver=3.9.1

#
# Pull in Java, and commonly required tools.
#
RUN yum -y install git rpm-build rpm-sign wget which \
    ${java} ${java}-devel ${java}-headless && \
    yum clean all

#
# Install latest version of Maven.
#
WORKDIR /opt
RUN wget --no-verbose  https://archive.apache.org/dist/maven/maven-3/${mavenver}/binaries/apache-maven-${mavenver}-bin.tar.gz && \
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
