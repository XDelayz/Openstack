#!/bin/bash

#Диапазон портов
pool=({35000..35010})

for pool in "${pool[@]}"; do
openstack floating ip port forwarding create \
--internal-ip-address 192.168.2.109 \
--port d1022cfd-941d-4bcc-9917-615ec941cdec \
--internal-protocol-port ${pool} \
--external-protocol-port ${pool} \
--protocol tcp 195.0.0.109
done
