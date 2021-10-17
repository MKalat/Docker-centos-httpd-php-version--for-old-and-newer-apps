#!/bin/bash
docker run --name docker_phpmyadmin -itd -e PMA_HOST=docker_mysql -e UPLOAD_LIMIT=9072 -e VIRTUAL_HOST=pma.enter-your-domain-here  -e NETWORK_ACCESS=internal --expose 80 phpmyadmin
docker network connect mynetwork docker_phpmyadmin
