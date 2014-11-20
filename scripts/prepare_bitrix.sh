#!/bin/sh -ex

yum -y install expect

yum -y install samba samba-winbind samba-common samba-client samba-winbind-clients

mkdir /tmp/scripts

wget http://repos.1c-bitrix.ru/yum/bitrix-env.sh -O /tmp/scripts/bitrix-env.sh
chmod +x /tmp/scripts/bitrix-env.sh 

