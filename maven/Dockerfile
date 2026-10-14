#
# Docker build to acquire a particular version of Maven.
#
# After acquisition, the distribution's signature is checked
# against the same list of public keys the Shibboleth project
# trusts for the org.apache.maven artifact group.
#
# The downloaded and unpacked distribution is available
# as /opt/apache-maven regardless of version.
#

#
# Build using Alpine Linux. For stability, the ALPINE_VERSION
# build argument is normally overridden by the "fetch" script,
# but "latest" is a reasonable default (in 2026).
#
ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}

#
# Version of Maven to acquire.
#
ARG MAVEN_VERSION

#
# Install needed packages.
#
RUN apk update
RUN apk add gpg wget

WORKDIR /opt

ENV GZNAME=apache-maven-${MAVEN_VERSION}-bin.tar.gz
ENV URLBASE=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${GZNAME}

#
# Fetch the Maven distribution file and its signature.
#
RUN wget --no-verbose ${URLBASE}
RUN wget --no-verbose ${URLBASE}.asc

#
# Verify the signature using the public keys we trust.
#
ADD org.apache.maven.gpg .
RUN gpg --no-default-keyring --keyring ./org.apache.maven.gpg --verify ${GZNAME}.asc

#
# Unpack the distribution and rename it into a
# version-independent directory.
#
RUN tar xfz ${GZNAME}
RUN mv apache-maven-${MAVEN_VERSION} apache-maven
