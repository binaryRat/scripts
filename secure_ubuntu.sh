#!/bin/bash

#disable usb vulnerability
#echo blacklist usbhid > /etc/modprobe.d/usbhid.conf
#update-initramfs -u -k $(uname -r)

#enable firewall
ufw enable

#disable every connection
ufw default deny incoming
ufw default deny forward
ufw default deny outgoing

#enable only DNS HTTP HTTPS (use CloudFlare DNS) 
#TODO dns over https o tls (stubby)
ufw allow out on enp0s3 to 1.1.1.1 proto udp port 53 comment 'allow DNS on enp0s3'
ufw allow out on enp0s3 to any proto tcp port 80 comment 'allow HTTP on enp0s3'
ufw allow out on enp0s3 to any proto tcp port 443 comment 'allow HTTPS on enp0s3'
#se un servizio funziona male per colpa di ufw lo si può vedere in 
#	tail -f /var/log/ufw.log
#in caso riabilitare il outgoing con 
#	ufw default allow outgoing
#oppure creare una regola apposita con 
#	ufw allow out on <interface> from <ip> to <ip> proto tcp port <port>

#TODO Modificare la il dns della connessione /etc/NetworkManager/system-connections/
systemctl restart NetworkManager

#disable CUPS (printers interface)
systemctl disable cups-browsed

apt install apparmor-profiles apparmor-utils
aa-enforce /etc/apparmor.d/*
