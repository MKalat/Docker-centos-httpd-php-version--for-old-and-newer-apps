#!/bin/bash

docker run -d  -e WORDPRESS_DB_HOST=docker_mysql -e VIRTUAL_HOST=enter-your-domain-here -e WORDPRESS_TABLE_PREFIX=enter-table-prefix-here -e WORDPRESS_DB_USER=enter-db-user-here -e WORDPRESS_DB_PASSWORD=enter-password-here -e WORDPRESS_DB_NAME=enter-db-name-here --mount type=bind,src=/opt/www/enter-domain-here/web,dst=/var/www/html --mount type=bind,src=/opt/www/web/tweaks/tweaks.ini,dst=/usr/local/etc/php/conf.d/tweaks.ini --expose 80 --name web_wp_page_1 wordpress
