#!/bin/sh -ex

case $PROVISIONER in
    cloudinit)
        yum -y install dracut-modules-growroot || true
        ;;
esac

echo "==> Cleaning up yum cache of metadata and packages to save space"
yum -y clean all

rm -rf /tmp/script.sh /root/anaconda-ks.cfg /root/install.log /root/install.log.syslog /etc/udev/rules.d/70-persistent-net.rules

fstrim -v /
