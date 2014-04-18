#!/usr/bin/env bash
# when using docker mounted volumes, the owner/group is set to root
if [ `stat --format=%U /var/lib/elasticsearch` != "elasticsearch" ] ; then
  chown -R elasticsearch:elasticsearch /var/lib/elasticsearch
fi
if [ `stat --format=%U /var/log/elasticsearch` != "elasticsearch" ] ; then
  chown -R elasticsearch:elasticsearch /var/log/elasticsearch
fi

service elasticsearch start