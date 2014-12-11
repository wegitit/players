#!/bin/bash

###############################################################################
### Comment

# create "this is us" group
# create "this is us" user
# add user to "this is us" & sudo groups



###############################################################################
#### NOTES

# PLAYER does not need group:maint (maybe group player or some such), it DOES NOT need wheel
# TARGET SHOULD have group main & MUST HAVE group wheel

# Do not be seduced by -r, PLAYER and TARGET both need a /home (OTOH, neither needs a mailbox)

# Both of the following commands could use more grace. As they are, they check only for existence, not for configuraion, e.g. does user have a /home ?
#   A crude method: if x exists, xdel it, then xadd it with the proper options



###############################################################################
#### Main

# create group for user & give them sudo

# add (if it does not exist) group:
[ $(getent group maint) ] || groupadd maint


# add (if it does not exist) user:
# We don't need a mail dir:
#   Current solution: -K MAIL_DIR=/dev/null emits a safe to ignore warning (thus the [don't know what else is disappearing] dump to /dev/null)
[ $(getent passwd ansible) ] || useradd -K MAIL_DIR=/dev/null -g maint -G wheel ansible &> /dev/null

