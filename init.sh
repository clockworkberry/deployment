#!/bin/bash

#requirements: php, git, curl, php5-intl, mysql-server, php5-mysql

SCRIPTS_DIR=`dirname $0`
SCRIPT_CONFIG="$SCRIPTS_DIR/config.sh"
. $SCRIPT_CONFIG

SCRIPT_LOCAL_CONFIG="$SCRIPTS_DIR/config-local.sh"
. $SCRIPT_LOCAL_CONFIG

function installComposer() {
	message "Install composer"
	pushd $COMPOSER_DIR
	$CURL --retry 5 -sS https://getcomposer.org/installer | $PHP
	popd
}

function cloneRepository() {
	#clone repository
	message "Clone repository"
	GIT_SSH="$SCRIPTS_DIR/ssh-git.sh" PKEY="$GIT_KEY" git clone -b develop ssh://git@prj.oysterlabs.com/o-labs/oy-x5/oy-x5-dm/oy-x5-data-mining.git $APP_FE_DIR 
}

function installRequirements() {
	message "Install project requirements via composer"
	pushd $APP_FE_DIR
	$COMPOSER config github-oauth.github.com $GITHUB_API_KEY
	$COMPOSER update < /dev/null
	popd
	php $APP_FE_DIR/vendor/sensio/distribution-bundle/Sensio/Bundle/DistributionBundle/Resources/bin/build_bootstrap.php
}

function setProjectPermissions() {
	#set permissions
	message "Set permissions"
	pushd $APP_FE_DIR
	chmod a+w -R $APP_FE_DIR/app/cache
	chmod a+w -R $APP_FE_DIR/app/logs
	popd
}

function configureDefaultDb {
        message "Configure default db"
        $SED \
                -e "s/database_driver:.*/database_driver: pdo_mysql/" \
                -e "s/database_host:.*/database_host: $MYSQL_HOST/" \
                -e "s/database_port:.*/database_port: $MYSQL_PORT/" \
                -e "s/database_name:.*/database_name: $MYSQL_DBNAME/" \
                -e "s/database_user:.*/database_user: $MYSQL_USER/" \
                -e "s/database_password:.*/database_password: $MYSQL_PASSWORD/" \
                $APP_FE_DIR/app/config/parameters.yml > $APP_FE_DIR/app/config/parameters.yml.tmp
        mv      $APP_FE_DIR/app/config/parameters.yml.tmp $APP_FE_DIR/app/config/parameters.yml
}

function configureResultsDb() {
	message "Configure results db"
        $SED \
                -e "s/database_driver_results:.*/database_driver_results: pdo_mysql/" \
                -e "s/database_host_results:.*/database_host_results: $MYSQL_HOST_RESULTS/" \
                -e "s/database_port_results:.*/database_port_results: $MYSQL_PORT_RESULTS/" \
                -e "s/database_name_results:.*/database_name_results: $MYSQL_DBNAME_RESULTS/" \
                -e "s/database_user_results:.*/database_user_results: $MYSQL_USER_RESULTS/" \
                -e "s/database_password_results:.*/database_password_results: $MYSQL_PASSWORD_RESULTS/" \
                $APP_FE_DIR/app/config/parameters.yml > $APP_FE_DIR/app/config/parameters.yml.tmp
        mv      $APP_FE_DIR/app/config/parameters.yml.tmp $APP_FE_DIR/app/config/parameters.yml
}

function initialSetupProject() {
	message "Initial setup for project"
	pushd $APP_FE_DIR
	app/console doctrine:database:create
	app/console doctrine:database:create --connection=results
	app/console doctrine:schema:update --force
	app/console doctrine:schema:update --force --em="results"
	app/console doctrine:migrations:migrate --no-interaction
	app/console assets:install
	app/console assetic:dump
	app/console fos:user:create "$ADMINUSER_NAME" "$ADMINUSER_EMAIL" "$ADMINUSER_PASSWORD"
	app/console fos:user:promote "$ADMINUSER_NAME" "ROLE_ADMIN"
	popd
}

configSSH
installComposer
cloneRepository
installRequirements
setProjectPermissions
configureDefaultDb
configureResultsDb
initialSetupProject
exit
