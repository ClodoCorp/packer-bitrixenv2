#!/bin/bash -ex

# Set timezone
echo 'ZONE="Europe/Moscow"' > /etc/sysconfig/clock
tzdata-update
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql

# Time between system and database fix
sed -i 's|define("DBPersistent"|date_default_timezone_set("Europe/Moscow");\n&|' /home/bitrix/www/bitrix/php_interface/dbconn.php
sed -i 's|define("DBPersistent"|ini_set("memory_limit", "512M")\n&|' /home/bitrix/www/bitrix/php_interface/dbconn.php
sed -i "s|.*?>.*|\$DB->Query(\"SET LOCAL time_zone='Europe/Moscow'\");\n& |" /home/bitrix/www/bitrix/php_interface/after_connect.php
sed -i "s|.*?>.*|\$connection->queryExecute(\"SET LOCAL time_zone='Europe/Moscow'\");\n&|" /home/bitrix/www/bitrix/php_interface/after_connect_d7.php

# Mail fix
sed -i 's|sendmail_path =.*|sendmail_path = /usr/sbin/sendmail -t -i|' /etc/php.d/bitrixenv.ini