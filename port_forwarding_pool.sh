#!/bin/bash

pool=(25 80 110 143 443 465 587 993 995 522 5223 9071 7071)

for pool in "${pool[@]}"; do
openstack floating ip port forwarding create --internal-ip-address [ip-server] --port [id-port] --internal-protocol-port ${pool} --external-protocol-port ${pool} --protocol tcp [floating_ip] 
done

<<COMMENT1
Скрипт по циклу for создает сразу несколько пробросов портов.
Обратите внимание!!!
ip-server
floating_ip 
id-port 
их необходимо заполнять своими данными перед запуском скрипта, а в скобках переменной pool я указываю список портов для проброса.
COMMENT1
