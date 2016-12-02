#!/bin/bash

source $CSPP_SDR_HOME/cspp_sdr_env.sh
mirror_jpss_luts.bash
mirror_jpss_sdr_ancillary.bash

source $CSPP_EDR_HOME/cspp_edr_env.sh
cd $CSPP_EDR_HOME/common/cspp_cfg/cfg && \
mv IETTime.dat IETTime.dat.old && \
wget ftp://ftp.ssec.wisc.edu/pub/CSPP/leapsec/IETTime.dat
