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

<<COMMENT1
Cкрипт выполняет следующие действия:
1. Командой openstack server list - выводится список серверов.
2. Введите "server_ID"
3. После ввода server_ID с помощью команды openstack server stop $s останавливается сервер.
4. Далее выводится список серверов и если сервер в статусе "SHUTOFF" выбираем значение "y" если нет, нажимаем "n" и цикл повториться.
5. Командой openstack volume list выводится список всех томов.
6. Заполняем "volume_ID" номером тома который планируем расширить.
7. Выводится строка "new_size_volume" в которой мы указываем новый размер для тома.
8. Командой openstack --os-volume-api-version 3.42 volume set $d --size $z изменяется размер выбранного тома.

Таким образом, скрипт выполняет следующую последовательность действий: останавливает определенный виртуальный сервер, 
запрашивает у пользователя информацию о том, был ли сервер выключен, и если да, то изменяет размер выбранного тома.
COMMENT1

