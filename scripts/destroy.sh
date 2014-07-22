#!/bin/bash

SCRIPTS_DIR=`dirname $0`
SCRIPT_CONFIG="$SCRIPTS_DIR/config.sh"
. $SCRIPT_CONFIG

SCRIPT_LOCAL_CONFIG="$SCRIPTS_DIR/config-local.sh"
. $SCRIPT_LOCAL_CONFIG

MYSQL_TABLES=`mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DBNAME" -e 'show tables' -B --raw -s`

for TABLE in $MYSQL_TABLES;  do 
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DBNAME" -e "SET FOREIGN_KEY_CHECKS=0;drop table $TABLE"
done

#drop mysql database
#MYSQL_DB=`mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e 'drop database "$MYSQL_DBNAME"' -B --raw -s"

#remove repository
rm -rf "$APP_FE_DIR"

#remove composer
rm -f ~/composer.phar
rm -rf ~/.composer

# make temporary dir and move all project content to tmp
mkdir $TMP_DIR
mv  $TMP_DIR
