#!/bin/bash -ex

# Set timezone
echo 'ZONE="Europe/Moscow"' > /etc/sysconfig/clock
tzdata-update
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql

# Time between system and database fix
sed -i 's|define("DBPersistent"|date_default_timezone_set("Europe/Moscow");\n&|' /home/bitrix/www/bitrix/php_interface/dbconn.php
sed -i 's|define("DBPersistent"|ini_set("memory_limit", "256M");\n&|' /home/bitrix/www/bitrix/php_interface/dbconn.php
sed -i '/BX_CRONTAB_SUPPORT/d' /home/bitrix/www/bitrix/php_interface/dbconn.php

# Mail fix
sed -i 's|sendmail_path =.*|sendmail_path = /usr/sbin/sendmail -t -i|' /etc/php.d/bitrixenv.ini

# Install incron daemon
yum -y install incron
chkconfig incrond on

# Create check
wget https://cdn.rawgit.com/methodx/b505c0aedff6da681b61/raw/8f4fe0c7047792edde481f33ca461e422b193512/check -O /etc/incron.d/bitrixfix

# Add incron script for fixing after_connect files
wget https://cdn.rawgit.com/methodx/85a18377ea196fa548a0/raw/de67244cb2a07fe5139910e3eff7d85a9a193852/gistfile1.sh -O /home/bitrix/www/bitrix/php_interface/bitrixfix.sh
chmod +x /home/bitrix/www/bitrix/php_interface/bitrixfix.sh

# Add bitrix APC cache configuration
wget https://cdn.rawgit.com/methodx/2a129a70d24d81b1e6c3/raw/27693e7fcbe76e8dabca1f59e8de7586257bc8d9/bitrix_apc -O /home/bitrix/www/bitrix/.settings_extra.php
chown bitrix: /home/bitrix/www/bitrix/.settings_extra.php
chmod 644 /home/bitrix/www/bitrix/.settings_extra.php