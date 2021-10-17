#!/bin/bash
docker run -it --name docker_mysql --restart=always --cap-add=SYS_NICE --mount type=bind,src=/opt/etc/docker_mysql/my.cnf,dst=/etc/my.cnf -v /opt/data/docker_mysql80:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=enter-your-password-here -d mysql:8.0
