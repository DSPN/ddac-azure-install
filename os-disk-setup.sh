#!/usr/bin/env bash
# external storage setup in bash
# currently ARM templates run this
disksize=$1
# yikes if we travel down below path
if [ "$disksize" -eq "0" ]; then
   echo "disksize = 0, no disk to mount. Creating symlink /data -> /mnt...";
   ln -s /mnt /data
   mkdir -p /data/cassandra/data
   mkdir -p /data/cassandra/commitlog
   mkdir -p /data/cassandra/saved_caches
   chown -R cassandra:cassandra /data/cassandra
   exit;
fi
# mount data disk
cp /etc/fstab /etc/fstab.bak
# add C* data disk
mkfs -t ext4 /dev/sdc
uuid=$(blkid /dev/sdc -sUUID -ovalue)
mkdir -p /data/cassandra
echo "# Cassandra data mount, template auto-generated." >> /etc/fstab
echo "UUID=$uuid       /data/cassandra   ext4    defaults,nofail        1       2" >> /etc/fstab
mount -a
echo "os-disk-setup ------> exit status $?"
