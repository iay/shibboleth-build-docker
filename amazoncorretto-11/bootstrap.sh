#!/bin/bash

#
# Bootstrap script runs as root before surrendering to the user.
#

#
# Allow user access to the forwarded SSH agent socket, if there is one.
#
forwarded=/run/host-services/ssh-auth.sock
if [ -e ${forwarded} ]; then
  chown user:user ${forwarded}
fi

#
# Become the user, and "log in".
#
su - user
