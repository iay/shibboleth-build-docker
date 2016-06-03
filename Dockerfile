#
# The base image is CentOS 7 because that's what I use on most of my
# servers.
#
FROM centos:7

MAINTAINER Ian Young <ian@iay.org.uk>

#
# Pull in Java, and commonly required tools.
#
# We use OpenJDK 7 because Java 7 is what the V3 parent
# project defines as the requirement for the stack. In addition, Cobertura
# doesn't work properly under Java 8.
#
RUN yum -y install git java-7-openjdk maven rpm-build subversion wget && \
    yum clean all

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
