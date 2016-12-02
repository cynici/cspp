#! /bin/bash

RUNUSER_UID="${RUNUSER_UID:-1000}"
RUNUSER_HOME="${RUNUSER_HOME:-/home/runuser}"

set -ux

useradd -s /bin/false --no-create-home --home-dir "$RUNUSER_HOME" -u $RUNUSER_UID runuser

export CSPP_SDR_HOME="${CSPP_SDR_HOME:-${RUNUSER_HOME}/CSPP/SDR_2_2}"
export CSPP_EDR_HOME="${CSPP_EDR_HOME:-${RUNUSER_HOME}/CSPP/EDR_2_0}"

if [ -d "$RUNUSER_HOME/CSPP" ] ; then
  source $CSPP_SDR_HOME/cspp_sdr_env.sh
  source $CSPP_EDR_HOME/cspp_edr_env.sh
else
  echo "**** Download and extract CSPP package into $RUNUSER_HOME/CSPP/" >&2
fi

exec gosu runuser "$@"
