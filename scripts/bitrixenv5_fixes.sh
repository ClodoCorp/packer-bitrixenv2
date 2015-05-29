#!/bin/bash -ex

# Set timezone
echo 'ZONE="Europe/Moscow"' > /etc/sysconfig/clock
tzdata-update
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql

# Time between system and database fix
sed -i 's|define("DBPersistent"|date_default_timezone_set("Europe/Moscow");\n&|' /home/bitrix/www/bitrix/php_interface/dbconn.php
sed -i 's|define("DBPersistent"|ini_set("memory_limit", "256M");\n&|' /home/bitrix/www/bitrix/php_interface/dbconn.php

# Mail fix
sed -i 's|sendmail_path =.*|sendmail_path = /usr/sbin/sendmail -t -i|' /etc/php.d/bitrixenv.ini

# Install incron daemon
yum -y install incron
chkconfig incrond on

# Create check
cat << EOF > /etc/incron.d/bitrixfix
/home/bitrix/www/bitrix/php_interface/ IN_CREATE /home/bitrix/www/bitrix/php_interface/bitrixfix.sh $@ $#
EOF

# Add incron script for fixing after_connect files
cat << EOF > /home/bitrix/www/bitrix/php_interface/bitrixfix.sh
#!/bin/bash
[ "$2" == "after_connect.php" ] && sed -i "s|.*?>.*|\$DB->Query(\"SET LOCAL time_zone='Europe/Moscow'\");\n& |" $1$2 && echo "$2 fixed" > $1log
[ "$2" == "after_connect_d7.php" ] && sed -i "s|.*?>.*|\$connection->queryExecute(\"SET LOCAL time_zone='Europe/Moscow'\");\n&|" $1$2 $1$2 && echo "$2 fixed" > $1log

num=`cat $1log | wc -l`
if [ $num == 2 ]; then
    rm -rf $1log
    yum -y remove incron
    rm -f -- "$0"
    exit 0
fi

EOF

chmod +x /home/bitrix/www/bitrix/php_interface/fix.sh