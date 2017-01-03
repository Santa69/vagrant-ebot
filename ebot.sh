#!/bin/bash
sudo -i
clear
echo -e "\n--- Ubuntu/trusty64 Update ---\n"
apt-get update > /dev/null 2>&1
echo -e "\n[OK]\n"


echo -e "\n--- Install Packages ---\n"
apt-get install apache2 gcc make libxml2-dev autoconf ca-certificates unzip nodejs curl libcurl4-openssl-dev pkg-config libssl-dev screen -y 2>>/transport/log/apache2_install_error.log > /dev/null >&1
echo -e "\n[OK]\n"


echo -e "\n--- Install & Configure Php ---\n"
cd /home/install
echo -e "\n1/2[OK]\n"
wget http://be2.php.net/get/php-5.6.27.tar.bz2/from/this/mirror -O php-5.6.27.tar.bz2 > /dev/null 2>&1
tar -xjvf php-5.6.27.tar.bz2 > /dev/null 2>&1
cd php-5.6.27
apt-get install re2c > /dev/null 2>&1
echo -e "\n2/2[OK]\n"
./configure --prefix /usr/local --with-mysql --enable-maintainer-zts --enable-sockets --with-openssl --with-pdo-mysql 2>>/transport/log/configure1_error.log > /dev/null >&1


echo -e "\n--- May take some time ---\n"
#printf '\033[5m'; echo -e "\n--- May take some time ---\n" ; printf '\033[0m'
make -j 4 2>>/transport/log/make1_error.log > /dev/null >&1
echo -e "\nMake[OK]\n"
make install 2>>/transport/log/makeinstall1_error.log > /dev/null >&1
echo -e "\nMake Install[OK]\n"


echo -e "\n--- ''Make Install Phtreads'' ---\n"
cd /home/install
wget http://pecl.php.net/get/pthreads-2.0.10.tgz > /dev/null 2>&1
echo -e "\n1/3[OK]\n"
tar -xvzf pthreads-2.0.10.tgz > /dev/null 2>&1
cd pthreads-2.0.10
echo -e "\n2/3[OK]\n"
/usr/local/bin/phpize
echo -e "\n3/3[OK]\n"
./configure 2>>/transport/log/configure2_error.log > /dev/null >&1
echo -e "\n4/6[OK]\n"
make -j 4 2>>/transport/log/make2_error.log > /dev/null >&1
echo -e "\n5/6[OK]\n"
make install 2>>/transport/log/makeinstall2_error.log > /dev/null >&1
echo -e "\n6/6[OK]\n"



echo 'date.timezone = Europe/Paris' >> /usr/local/lib/php.ini
echo 'extension=pthreads.so' >> /usr/local/lib/php.ini


echo -e "\n--- Install libapache2-mod-php5 ---\n"
apt-get install libapache2-mod-php5 -y > /dev/null 2>&1


 echo -e "\n--- Install MySql & PhpMyAdmin ---\n"
 #variables
 passSql=$( cat /transport/passSql | xargs)

 dbname=$( cat /transport/dbname | xargs)
 dbuser=$( cat /transport/dbuser | xargs)
 dbpass=$( cat /transport/dbpass | xargs)

 modeebot=$( cat /transport/modeebot | xargs)

# IP VM
 ipServ=$(/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

 export DEBIAN_FRONTEND=noninteractive

 debconf-set-selections <<< "mysql-server mysql-server/root_password password $passSql"
 debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $passSql"
 debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $passSql"
 debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $passSql"
 debconf-set-selections <<< "mysql-server-5.6 mysql-server/root_password password $passSql"
 debconf-set-selections <<< "mysql-server-5.6 mysql-server/root_password_again password $passSql"
 debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
 debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $passSql"
 debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $passSql"
 debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $passSql"
 debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"
echo -e "\nDEBCONF[OK]\n"

apt-get -y install mysql-server php5-mysql phpmyadmin 2>>/transport/log/install_mysql_error.log > /dev/null >&1
echo -e "\n--- Install MySQL & PhpMyAdmin [OK] ---\n"

#Ecriture du fichier apache2.conf
echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf
service apache2 restart > /dev/null 2>&1

# Configuration de la base de données mysql
## mysql -u $sqlLogin -p$sqlPass -e "create database $dbName DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"

echo -e "\n--- Setting up our MySQL user and db ---\n"

mysql -uroot -p$passSql -e "CREATE DATABASE $dbname"
mysql -uroot -p$passSql -e "create user '$dbuser'@'localhost' IDENTIFIED by '$dbpass'"
mysql -uroot -p$passSql -e "grant all privileges on $dbname.* to '$dbuser'@'localhost' with grant option;"


echo -e "\n--- Install eBot-CSGO ---\n"
mkdir /home/ebot
cd /home/ebot
wget https://github.com/deStrO/eBot-CSGO/archive/master.zip > /dev/null 2>&1
unzip master.zip > /dev/null 2>&1
mv eBot-CSGO-master ebot-csgo
cd ebot-csgo

echo -e "\n--- Install & Configure nodjs ---\n"
curl --silent --location https://deb.nodesource.com/setup_0.12 | bash -  2>>/transport/log/curl_node_error.log > /dev/null >&1
echo -e "\nDownload[OK]\n"
apt-get update > /dev/null 2>&1
echo -e "\nupdate[OK]\n"
apt-get install -y nodejs > /dev/null 2>&1
echo -e "\nInstall[OK]\n"
npm install socket.io@0.9.12 archiver formidable 2>>/transport/log/npm_socket_error.log > /dev/null >&1
echo -e "\nConfigure[OK]\n"

echo -e "\n--- Install & Configure nodjs ---\n"
curl -sS https://getcomposer.org/installer | php5 2>>/transport/log/curl_etcomposer_error.log > /dev/null >&1
echo -e "\nDownload[OK]\n"
php composer.phar install 2>>/transport/log/php_composer_error.log > /dev/null >&1
echo -e "\nInstall[OK]\n"

echo -e "\n--- Generate Config.ini ---\n"
cp config/config.ini.smp config/config.ini
# Generate config.ini (need SQL DATABASE HERE $SQLPASSWORDEBOTV3)
echo '; eBot - A bot for match management for CS:GO
; @license     http://creativecommons.org/licenses/by/3.0/ Creative Commons 3.0
; @author      Julien Pardons <julien.pardons@esport-tools.net>
; @version     3.0
; @date        21/10/2012
[BDD]
MYSQL_IP = "127.0.0.1"
MYSQL_PORT = "3306"
MYSQL_USER = "'$dbuser'"
MYSQL_PASS = "'$dbpass'"
MYSQL_BASE = "'$dbname'"
[Config]
BOT_IP = "'$ipServ'"
BOT_PORT = 12360
EXTERNAL_LOG_IP = "" ; use this in case your server isnt binded with the external IP (behind a NAT)
MANAGE_PLAYER = 1
DELAY_BUSY_SERVER = 120
NB_MAX_MATCHS = 0
PAUSE_METHOD = "nextRound" ; nextRound or instantConfirm or instantNoConfirm
NODE_STARTUP_METHOD = "node" ; binary file name or none in case you are starting it with forever or manually
[Match]
LO3_METHOD = "restart" ; restart or csay or esl
KO3_METHOD = "restart" ; restart or csay or esl
DEMO_DOWNLOAD = true ; true or false :: whether gotv demos will be downloaded from the gameserver after matchend or not
REMIND_RECORD = false ; true will print the 3x "Remember to record your own POV demos if needed!" messages, false will not
DAMAGE_REPORT = true; true will print damage reports at end of round to players, false will not
[MAPS]
MAP[] = "de_cache"
MAP[] = "de_season"
MAP[] = "de_dust2"
MAP[] = "de_nuke"
MAP[] = "de_inferno"
MAP[] = "de_train"
MAP[] = "de_mirage"
MAP[] = "de_cbble"
MAP[] = "de_overpass"
[WORKSHOP IDs]
[Settings]
COMMAND_STOP_DISABLED = false
RECORD_METHOD = "matchstart" ; matchstart or knifestart
DELAY_READY = true' > /home/ebot/ebot-csgo/config/config.ini
echo -e "\n--- Generate Config.ini END ---\n"

echo -e "\n--- Install eBot-Web ---\n"
cd /home/ebot
rm -R master*
echo -e "\nPrepare eBot-Web[OK]\n"
wget https://github.com/deStrO/eBot-CSGO-Web/archive/master.zip > /dev/null 2>&1
unzip master.zip > /dev/null 2>&1
echo -e "\nDownload eBot-Web[OK]\n"
mv eBot-CSGO-Web-master ebot-web
cd ebot-web
cp config/app_user.yml.default config/app_user.yml
echo -e "\nConfigure eBot-Web[OK]\n"



#replace ebot_ip: 192.168.1.1 by ebot_ip: $ipServ
sed -i -e "s/ebot\_ip\: 192\.168\.1\.1/ebot\_ip\: "$ipServ"/g" config/app_user.yml
# replace mode: net by mode: $modeebot
sed -i -e "s/\mode\: net/\mode\: $modeebot/g" config/app_user.yml
# replace dbname=ebotv3 by dbname=$dbname
sed -i -e "s/dbname\=ebotv3/dbname\=$dbname/g" config/databases.yml

# replace username: by username: $dbuser
sed -i -e "s/username\: root/username\: $dbuser/g" config/databases.yml
# replace password: by password: $dbpass
sed -i -e "s/password\:/password\: $dbpass/g" config/databases.yml
# replace #RewriteBase / by RewriteBase /
sed -i -e "s/#RewriteBase \//RewriteBase \//g" /home/ebot/ebot-web/web/.htaccess


mkdir cache
 chown -R www-data *
 chmod -R 777 cache
echo -e "\n--- Install & Configure Symfony ---\n"
php5 symfony cc 2>>/transport/log/symfonycc_error.log > /dev/null >&1
echo -e "\n--- Configure Symfony Doctrine ---\n"
php5 symfony doctrine:build --all --no-confirmation 2>>/transport/log/doctrine_error.log > /dev/null >&1
echo -e "\n--- Configure Symfony Guard ---\n"
php5 symfony guard:create-user --is-super-admin admin@ebot admin admin 2>>/transport/log/doctrine_guard_error.log > /dev/null >&1

echo -e "\n--- VHOST ---\n"
cp /transport/ebotv3.conf /etc/apache2/sites-available/
echo -e "\n1/4[OK]\n"
a2enmod rewrite > /dev/null 2>&1
echo -e "\n2/4[OK]\n"
a2ensite ebotv3.conf > /dev/null 2>&1
echo -e "\n3/4[OK]\n"
service apache2 reload > /dev/null 2>&1
echo -e "\n4/4[OK]\n"

# Delete installation
cd /home/ebot/ebot-web/web/
rm -rf installation

# petit +++
cd /home/install
wget https://raw.githubusercontent.com/vince52/eBot-initscript/master/ebotv3 > /dev/null 2>&1
mv ebotv3 /etc/init.d/ebot
chmod +x /etc/init.d/ebot
#---   service ebot stop
service ebot start
service ebot status
cd /home/ebot/ebot-csgo
php bootstrap.php

# service ebot clear-cache
#---  service ebot restart
