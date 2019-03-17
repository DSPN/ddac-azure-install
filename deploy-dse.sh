#!/usr/bin/env bash
# cluster name, datacenter name and seed nodes from ARM
echo "deploy-dse $1 $2 $3"
cluster_name=$1
dc=$2
seeds=$3
# create directories and soft links on mounted storage
/home/ddac/ddac-azure-install/dse-vm-dir-creations.sh &
dir_process_id=$!
wait $dir_process_id
/home/ddac/ddac-azure-install/dse-init.sh $cluster_name  $dc $seeds &
dse_init_process_id=$!
wait $dse_init_process_id
echo "deploy-dse ------> exit status $?"
exit 0
