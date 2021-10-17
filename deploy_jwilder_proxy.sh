#!/bin/bash
docker run -d -p 80:80 -p 443:443 -v /opt/etc/docker_nginx_webproxy/httpd/network_internal.conf:/etc/nginx/network_internal.conf -v /opt/etc/docker_nginx_webproxy/html:/usr/share/nginx/html -v /opt/etc/docker_nginx_webproxy/vhost.d:/etc/nginx/vhost.d -v /opt/etc/docker_nginx_webproxy/proxy-conf/my-proxy.conf:/etc/nginx/conf.d/my_proxy.conf:ro -v /var/run/docker.sock:/tmp/docker.sock:ro -v /opt/etc/docker_nginx_webproxy/ssl/ssl/nginx:/etc/nginx/certs --name jwilder_nginx_proxy jwilder/nginx-proxy
