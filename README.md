# shibboleth-build-docker

A collection of [Docker][] environments for building [Shibboleth][] products
based on Shibboleth
[`parent-project-v3`](http://git.shibboleth.net/view/?p=java-parent-project-v3.git).

I'm using this in a [Docker for Mac][] setup, but [Docker Toolbox][] would
be a close equivalent. The idea here is to embed a stable environment for
building software within a normal desktop environment, using Docker's
container system. You could probably use Docker on a Linux system in the same
way.

## openjdk-7-centos-7

The `openjdk-7-centos-7` directory builds what should be regarded as
the default environment.

The image is based on the [CentOS][] 7 userspace, with the following tools available:

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

The image will be tagged as `shibboleth-build-docker:o7-c7`.

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

[CentOS]: https://www.centos.org
[Docker]: https://www.docker.com
[Docker for Mac]: https://blog.docker.com/2016/03/docker-for-mac-windows-beta/
[Docker Toolbox]: https://www.docker.com/products/docker-toolbox
[Shibboleth]: https://shibboleth.net
