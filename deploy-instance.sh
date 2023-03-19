#!/bin/bash
echo "Deploying"
#Random number generate
NUM=$((1 + RANDOM % 200)) &&
# Create port 
DNIC=$(openstack network list | grep "#" | awk -F '|' '{print $2}' | awk '{print substr($0,2,37)}') &&
DSUB=$(openstack subnet list | grep "#" | awk -F '|' '{print $2}' | awk '{print substr($0,2,37)}') &&
DPORT=$(openstack port create --network "$DNIC" --fixed-ip subnet="$DSUB",ip-address="192.168.2.$NUM" PORT -f value -c id) &&
#Image_menu 
echo "Size_Volume"; read -r i ;
PS3="Image:"
select z in "Windows 10 RU" \
"Windows_Server_2019_Standart_EN" \
"Windows Server 2019 Standart RU" \
"Windows2019-SysElegance" \
"Windows2016-SysElegance" \
"Windows_Server_2016_Standart_EN" \
"Windows_Server_2016_Standart_RU" \
"Windows_Server_2012R2_Standart_EN" \
"Windows_Server_2012R2_Standart_RU" \
"Ubuntu Server 16.04.7 LTS x64" \
"Ubuntu Server 18.04.5 LTS x64" \
"Ubuntu Server 20.04.4 LTS x64 (Focal Fossa)" \
"Ubuntu Server 22.04 LTS x64 (Jammy Jellyfish)" \
"Veeam Recovery Media 5.0.0 Windows" \
"VeeamRecoveryMedia_4.0_Linux" \
"CentOS 7.9.2009" \
"CentOS_8.1.1911_x64" \
"CentOS_Stream" \
"Debian 10.6 x64" \
"Debian 10.9 x64" \
"Debian 9.13 x64" \
"FreeBSD_11.3" \
"FreeBSD_12.2_Release";
do
break
done
PS3="Availability-zone:"
select zone in "lviv" \
"nova";
do
#Create_Volume	
DVOL=$(openstack volume create --image "$z" --size "$i" --availability-zone "$zone" Volume -f yaml | xargs | awk '{print substr($0,161,36)}') &&
break
done
#Flavor_menu
echo "Name_Instance"; read -r b ;
PS3="Flavor:"
select flavor in "ext_1024_p1_50gb" \
"ext_2048_p1_50gb" \
"ext_4096_p2_50gb" \
"ext_8192_p4_50gb" \
"ext_12288_p4_50gb" \
"ext_16384_p6_50gb" \
"ext_24576_p8_50gb" \
"ext_32768_p10_50gb" \
"ext_40960_p12_50gb" \
"ext_49152_p16_50gb" \
"ext_65536_p18_50gb" \
"ext_98304_p24_50gb";
do
#Create_Instance	
openstack server create "$b" --flavor "$flavor" --volume "$DVOL" --availability-zone "$zone" --port "$DPORT"
break
done
#Port Forwarding
echo "Стандартный_port"; read -r in ; \
echo "Нестандартный_port"; read -r ex ; \
DFLO=$(openstack floating ip list | grep 185 | awk -F '|' '{print $2}' | awk '{print substr($1,0)}') &&
echo "$ex" '>' ""192.168.2.$NUM"":"$in" > description.txt &&
openstack floating ip port forwarding create --internal-ip-address "192.168.2.$NUM" --port "$DPORT" --internal-protocol-port "$in" \
--external-protocol-port "$ex" --protocol tcp "$DFLO" &&
openstack floating ip set "$DFLO" --description "$(< description.txt)" &&
openstack floating ip list -f value -c "Floating IP Address" &&
echo "IP для удаленного подключения"
