#!/bin/sh -ex

sed -i 's|^sendmail_path = msmtp -t -i|sendmail_path =  sendmail -t|g' /etc/php.d/bitrixenv.ini
sed -i 's|^date.timezone = Europe/Moscow|date.timezone = posix/UTC|g' /etc/php.d/bitrixenv.ini
sed -i 's|^hostlist   relay_from_hosts = 127.0.0.1|hostlist   relay_from_hosts = 127.0.0.1\n trusted_users = bitrix\n|g' /etc/exim/exim.conf

echo "==> Cleaning up yum cache of metadata and packages to save space"
yum -y clean all

rm -rf /tmp/scripts

rm -f /etc/udev/rules.d/70-persistent-net.rules


#sed -i 's|^disable_root:.*|disable_root: 0|g' /etc/cloud/cloud.cfg
#sed -i 's|^ssh_pwauth:.*|ssh_pwauth: 1|g' /etc/cloud/cloud.cfg


fstrim -v /
