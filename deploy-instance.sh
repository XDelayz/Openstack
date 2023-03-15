#!/bin/bash
echo "Processing"
rang=$(((1 + RANDOM % 200))) &&
echo $rang > echo.txt &&
echo 192.168.2."$(< echo.txt)" > echho.txt &&
openstack network list | grep "#" | awk -F '|' '{print $2}' | awk '{print substr($0,2,37)}' > net.txt &&
openstack subnet list | grep "#" | awk -F '|' '{print $2}' | awk '{print substr($0,2,37)}' > subnet.txt &&
openstack port create --network "$(< net.txt)" --fixed-ip subnet="$(< subnet.txt)",ip-address="$(< echho.txt)" server-port-fix -f value -c id > idi-port.txt &&
echo "Size_Volume"; read -r i ;
PS3="Image:"
select z in "Acronis bootCD" \
"Amazon-Centos-8.3" \
"BitrixVM 7.5.0" \
"CSR-1000v" \
"CentOS 7.9.2009" \
"CentOS_8.1.1911_x64" \
"CentOS_Stream" \
"Cisco ASA v9-14-2-8" \
"Clonezilla-live-2.7.3-19" \
"Debian 10.6 x64" \
"Debian 10.9" \
"Debian 10.9 x64" \
"Debian 9.13 x64" \
"FreeBSD_11.3" \
"FreeBSD_12.2_Release" \
"FreePBX 15" \
"GParted" \
"HBCD-SSD" \
"MikroTik-CHR" \
"OPNsense-21-1" \
"SysElegance" \
"TelegrafTest" \
"Trove-Ubuntu" \
"Trove-Ubuntu-Wallaby" \
"TrueNAS 12.0 U4" \
"Ubuntu 16.04.7" \
"Ubuntu 16.04.7 x64" \
"Ubuntu 18.04.5" \
"Ubuntu 18.04.6" \
"Ubuntu Server 16.04.7 LTS x64" \
"Ubuntu Server 18.04.5 LTS x64" \
"Ubuntu Server 20.04.4 LTS x64 (Focal Fossa)" \
"Ubuntu Server 22.04 LTS x64 (Jammy Jellyfish)" \
"Ubuntu_Server_20.04LTS_hardened" \
"Veeam Recovery Media 5.0.0 Windows" \
"VeeamRecoveryMedia_4.0_Linux" \
"Virtio" \
"VyOS" \
"Windows 10 RU" \
"Windows Server 2019 Standart RU" \
"Windows Server 2022 Standart EN" \
"Windows2016-SysElegance" \
"Windows2019-SysElegance" \
"Windows_2016_TORGSOFT" \
"Windows_Server_2012R2_Standart_EN" \
"Windows_Server_2012R2_Standart_RU" \
"Windows_Server_2016_Standart_EN" \
"Windows_Server_2016_Standart_RU" \
"Windows_Server_2019_Standart_EN" \
"fedora-atomic-latest" \
"securityonion-2.3" \
"systemrescue-9.01-amd64" \
"veeam-recovery-media-linux" \
"zosProxy-tpl";
do
break
done
PS3="Availability-zone:"
select zone in "lviv" \
"nova";
do
openstack volume create --image "$z" --size "$i" --availability-zone "$zone" Volume -f yaml | xargs | awk '{print substr($0,161,36)}' > vol.txt &&
break
done
echo "Name_Instance"; read -r b ; 
PS3="Enter a Flavor:"
select flavor in "ext_1024_p1_50gb" \
"ext_98304_p24_50gb" \
"ext_49152_p16_50gb" \
"ext_2048_p1_50gb" \
"ext_40960_p12_50gb" \
"ext_65536_p18_50gb" \
"ext_12288_p4_50gb" \
"ext_32768_p10_50gb" \
"ext_24576_p8_50gb" \
"ext_8192_p4_50gb" \
"ext_1024_p1_50gb_temp" \
"ext_4096_p2_50gb" \
"ext_16384_p6_50gb";
do
openstack server create "$b" --flavor "$flavor" --volume "$(< vol.txt)" --availability-zone "$zone" --port "$(< idi-port.txt)"
break
done
echo "Internal_port"; read -r in ; \
echo "External_port"; read -r ex ; \
openstack floating ip list | grep 185 | awk -F '|' '{print $2}' | awk '{print substr($1,0)}' > float.txt &&
echo "$ex" '>' ""$(< echho.txt)"":"$in" > description.txt &&
openstack floating ip port forwarding create --internal-ip-address "$(< echho.txt)" --port "$(< idi-port.txt)" --internal-protocol-port "$in" \
--external-protocol-port "$ex" --protocol tcp "$(< float.txt)" &&
openstack floating ip set "$(< float.txt)" --description "$(< description.txt)" &&
openstack floating ip list -f value -c "Floating IP Address" &&
echo "IP_Remote_Connection"
