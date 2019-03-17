#!/usr/bin/env bash
#  1st paramter is the datacenter
dc="$1"
# this function get ths fault domain to use as the rack
function get_rack {
    rack="rack1"

    zone=$(curl -sS --max-time 200 --retry 12 --retry-delay 5 -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-04-02" | \
jq .compute.platformFaultDomain | \
tr -d '"')
    if [ ! "$zone" ]; then
        rack="rack1"
    else
        rack=$zone
    fi
  echo $rack
}
#
rack=`get_rack`
getrack_process_id=$!
wait $getrack_process_id
#
file="/usr/share/dse/conf/cassandra-rackdc.properties"
# backup cassandra-racdc.properties
date=$(date +%F)
backup="$file.$date"
cp $file $backup
# 
cat $file \
| sed -e "s:^\(dc\=\).*:dc\=$dc:" \
| sed -e "s:^\(rack\=\).*:rack\=$rack:" \
| sed -e "s:^\(prefer_local\=\).*:rack\=true:" \
> $file.new
#
mv $file.new $file
chown cassandra $file
chgrp cassandra $file
echo "dse-vm-rack-props ------> exit status $?"
