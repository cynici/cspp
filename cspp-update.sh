#!/bin/bash
#
# Initial run only???
#sdr_luts.sh -d -W /home/runuser/tmp
#
# Recommended daily amcillary files update for CSPP v3.1.2
set -eu
source /home/runuser/.bashrc
sdr_ancillary.sh -d -W /home/runuser/tmp
