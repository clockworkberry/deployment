#!/bin/bash

CURL=`which curl`
PHP=`which php`
SED=`which sed`
TOP_DIR=`readlink -f ~`
TMP_DIR="/tmp/"

COMPOSER_DIR="$TOP_DIR"
COMPOSER="$PHP $COMPOSER_DIR/composer.phar"

APPS_DIR="$TOP_DIR"
APP_FE_DIR="$APPS_DIR/frontend"
GITHUB_API_KEY='317713e5774380fee090fe26621bd1b85cfc453c'
CONFIGS_DIR="$SCRIPTS_DIR/../configs"
GIT_KEY=`readlink -f "$CONFIGS_DIR/x5.rsa"`

MYSQL_HOST="localhost"
MYSQL_PORT="null"
MYSQL_USER="x5-an-fe-in1.oys"
MYSQL_PASSWORD="Rs7LKEshjbzCMpx"
MYSQL_DBNAME="x5_an_fe_in1_oysterlabs_com"

MYSQL_HOST_RESULTS="localhost"
MYSQL_PORT_RESULTS="null"
MYSQL_USER_RESULTS="x5-an-fe-in1.oys"
MYSQL_PASSWORD_RESULTS="Rs7LKEshjbzCMpx"
MYSQL_DBNAME_RESULTS="x5_an_fe_in1_oysterlabs_com"

ADMINUSER_NAME="John Scott"
ADMINUSER_EMAIL="email@example.com"
ADMINUSER_PASSWORD="password"

COLOR_RED='\e[0;31m'
COLOR_GREEN="\e[0;31m"
COLOR_NONE="\e[0m"
MYECHO="`which echo`"
function message() {
  $MYECHO -e "$COLOR_GREEN$1$COLOR_NONE"
}

