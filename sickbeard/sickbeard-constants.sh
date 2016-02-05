#!/bin/bash
APPNAME='sickbeard'
APPSHORTNAME='sb'
APPPATH='/home/'$UNAME'/.sickbeard'
APPTITLE='SickBeard'
APPDEPS='git-core python python-cheetah python-pyasn1'
APPGIT='https://github.com/midgetspy/Sick-Beard.git'
APPDPORT='8081'
APPSETTINGS=$APPPATH'/config.ini'
PORTSEARCH='web_port = '
USERSEARCH='web_username = '
PASSSEARCH='web_password = '
# New password encrypted
NEWPASS='atomic'
# New password unencrypted
APPNEWPASS='atomic'