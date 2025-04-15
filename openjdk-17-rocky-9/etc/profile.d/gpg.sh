#
# Set up the TTY for GPG's user agent and pinentry application.
#
export GPG_TTY=$(tty)

#
# Remove any stale agent socket.
#
rm -f ~/.gnupg/S.gpg-agent
