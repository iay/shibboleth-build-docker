# check=skip=InvalidDefaultArgInFrom

#
# This build stage simply references the pre-built Maven data container.
# This will fail at build time if the appropriate build argument is not
# passed, so the check for a default is not appropriate and is
# therefore skipped above.
#
ARG MAVEN_IMAGE
FROM --platform=$BUILDPLATFORM ${MAVEN_IMAGE} AS maven

#
# Main container build stage.
#
FROM amazoncorretto:11-al2

LABEL maintainer="Ian Young <ian@iay.org.uk>"

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
# Install selected version of Maven.
#
WORKDIR /opt
COPY --from=maven /opt/apache-maven apache-maven

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
