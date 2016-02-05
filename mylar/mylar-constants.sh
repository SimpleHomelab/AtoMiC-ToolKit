#!/bin/bash
APPNAME='mylar'
APPSHORTNAME='mylar'
APPPATH='/home/'$UNAME'/.mylar'
APPTITLE='Mylar'
APPDEPS='git-core python python-cheetah python-pyasn1'
APPGIT='https://github.com/evilhero/mylar.git'
APPDPORT='8090'
APPSETTINGS=$APPPATH'/config.ini'
PORTSEARCH='http_port = '
USERSEARCH='http_username = '
PASSSEARCH='http_password = '
# New password encrypted
NEWPASS='atomic'
# New password unencrypted
APPNEWPASS='atomic'