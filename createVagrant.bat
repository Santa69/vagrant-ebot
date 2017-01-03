
echo off
cls
SET /p folderVm= Choose Your Name Folder For Virtual Machine :
mkdir %folderVm%
cd %folderVm%
mkdir data
mkdir transport
cd transport
mkdir log
cd..

SET /p passSql= Choose Your Password SQL :
ECHO %passSql% >> "transport\passSql"
ECHO ''
pause

SET /p dbname= Choose your Database Name PhpMyAdmin :
ECHO %dbname% >> "transport\dbname"
ECHO ''
pause

SET /p dbuser= Choose your User PhpMyAdmin :
ECHO %dbuser% >> "transport\dbuser"
ECHO ''
pause

SET /p dbpass= Choose your pass PhpMyAdmin :
ECHO %dbpass% >> "transport\dbpass"
ECHO ''
pause

SET /p modeebot= Choose your mode eBot lan or net :
ECHO %modeebot% >> "transport\modeebot"
ECHO ''
pause


vagrant init
cd..
COPY Vagrantfile %folderVm%
COPY ebotv3.conf %folderVm%\transport\
cd %folderVm%
vagrant up
vagrant ssh
