# check=skip=InvalidDefaultArgInFrom

#
# This build stage simply references the pre-built Maven data container.
# This will fail at build time if the appropriate build argument is not
# passed, so the check for a default is not appropriate and is
# therefore skipped above.
#
ARG MAVEN_IMAGE
FROM ${MAVEN_IMAGE} AS maven

#
# Main container build stage.
#
FROM rockylinux:9

LABEL maintainer="Ian Young <ian@iay.org.uk>"

#
# Build arguments and their defaults.
#
ARG java=java-11-openjdk

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
# Install selected version of Maven.
#
WORKDIR /opt
COPY --from=maven /opt/apache-maven apache-maven

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
