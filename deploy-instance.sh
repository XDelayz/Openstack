#!/bin/bash
im=$(openstack image list -f value -c Name) # команда выводит список образов и записывает в переменную
images=() # создается пустой массив
while read -r line; do # построчное чтение списка образов из переменной "$im"
images+=("$line")
done <<< "$im"

PS3="Image:" # выводит меню из образов для выбора
select z in "${images[@]}"; do
break
done

PS3="Availability-zone:"
select zone in "lviv" \
"nova";
do
echo "Size_Volume"; read -r i ; 

# создается диск на основе образа для дальнейшего создания сервера с диска
DVOL=$(openstack volume create --image "$z" --size "$i" --availability-zone "$zone" Volume -f yaml | xargs | awk '{print substr($0,161,36)}') &&
break
done
echo "Name_Instance"; read -r b ;

fla=$(openstack flavor list -f value -c Name)
flavor=()
while read -r line; do
flavor+=("$line")
done <<< "$fla"

PS3="Flavor:"
select f in "${flavor[@]}"; do
break
done

NUM=$((1 + RANDOM % 200)) && # генерируется рандомное число из диапазона 1-200
DNIC=$(openstack network list | grep "#" | awk -F '|' '{print $2}' | awk '{print substr($0,2,37)}') &&
DSUB=$(openstack subnet list | grep "#" | awk -F '|' '{print $2}' | awk '{print substr($0,2,37)}') &&

# создается порт
DPORT=$(openstack port create --network "$DNIC" --fixed-ip subnet="$DSUB",ip-address="192.168.2.$NUM" PORT -f value -c id) &&

# создается сервер
openstack server create "$b" --flavor "$f" --volume "$DVOL" --availability-zone "$zone" --port "$DPORT"

# запрос на порт-форвардинг
echo "internal_port"; read -r in ; \
echo "external_port"; read -r ex ; \
DFLO=$(openstack floating ip list | grep 185 | awk -F '|' '{print $2}' | awk '{print substr($1,0)}') &&
echo "$ex" '>' ""192.168.2.$NUM"":"$in" > description.txt &&
openstack floating ip port forwarding create --internal-ip-address "192.168.2.$NUM" --port "$DPORT" --internal-protocol-port "$in" \
--external-protocol-port "$ex" --protocol tcp "$DFLO" &&
openstack floating ip set "$DFLO" --description "$(< description.txt)" &&
openstack floating ip list -f value -c "Floating IP Address" &&
echo "IP для удаленного подключения"
