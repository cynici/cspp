# CSPP v3.1 Runtime Environment

This repo builds a Docker image that can run [Community Satellite Processing Package (CSPP)](http://cimss.ssec.wisc.edu/cspp/) package provided by [Cooperative Institute for Meteorological Satellite Studies (CIMSS)](http://cimss.ssec.wisc.edu/) of [Space Science and Engineering Center (SSEC)](http://www.ssec.wisc.edu/) at the [University of Wisconsin](http://www.wisc.edu/).

[phusion/baseimage](https://hub.docker.com/r/phusion/baseimage/) is used as the base image because it includes a functional cron service which is useful for keeping the ancillary data required by CSPP up-to-date.

[gosu](https://github.com/tianon/gosu) is included so that the code is run using a non-root user in the Docker container for better security.


## Hardware requirements

* Intel or AMD CPU with 64-bit instruction support

* 16 GB RAM when running 1-core processing. Add 8 GB for every additional
concurrent processing core

* CentOS 6 64-bit Linux (or other compatible 64-bit Linux distribution)

* 100 GB disk space (minimum)

* Internet connection (for downloading ancillary data)

## Software requirements to use this repo

* docker-ce 18.03+
* docker-compose 1.11+ (optional, more convenient)

## Usage

* Download required software from https://cimss.ssec.wisc.edu/cspp/download/. For VIIRS active fire, you will need:
  * CSPP S-NPP SDR Software
  * CSPP S-NPP SDR Static Files
  * VIIRS EDR Version 2.0 Software for Linux 
  * VIIRS EDR Version 2.0 Dynamic Starter Files 
  * VIIRS EDR Version 1.2 Static Ancillary Files
  * VIIRS Imagery EDR V2.0 Software for Linux 
  * VIIRS Imagery EDR V2.0 Dynamic Starter Files 

* Optionally, download the Test Files in the respective groups

* Go to directory in a partition with plenty of free disk space

* Create directories for runtime user and data products

```
mkdir -p home/{CSPP,tmp} data/incoming
```

* Extract every file download previously.

```
cd home/CSPP
# Repeat tar xf for all downloaded tarballs
tar xf ../CSPP_VIIRS_EDR_V2.0.tar.gz
```

* Create `docker-compose.yml`. If you decide not to use `docker-compose`,
you're on your own. ;-) Just map the directives to `docker`
command line options. Set *RUNUSER_UID* accordingly who will
own everything in *home* and *data* directories. In the example below,
it assumes that both *home* and *data* directories are in
the same directory where `docker-compose.yml` is located.

```
version: '2.2'
services:
  cspp:
    image: cheewai/cspp
    environment:
    - RUNUSER_UID=1000
    volumes:
    - ./home:/home/runuser
    - ./data:/data
```

* Pull docker image [cheewai/cspp](https://hub.docker.com/r/cheewai/cspp)
from Docker hub, `docker-compose pull`. Alternatively, you can clone
this git repo and build the Docker image locally, in which case,
you should replace *image* with *build* in the `docker-compose.yml` file.

* Read installation instructions to
  * Create `/home/runuser/.bashrc`
  * Schedule cron job to update ancillary files

The CSPP software will download current ancillary files it requires
while processing input data. You can shave some minutes off if you
run schedule a daily cron job to run this container to download
ancillary files like so:

```
docker-compose run -T --rm cspp /usr/local/bin/cspp-update.sh
```

On arrival of new input data, simply run

```
docker-compose run -T --rm cspp viirs_sdr.sh ...
docker-compose run -T --rm cspp viirs_edr.sh ...
```

## Processing historical data sets

From the CSPP v2.2 Installation Guilde:

> CSPP SDR Version 2.2 can be used for creating VIIRS, CrIS and ATMS SDRs from historical RDRs beginning with data collected on 5 July 2014. However, processing historical VIIRS datasets that cross the static LUT to RSBAUTOCAL coefficient file boundary (See section 2.2.1) of 9 November 2015 at 17:00 UTC, will cause the CSPP SDR v2.2 software to fail. Processing data sets that begin and end prior to this boundary, or begin and end after this boundary will complete successfully.

