FROM phusion/baseimage
LABEL maintainer "Cheewai Lai <cheewai.lai@gmail.com>"

ARG GOSU_VERSION=1.11
ARG GOSU_DOWNLOAD_URL="https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get -qq install csh lftp wget curl \
 && curl -o /usr/bin/gosu -kfsSL "$GOSU_DOWNLOAD_URL" \
 && chmod +x /usr/bin/gosu \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD cspp-update.cron /etc/cron.d/cspp-update
RUN chown root:root /etc/cron.d/cspp-update

ADD docker-entrypoint.sh /docker-entrypoint.sh
WORKDIR /home/runuser
ENTRYPOINT ["/docker-entrypoint.sh"]

# By default, the container in daemon-mode simply runs
# cron to update CSPP ancillary files
USER root
CMD ["/usr/sbin/cron", "-f"]
