#
# The base image is CentOS 7 because that's what I use on most of my
# servers.
#
FROM centos:7

MAINTAINER Ian Young <ian@iay.org.uk>

#
# Build arguments and their defaults.
#
ARG java=java-1.7.0-openjdk
ARG mavenver=3.3.9

#
# Pull in Java, and commonly required tools.
#
# We use OpenJDK 7 because Java 7 is what the V3 parent
# project defines as the requirement for the stack. In addition, Cobertura
# doesn't work properly under Java 8.
#
RUN yum -y install git rpm-build rpm-sign subversion wget which \
    ${java} ${java}-devel ${java}-headless && \
    yum clean all

#
# Install latest version of Maven.
#
WORKDIR /opt
RUN wget --no-verbose http://mirror.catn.com/pub/apache/maven/maven-3/${mavenver}/binaries/apache-maven-${mavenver}-bin.tar.gz && \
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
# By default, run a shell.
#
CMD ["/bin/bash"]
