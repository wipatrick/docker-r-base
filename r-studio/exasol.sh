#!/bin/bash

## Modifying entries in .odbc.ini
sed -i -e "s/%exa-host-ip%/$EXAHOST/g" /.odbc.ini
sed -i -e "s/%exa-uid%/$EXAUSER/g" /.odbc.ini
sed -i -e "s/%exa-pwd%/$EXAPASSWORD/g" /.odbc.ini

## Copying .odbc.ini in user home folder
cp  /.odbc.ini /home/$USER/.odbc.ini
chown $USER /home/$USER/.odbc.ini
