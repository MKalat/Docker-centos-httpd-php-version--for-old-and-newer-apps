#!/bin/bash
DOMAIN=$1
REPOSITORY=$2


cd /opt/www/$DOMAIN/web
rm -fr ./.git
git init
git remote add origin $REPOSITORY
git fetch
git reset --hard origin/prod
chmod -R 0777 /opt/www/$DOMAIN/web


