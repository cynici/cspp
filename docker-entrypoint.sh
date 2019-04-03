#! /bin/bash
#
# bash is a prerequisite
#
set -x
if [ -n "${RUNUSER_UID:-}" ]; then
    export HOME="${RUNUSER_HOME:-/home/runuser}"
    if [ -x /usr/sbin/useradd ]; then
        useradd -s /bin/false --no-create-home --home-dir "$HOME" -u $RUNUSER_UID runuser
    else
        adduser -s /bin/false -D -h $HOME -H -u $RUNUSER_UID runuser
    fi
    if [ -f "$HOME/.bashrc" ] ; then
        source $HOME/.bashrc || {
            echo "ERROR: failed to source $HOME/.bashrc" >&2
        }
    else
        echo "**** Create $HOME/.bashrc per installation instructions" >&2
    fi
    
    [ -d "$HOME/CSPP" ] || {
        echo "**** Download and extract CSPP package into $HOME/CSPP/" >&2
    }
    exec gosu runuser "$@"
else
    exec "$@"
fi
