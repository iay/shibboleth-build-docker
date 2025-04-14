# shibboleth-build-docker

A collection of stable environments for use in building and testing
[Shibboleth][] products. Each environment is represented by a
container image so that it can be embedded within a normal desktop
environment using [Docker][].

The following table summarises the container images available:

| Tag         | Directory             | Java | OS |  Use Case |
| ----------- | --------------------- | ---- | -- | ------- |
| `amazon8` \*  | `amazoncorretto-8`    | Corretto 8  | Amazon Linux | Old Shibboleth builds. |
| `amazon11` \*  | `amazoncorretto-11`   | Corretto 11 | Amazon Linux | Shibboleth v4 builds.  |
| `amazon17` \* | `amazoncorretto-17`   | Corretto 17 | Amazon Linux | Shibboleth v5 builds.  |
| `ojdk11-r8` | `openjdk-11-rocky-8`  | OpenJDK 11  | Rocky Linux 8 | |
| `ojdk17-r8` | `openjdk-17-rocky-8`  | OpenJDK 17  | Rocky Linux 8 | |
| `ojdk11-r9` | `openjdk-11-rocky-9`  | OpenJDK 11  | Rocky Linux 9 | |
| `ojdk17-r9` \* | `openjdk-17-rocky-9`  | OpenJDK 17  | Rocky Linux 9 | Horizon scanning.    |

Images marked with a "\*" are available as pre-built environments.

## Pre-built Environments

If your use case is the building of Shibboleth products or their Maven sites,
you can use one of the pre-built environments based on Amazon Corretto 17
(for Java 17 platform products, or for the Maven sites of Java 11 platform
products) or Amazon Corretto 11 (for Java 11 platform products).

I also provide a pre-built environment based on Amazon Corretto 8, although
this version is no longer used in Shibboleth builds.

A pre-built environment is also available for OpenJDK 17 under Rocky Linux 9 for
horizon-scanning purposes.

These are multi-architecture images supporting both both `linux/amd64`
and `linux/arm64` hosts; the latter is used on Apple Silicon
based Macs.

To use these images, you make use of the various `runx` scripts included in this
repository; the corresponding pre-built environment for your host architecture
will be downloaded from Docker Hub.

Each of the `runx` scripts will start a new container based on the appropriate
image and provide a shell running within it. The `user` directory _in the
directory in which you invoke `runx`_ will be created if necessary and then
mounted into the container as the user's home directory. This will persist
across sessions.

It is normal to invoke the `runx` scripts from the root directory of this
repository; this means that the home directory will persist even across
sessions using _different_ container variants.

`runx` scripts exist in the `amazoncorretto-8`, `amazoncorretto-11` and `amazoncorretto-17`
directories and can be invoked as such:

```bash
amazoncorretto-17/runx
```

In addition, a `runx` alias is provided in the root directory for the most
common case of invoking the Corretto 17 environment:

```bash
./runx
```

You can pass arguments to a `runx` script and they will be passed on to the
`docker run` command as Docker options. For example, to run the container
without network access:

```bash
$ ./runx --network none
...
user@C17: ~ $ curl -I https://iay.org.uk
curl: (6) Could not resolve host: iay.org.uk
user@C17: ~ $
```

To pull the most up-to-date version of the container image before execution,
add `--pull always` to the command:

```bash
$ ./runx --pull always
amazon17: Pulling from ianayoung/shibboleth-build-docker
...
Status: Downloaded newer image for ianayoung/shibboleth-build-docker:amazon17
...
user@C17: ~ $
```

Running the `./copy-dotfiles` script will populate the shared home directory
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

## Build Your Own Environments

If you are unable to use the pre-built environments for whatever reason,
or just want to use the most recent base images,
you will need to perform a local build of the container image or images
you want to use. Note that images built in this way will be specific to
your Docker host's architecture.

Each directory in the repository represents a different build environment.
Each directory contains a `build` script to build the container image, and a
`run` script to start a new container based on that image and providing a shell
running within it.

You can pass arguments to the `build` script and they will be passed on to the
`docker build` command. For example, adding `--pull` would mean to build
against the latest base image rather than whatever is cached locally.

If you want to build _all_ of the variants at once, you can use the `build-all`
script in the top directory. If you pass arguments to this script they will
be forwarded to each variant's `build` script in turn.

The `run` script mounts the `user` directory from the repository as `/home/user`
within the container; from the container's prompt, this appears as the user's
home directory and persists across sessions. It is also common across sessions
using _different_ container variants.

You can pass arguments to the `run` script and they will be passed on to the
`docker run` command as Docker options. For example:

```bash
$ ./run --network none
...
user@C17: ~ $ curl -I https://iay.org.uk
curl: (6) Could not resolve host: iay.org.uk
user@C17: ~ $
```

Running the `./copy-dotfiles` script will populate the shared home directory
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

## amazoncorretto-17

The `amazoncorretto-17` directory builds what should be regarded as the default
environment. It is based on the official Docker image for Amazon's Corretto 17
distribution of OpenJDK 17, which in turn is based on Amazon Linux 2, an
`rpm`-based distribution related to RHEL 7 and Centos 7.

Corretto 17 is the Java distribution specified as the "primary distribution" for
the Shibboleth Project's Java 17 platform, and the intention is to allow formal
production builds of any of the products based on that platform.

The image includes the following tools:

* maven (3.9.5)
* Git
* rpmbuild
* sudo
* wget
* which

To build the Docker image for this environment, do this:

```bash
(cd amazoncorretto-17; ./build)
```

The image will be tagged as `shibboleth-build-docker:amazon17`.

To execute the environment, type `amazoncorretto-17/run`, or just `./run`. This
will give you a `bash` prompt running under the home directory of user `user`
within a container. This home directory will also exist _outside_ the container
as a `user/` directory under the build location, and will retain state between
runs. Terminate the container and return to your original environment using
Ctrl+D.

If you want to start fresh, just exit the environment and then remove the
`user/` directory. It will be recreated on the next run.

If you're running on macOS, and there's an `ssh-agent` running in the host
session, it will be forwarded into the container so that you can use
things like `git clone` without further ado. Otherwise, a local `ssh-agent`
will be started inside the container, to which you can add identities from the
container's local `.ssh/` directory.

## amazoncorretto-11

This is the same as `amazoncorretto-17` but providing Corretto 11 instead of
Corretto 17. The previous generation of Shibboleth Java
products (specifically, v4 of the Identity Provider) was built on this platform.

Maven "site" builds for some projects for the Java
11 platform must be built in an `amazoncorretto-17` container.
These builds don't currently work under Java 11 distributions.

## Windows

These environments have been successfully used running under Windows.   The initial setup is more complicated owing to the fundamental impedance mismatch between Linux and Windows filesystem implementations.

[Set up Linux Containers on Windows 10][] is a good guide to installing docker on windows clients.    Once set up you need to configure the container.  Currently there are no command files to assist with this.

Running the container is done by using the same command line inside the relevant `runx` command.  For instance:

```bash
docker run -i -t --rm --name  shibboleth-build --hostname amazon11 --volume=%userprofile%\shibboleth-build-docker\user:/home/user ianayoung/shibboleth-build-docker:amazon11
```

**Note** that docker will only work on local volumes - do not try to set the volume to be on an SMB volume.

Equally it is safer to only use file which have been created within the docker container. Do not expect things to work if you populate files directly from windows and it is much easier to stage things into the `user` directory and then copy (not move) the files to their final location from inside the container.

On Windows:

* tar up the contents of your `%userprofile%\.ssh` directory and copy the tar file to the `user` directory
* Copy `%userprofile%\.m2\settings.xml` to the `user` directory
* GPGforWin is modern enough to use new style keyrings so extract the secret keys as per [GPG Keyring Format](#gpg-keyring-format) below.

Then on the _Linux_ side put the files where into their final location

```bash
# untar the ssh file and set protection (because this does not import easily)
tar xvf ssh .
rm ssh
chmod 600 .ssh\*

# copy the maven setting file
mkdir .m2
cp settings.xml .m2/settings.xml
rm settings.xml

# create the gpg set up.
gpg -import secret.asc
rm secret.asc
```

## Troubleshooting

### GPG Keyring Format

The version of GPG used in most of the image variants built here is quite old,
because the containers use the version of GPG that is current for the underlying
operating system. In most cases, this is something like version 2.0.

Outside the container, you may well be using something from the 2.2 series or later: this
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
gpg -a --export-secret-keys --output user/secret.asc
```

Now, perform the following _inside_ the container:

```bash
gpg --import secret.asc
```

### GPG agent

If the location of this repository _on the host_ is too far from the root (if
the length of the repository's path is too long), you may run into issues
starting a `gpg-agent` process:

```text
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

### Performance

If you are running these containers under Docker on a Linux system, you should
find that operations inside a container perform essentially indistinguishably to
running them on the host.

On the other hand, if you are running these containers using a technology such
as [Docker Desktop for Mac][], some operations will be significantly slower
because the containers are really running not on your host machine but on a
Linux virtual machine that is in turn running on your host machine. For
CPU-bound operations, the difference will likely not be noticeable in practice.

Operations that perform heavy I/O to the host filesystem (the `/home/user`
directory) may, however, be significantly slower because the host file system is
essentially remote to the container VM. We have found that the
`maven-javadoc-plugin` is particularly affected by this.

There are ways to [tune the performance of volume
mounts](https://docs.docker.com/docker-for-mac/osxfs-caching/) which we haven't
investigated yet. One fairly simple short-term solution should this problem
arise is to move the data from `/home/user` to the container's `/tmp` directory
temporarily. Because `/tmp` is local to the container, it exists within the
container VM rather than on the host file system and performance is much higher.
Of course one downside of this approach is that the `/tmp` directory does not
persist if you exit the shell and thus terminate the container; you should
ensure that the results of your operation are preserved either in `/home/user`
or otherwise before exiting.

[Docker]: https://www.docker.com
[Docker Desktop for Mac]: https://hub.docker.com/editions/community/docker-ce-desktop-mac
[Shibboleth]: https://shibboleth.net
[Set up Linux Containers on Windows 10]: https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/quick-start-windows-10-linux

### Doing things as root

The images are careful to build up an environment in which you do everything as a normal user inside the
container. When you run the image, the container startup sequence includes execution of a bootstrap
script that tweaks things as required to make this work, before dropping privileges and handing you
a user prompt.

There will always be cases where you may need to step outside those constraints. Here are a couple
of ways to do that:

* Build your own container. Simply change the Dockerfile to do what you want it to do, and rebuild.
* Sneak in the back door. Start the container as normal, and use the following command to
  get an additional prompt as `root`:

```bash
$ docker exec -it -u root shibboleth-build sh
sh-5.1#
```

Here, using `sh` instead of `bash` bypasses the bootstrap process.

* Use `sudo` inside the container. At the moment, for the various Rocky Linux images only,
  this is set up to allow the single command `update-crypto-policies` to be executed
  without providing a password. For example:

```bash
sudo update-crypto-policies --set FUTURE
```
