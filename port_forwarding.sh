#!/bin/bash

echo "IP-server"; read -r ip ; \
echo "internal_port"; read -r in ; \
echo "external_port"; read -r ex ; \
FLO=$(openstack floating ip list -f value -c "Floating IP Address") &&
echo "$ex" '>' "$ip":"$in" > description.txt &&
openstack port list | grep "$ip" | awk -F '|' '{print $2}' | awk '{print substr($1,0)}' > IPP.txt &&
openstack floating ip port forwarding create \
--internal-ip-address "$ip" \
--port "$(< IPP.txt)" \
--internal-protocol-port "$in" \
--external-protocol-port "$ex" \
--protocol tcp "$FLO" &&
openstack floating ip set "$FLO" \
--description "$(< description.txt)" &&
echo "Success port forwarding"


<<COMMENT1
Скрипт делает проброс порта, предварительно запрашивает ip-сервера, интернал-порт и экстернал-порт.
Обратите внимание !!!
Если в проекте имеются больше 1 плавающего ip, тогда колонку FLO=$(openstack floating ip list -f value -c "Floating IP Address") 
необходимо переписать заменив на 
FLO=$ (openstack floating ip list | grep 185.0.0.0 | awk -F '|' '{print $2}' | awk '{print substr($1,0)}') 
где после grep нужно указать адрес плавающего ip
по которому нужно сделать проброс порта.
COMMENT1

