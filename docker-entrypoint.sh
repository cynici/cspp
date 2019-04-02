#! /bin/bash
#
# bash is a prerequisite
#
export HOME="${RUNUSER_HOME:-/home/runuser}"
set -u
if [ -x /usr/sbin/useradd ]; then
  useradd -s /bin/false --no-create-home --home-dir "$HOME" -u $RUNUSER_UID runuser
else
  adduser -s /bin/false -D -h $HOME -H -u $RUNUSER_UID runuser
fi
set +u

if [ -f "$HOME/.bashrc" ] ; then
  source $HOME/.bashrc
else
  echo "**** Create $HOME/.bashrc per installation instructions" >&2
fi

test -d "$HOME/CSPP" || {
  echo "**** Download and extract CSPP package into $HOME/CSPP/" >&2
}

exec gosu runuser "$@"
