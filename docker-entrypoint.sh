#! /bin/bash
#
# bash is a prerequisite
#
set -ux
export HOME="${RUNUSER_HOME:-/home/runuser}"

if [ -x /usr/sbin/useradd ]; then
  useradd -s /bin/false --no-create-home --home-dir "$HOME" -u $RUNUSER_UID runuser
else
  adduser -s /bin/false -D -h $HOME -H -u $RUNUSER_UID runuser
fi

set +u
test -f "$HOME/.bashrc" || {
  cat >$HOME/.bashrc <<EOF
export CSPP_SDR_HOME=\$HOME/CSPP/SDR_2_2
source \$CSPP_SDR_HOME/cspp_sdr_env.sh

export CSPP_EDR_HOME=\$HOME/CSPP/EDR_2_0
source \$CSPP_EDR_HOME/cspp_edr_env.sh

export CSPP_GTM_HOME=\$HOME/CSPP/GTM_2_0
source \$CSPP_GTM_HOME/cspp_gtm_env.sh

export POLAR2GRID_HOME=\$HOME/CSPP/polar2grid_v_2_0
source \$POLAR2GRID_HOME/bin/polar2grid_env.sh
EOF
  echo "Created $HOME/.bashrc"
}
source $HOME/.bashrc
test -d "$HOME/CSPP" || {
  echo "**** Download and extract CSPP package into $HOME/CSPP/" >&2
}
exec gosu runuser "$@"
