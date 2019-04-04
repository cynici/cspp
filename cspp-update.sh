#!/bin/bash
#
# Initial run only???
#sdr_luts.sh -d -W /home/runuser/tmp
#
# Recommended daily amcillary files update for CSPP v3.1.2
set -eu
[ -f /home/runuser/.bashrc ] && [ -d /home/runuser/CSPP ] || {
    echo "CSPP not set up or missing from /home/runuser/CSPP" >&2
    exit 1
}
source /home/runuser/.bashrc
sdr_ancillary.sh -d -W /home/runuser/tmp
