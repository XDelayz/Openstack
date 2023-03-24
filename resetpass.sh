#!/bin/bash
# Скрипт запрашивает id-сервера и сбрасывает пароль предварительно его генерируя.
Avadakedavra=$( openssl rand 9 -base64) &&
echo "ID-Server"; read -r i ;
openstack server set --password "$Avadakedavra" "$i"
echo New_Password:"$Avadakedavra"
