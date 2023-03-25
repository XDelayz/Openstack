#!/bin/bash

openstack server list

echo "Нужно ли выключать сервер y/n"
read -r answer

# Если ответ "y" или "Y", остановить сервер
if [[ "$answer" =~ ^[yY]$ ]]; then
  echo "Введите ID сервера:"
  read -r server_id
  openstack server stop "$server_id"
  openstack volume list
  echo "Введите ID тома, который нужно раширить:"
  read -r volume_id
  echo "Введите новый размер тома:"
  read -r new_size

  # Изменить размер тома
  openstack --os-volume-api-version 3.42 volume set "$volume_id" --size "$new_size"

  # Показать список томов после изменения
  openstack volume list

# Если ответ "n" или "N", изменить размер тома
elif [[ "$answer" =~ ^[nN]$ ]]; then
  # Показать список томов
  openstack volume list
  echo "Введите ID тома, который нужно расширить:"
  read -r volume_id
  echo "Введите новый размер тома:"
  read -r new_size
  openstack --os-volume-api-version 3.42 volume set "$volume_id" --size "$new_size"

  # Показать список томов после изменения
  openstack volume list
fi

# Запросить пользователя о расширении еще одного тома
  echo "Хотите изменить размер еще одного тома? (y/n)"
  read -r expand_another
  if [[ "$expand_another" =~ ^[yY]$ ]]; then
    # Если пользователь хочет расширить еще один том, показать список томов
    openstack volume list
    echo "Введите ID тома, который нужно раширить:"
    read -r volume_id
    echo "Введите новый размер тома:"
    read -r new_size
    openstack --os-volume-api-version 3.42 volume set "$volume_id" --size "$new_size"
    openstack volume list
  fi
