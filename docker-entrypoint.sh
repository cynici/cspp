#! /bin/sh

set -ux

HOME="${RUNUSER_HOME:-/home/runuser}"
export HOME

if [ -x /usr/sbin/useradd ]; then
  useradd -s /bin/false --no-create-home --home-dir "$HOME" -u $RUNUSER_UID runuser
else
  adduser -s /bin/false -D -h $HOME -H -u $RUNUSER_UID runuser
fi

set +u
if [ -d "$HOME/CSPP" ] ; then
  source $HOME/.bashrc
else
  echo "**** Download and extract CSPP package into $HOME/CSPP/" >&2
fi
exec gosu runuser "$@"
