#!/bin/bash
clear
echo ' '
echo -e '  ──────▄▀▀▀▀▀▀▀▄───────
  ─────▐─▄█▀▀▀█▄─▌──────
  ─────▐─▀█▄▄▄█▀─▌──────
  ──────▀▄▄▄▄▄▄▄▀───────
  ─────▐▀▄▄▐█▌▄▄▀▌──────
  ──────▀▄▄███▄▄▀───────
  █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
  █░░╦─╦╔╗╦─╔╗╔╗╔╦╗╔╗░░█
  █░░║║║╠─║─║─║║║║║╠─░░█
  █░░╚╩╝╚╝╚╝╚╝╚╝╩─╩╚╝░░█
  █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█
'

echo ' '
echo ' '
echo 'How will we name the directory we create the VM into? (leave empty for newVagrant)'
read dirName
if [ -z "$dirName" ]; then
    dirName='newVagrant'
fi
mkdir $dirName
cp Vagrantfile $dirName
cd $dirName
mkdir data
mkdir ebot
mkdir transport
cd transport
mkdir log
cd ..
cd ..
#test does dirName already exists?
#if yes: ask confirm? overwrite by default? Check for allready up VMs?

echo ''
echo "Type in your MySQL-server password. (leave empty for 0000)"
read sqlPass
if [ -z "$sqlPass" ]; then
  sqlPass='0000'
fi
echo $sqlPass >> $dirName/transport/passSql

echo ''
echo "Database name. (leave empty for ebotv3)"
read dbname
if [ -z "$dbname" ]; then
  dbname='ebotv3'
fi
echo $dbname >> $dirName/transport/dbname


echo ''
echo "Database User. (leave empty for ebotv3)"
read dbuser
if [ -z "$dbuser" ]; then
  dbuser='ebotv3'
fi
echo $dbuser >> $dirName/transport/dbuser

echo ''
echo "Database Password. (leave empty for ebotv3)"
read dbPass
if [ -z "$dbPass" ]; then
  dbPass='ebotv3'
fi
echo $dbPass >> $dirName/transport/dbpass

echo ''
echo "Choose Your Mode. (leave empty for lan)"
read dbMode
if [ -z "$dbMode" ]; then
  dbMode='lan'
fi
echo $dbMode >> $dirName/transport/modeebot

cp ebotv3.conf $dirName/transport/

cd $dirName

vagrant up
vagrant ssh
