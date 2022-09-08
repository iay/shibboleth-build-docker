#!/bin/bash

#
# Set up an SSH agent.
#

#
# If an SSH agent has already been set up, accept that.
# Otherwise, launch a local one.
#
forwarded=/run/host-services/ssh-auth.sock
if [ -e ${forwarded} ]; then
  echo "Using forwarded ssh-agent"
  export SSH_AUTH_SOCK=${forwarded}
else
  eval `ssh-agent`
fi
