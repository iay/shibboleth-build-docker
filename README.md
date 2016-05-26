# shibboleth-build-docker

A [Docker][] environment for building [Shibboleth][] products
based on Shibboleth
[`parent-project-v3`](http://git.shibboleth.net/view/?p=java-parent-project-v3.git).

I'm using this in a [Docker for Mac][] setup, but [Docker Toolbox][] would
be a close equivalent. The idea here is to embed a stable environment for
building software within a normal desktop environment, using Docker's
container system. You could probably use Docker on a Linux system in the same
way.

To build the environment, just type `./build`.

To execute the environment, type `./run`. You will find yourself in a user
environment that looks very like CentOS 7, with the following tools available:

* maven (3.0.5)
* Subversion
* Git
* OpenJDK version 7

Java 7 is used here so that our build environment is based on the same version
as is specified by `parent-project-v3`. This is also important for the Cobertura
coverage tests, as those run into issues with Java 8.

When you're done with the environment, type Ctrl+D to exit. You'll find that
you now have a `user/` directory which contains the state of the user home
directory from the Docker container. If you start a new container with `./run`,
that state will be used again so that things like the local Maven repository
can be carried across runs.

If you have a Maven `settings.xml` file, you can copy it from
`~/.m2/settings.xml` into `user/.m2` so that it
takes effect within the container.

[Docker]: https://www.docker.com
[Docker for Mac]: https://blog.docker.com/2016/03/docker-for-mac-windows-beta/
[Docker Toolbox]: https://www.docker.com/products/docker-toolbox
[Shibboleth]: https://shibboleth.net
