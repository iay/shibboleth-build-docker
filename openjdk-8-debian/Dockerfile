FROM java:8

LABEL maintainer="Ian Young <ian@iay.org.uk>"

#
# Build arguments and their defaults.
#
ARG mavenver=3.8.4

#
# Pull in commonly required tools.
#
#RUN apt-get update && \
#  apt-get install -y maven && \
#  rm -rf /var/lib/apt/lists/*

#
# Install latest version of Maven.
#
WORKDIR /opt
RUN wget --no-verbose https://archive.apache.org/dist/maven/maven-3/${mavenver}/binaries/apache-maven-${mavenver}-bin.tar.gz && \
    tar xfz apache-maven-${mavenver}-bin.tar.gz && \
    rm *.tar.gz
ENV M2_HOME=/opt/apache-maven-${mavenver}
ENV M2=${M2_HOME}/bin
ENV PATH=${M2}:${PATH}

#
# Do all our work as a normal user, in a home directory.
#
ENV userdir=/home/user
RUN adduser --disabled-login --gecos=NONE user
USER user
WORKDIR ${userdir}

#
# By default, run a login shell.
#
CMD ["/bin/bash", "--login"]
