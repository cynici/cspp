#! /bin/sh

RUNUSER_UID="${RUNUSER_UID:-1000}"
RUNUSER_HOME="${RUNUSER_HOME:-/home/runuser}"

set -ux

if [ -x /usr/sbin/useradd ]; then
  useradd -s /bin/false --no-create-home --home-dir "$RUNUSER_HOME" -u $RUNUSER_UID runuser
else
  adduser -s /bin/false -D -h $RUNUSER_HOME -H -u $RUNUSER_UID runuser
fi

[ -d "$RUNUSER_HOME/CSPP" ] || {
  echo "**** Download and extract CSPP package into $RUNUSER_HOME/CSPP/" >&2
}

export CSPP_SDR_HOME="${CSPP_SDR_HOME:-${RUNUSER_HOME}/CSPP/SDR_2_2}"
export CSPP_EDR_HOME="${CSPP_EDR_HOME:-${RUNUSER_HOME}/CSPP/EDR_2_0}"

exec gosu runuser "$@"
