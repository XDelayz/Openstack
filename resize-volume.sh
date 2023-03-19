#!/bin/bash
# скрипт расширяет системный диск, предварительно выключает сервер
# скрипт интерактивный, он выводит список серверов и запрашивает id сервера который нужно выключить перед расширением
# обратите внимание что нажимать [y] нужно только в том случае если сервер перешел в статус shutdown, если сервер еще не выключился нажимаем [n]
# после успешного выключения будет выведено список дисков, выбираем который нужно расширить и указываем новое значение диска
# также обращаю внимание что скрипт не будет работать если у вас стоит версия python-openstackclient меньше 3.42 версии, удачи!

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



