# shibboleth-build-docker

A collection of [Docker][] environments for building and testing
[Shibboleth][] products.

I'm using this with [Docker Desktop for Mac][], but any Docker setup should
work, including "real" Docker running on a Linux system.

The idea here is to embed a stable environment for
building or testing software within a normal desktop environment, using Docker's
container system.

Each directory in the repository represents a different build environment.
Each directory contains a `build` script to build the container image, and a
`run` script to start a new container based on that image and providing a shell
running within it.

The `run` script mounts the `user` directory from the repository as `/home/user`
within the container; from the container's prompt, this appears as the user's
home directory and persists across sessions. It is also common across sessions
using _different_ container variants.

Running the `./copy-dotfiles` script will populate this shared home directory
with some useful files from your host environment:

* The Maven configuration from your `~/.m2/settings.xml` file. Other files
  (such as the `~/.m2/repository` directory) are not copied: the Maven
  repository inside the container is isolated from the repository on the host.

* Your `~/.gitconfig` file, if there is one.

* Your `~/.ssh/` directory, primarily so that you can `git clone` things from
  non-public repositories.

* Selected files from your GPG configuration in `~/.gnupg` are copied primarily
  so that you can sign `git tag` operations and Maven artifacts:
  * `secring.gpg` and `pubring.gpg` are copied if you have them. If you don't,
    see [GPG Keyring Format](#gpg-keyring-format) below.
  * `gpg.conf` for your main configuration.
  * Other files are _not_ copied, as things like agent configurations and
    agent sockets need to be different inside the container.

## amazoncorretto-11

The `amazoncorretto-11` directory builds what should be regarded as the default
environment. It is based on the official Docker image for Amazon's Corretto 11
distribution of OpenJDK 11, which in turn is based on Amazon Linux 2, an
`rpm`-based distribution related to RHEL 7 and Centos 7.

Corretto 11 is the Java distribution specified as the "primary distribution" for
the Shibboleth Project's Java 11 platform, and the intention is to allow formal
production builds of any of the products based on that platform.

The image includes the following tools:

* maven (3.6.3)
* Git
* rpmbuild
* wget
* which

To build the Docker image for this environment, do this:

    (cd amazoncorretto-11; ./build)

The image will be tagged as `shibboleth-build-docker:amazon11`.

To execute the environment, type `amazoncorretto-11/run`, or just `./run`. This
will give you a `bash` prompt running under the home directory of user `user`
within a container. This home directory will also exist _outside_ the container
as a `user/` directory under the build location, and will retain state between
runs. Terminate the container and return to your original environment using
Ctrl+D.

If you want to start fresh, just exit the environment and then remove the
`user/` directory. It will be recreated on the next run.

## openjdk-site

This directory builds an environment which addresses a specific issue in the
Shibboleth Project build system for the Java 11 platform, which is that some
site builds don't work under Java 11 distributions. Later versions of Java
have a fix for this issue, so until that fix is back-ported to Java 11, this
image can be used to work around it.

The image is currently based on the standard `openjdk:14` from Docker Hub. That
image is in turn based on Oracle Linux, an `rpm`-based Linux distribution
derived from RHEL 7 sources. When OpenJDK 14 is retired, we would expect this
to move to the latest current released OpenJDK version, hence the lack of a
Java version in the container name.

To build the Docker image for this environment, do this:

    (cd openjdk-site; ./build)

The image will be tagged as `shibboleth-build-docker:site`.

To execute the environment, type `openjdk-site/run`

## openjdk-7-centos-7

The `openjdk-7-centos-7` directory builds an environment intended to allow
formal production builds of products based on the Shibboleth Project's Java 7
platform.

The image is based on the [CentOS][] 7 userspace, with the following tools
available:

* maven (3.3.9)
* Subversion
* Git
* OpenJDK version 7
* rpmbuild
* wget
* which

Java 7 is used here so that our build environment is based on the same version
as is specified by `parent-project-v3`. This is also important for the Cobertura
coverage tests, as those run into issues with Java 8.

To build the Docker image for this environment, do this:

    (cd openjdk-7-centos-7; ./build)

The image will be tagged as `shibboleth-build-docker:ojdk7-c7`.

To execute the environment, type `./run`. This will give you a `bash` prompt
running under the home directory of user `user` within a container. This home
directory will also exist _outside_ the container as a `user/` directory under
the build location, and will retain state between runs. Terminate the
container and return to your original environment using Ctrl+D.

If you want to start fresh, just exit the environment and then remove the
`user/` directory. It will be recreated on the next run.

If you have customisations in your outer environment, execute `./copy-dotfiles`
to copy them into the user directory. At the moment this handles:

* `~/.m2/settings.xml`
* `~/.gitconfig`
* `~/.ssh`

Copying `~/.ssh` is mostly intended to allow the use of `git` to a remote
repository, but note that you will need to type the passphrase each time as
no `ssh` agent is set up. This is not intended to be a development environment.

## openjdk-8-centos-7

The `openjdk-8-centos-7` directory builds an image which will be tagged
as `shibboleth-build-docker:ojdk8-c7`. This is the same as the `ojdk7-c7` tag
except that OpenJDK 8 is provided instead of OpenJDK 7.

To build the Docker image for this environment, do this:

    (cd openjdk-8-centos-7; ./build)

Run the environment using `openjdk-8-centos-7/run`.

This image is best used for testing under OpenJDK 8. It should not be used for
either product builds or site builds.

One large issue with the OpenJDK 8 environment is that the Cobertura coverage
tool does not work there.

## openjdk-\*-debian

These three directories build images from the official Docker library `java`
images, which are based on OpenJDK and Debian. These can be worth testing against
because OpenJDK in the Debian environment ships with an alternative elliptic
curve cryptographic provider.

To build these images:

    (cd openjdk-7-debian; ./build)
    (cd openjdk-8-debian; ./build)

The tags for these will be `ojdk7-deb` and `ojdk8-deb`.

## Troubleshooting

### GPG Keyring Format

The version of GPG used in most of the image variants built here is quite old,
because the containers use the version of GPG that is current for the underlying
operating system. In most cases, this is something like version 2.0.

Outside the container, you may well be using something from the 2.2 series: this
uses a new keychain format which is not supported by version 2.0. If you have
used GPG for a long time, you will have in your host's `~/.gnupg` both the old
format files (`secring.gpg` and `pubring.gpg`) and the new format ones. In this
case, the `./copy-dotfiles` script will copy in the `secring.gpg` and
`pubring.gpg` files and all will be well.

If you are a more recent user of GPG, or if you erased the old format files once
they had been converted, you will not be able to perform signature operations
inside the containers until you import your secret keys. To so this, perform the
following _outside_ the container:

```bash
$ gpg -a --export-secret-keys --output user/secret.asc
```

Now, perform the following _inside_ the container:

```bash
$ gpg --import secret.asc
```

### GPG Agent

If the location of this repository _on the host_ is too far from the root (if
the length of the repository's path is too long), you may run into issues
starting a `gpg-agent` process:

```
gpg: can't connect to the agent: IPC connect call failed
```

You can try starting the agent manually to get more detail:

```bash
$ eval $(gpg-agent --daemon)
gpg-agent[29]: error binding socket to '/home/user/.gnupg/S.gpg-agent': File name too long
```

If you run into this issue, the solution seems to be to move the
`shibboleth-build-docker` repository itself closer to the root _on the host_ and
try again.

It's not clear exactly how long a path becomes a problem, but we have a couple
of data points.

* A value of `pwd | wc -c` of 50 or below seems to be acceptable.
* A value of `pwd | wc -c` of 90 or above seems to be problematic.

[CentOS]: https://www.centos.org
[Docker]: https://www.docker.com
[Docker Desktop for Mac]: https://hub.docker.com/editions/community/docker-ce-desktop-mac
[Shibboleth]: https://shibboleth.net
