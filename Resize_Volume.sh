#!/bin/bash
openstack server list &&
echo "server_ID"; read -r s ;
openstack server stop $s &&
while true
do
openstack server list
echo "Server OFF y/n"
read CONFIRM
case $CONFIRM in
y|Y) openstack volume list &&
echo "volume_ID" ; read -r d ;
echo "new_size_volume"; read -r z ;
openstack --os-volume-api-version 3.42 volume set $d --size $z &&
openstack volume list ;
break
esac
done



