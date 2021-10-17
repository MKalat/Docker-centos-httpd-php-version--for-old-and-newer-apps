#!/bin/bash

HOSTING=$1
DOMAIN=$2


cp -R /opt/log/docker_centos_httpd_skeleton /opt/log/docker_centos_httpd_php74_$HOSTING
cp -R /opt/etc/docker_centos_httpd_skeleton /opt/etc/docker_centos_httpd_php74_$HOSTING
echo "docker run -itd -e VIRTUAL_HOST=${DOMAIN},${HOSTING}.enter-your-domain-here --mount type=bind,src=/opt/www/$DOMAIN,dst=/domains/$DOMAIN --mount type=bind,src=/opt/etc/docker_centos_httpd_php74_$HOSTING/httpd,dst=/etc/nginx --mount type=bind,src=/opt/etc/docker_centos_httpd_php74_$HOSTING/ssl/ssl,dst=/etc/ssl --mount type=bind,src=/opt/etc/docker_centos_httpd_php74_$HOSTING/ssl/pki,dst=/etc/pki --mount type=bind,src=/opt/log/docker_centos_httpd_php74_$HOSTING/log,dst=/var/log  --mount type=bind,src=/opt/etc/docker_centos_httpd_php74_$HOSTING/supervisor/supervisord.conf,dst=/etc/supervisord.conf --mount type=bind,src=/opt/etc/docker_centos_httpd_php74_$HOSTING/supervisor/php-fpm.conf,dst=/etc/php-fpm.conf --mount type=bind,src=/opt/etc/docker_centos_httpd_php74_$HOSTING/supervisor/php-fpm.d,dst=/etc/php-fpm.d  --expose 80  --hostname docker_centos_httpd_php74_$HOSTING --name docker_centos_httpd_php74_$HOSTING  mkpl/docker_centos_httpd_php74 /usr/bin/supervisord -n" > /opt/deploy_centos_httpd_php74_${HOSTING}_docker.sh
chmod +x /opt/deploy_centos_httpd_php74_${HOSTING}_docker.sh
echo "
user              nginx;
worker_processes  4;

error_log  /var/log/nginx/${DOMAIN}-vhost-error.log;

pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    client_max_body_size 50M;
    server_names_hash_max_size 4112;
    server_tokens off;
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] \"\$request\" '
                      '\$status \$body_bytes_sent \"\$http_referer\" '
                      '\"\$http_user_agent\" \"\$http_x_forwarded_for\"';

    ## Detect when HTTPS is used
#    map \$scheme \$https {
#      default off;
#      https on;
#    }
    access_log  /var/log/nginx/$HOSTING-vhost-access.log  main;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  60;

    #gzip  on;

    # Load config files from the /etc/nginx/conf.d directory
    # The default server is in conf.d/default.conf
    include /etc/nginx/conf.d/*.conf;

## Start: Size Limits & Buffer Overflows ##
    client_body_buffer_size  1K;
    client_header_buffer_size 1k;
    # bylo 2 1K
    large_client_header_buffers 4 8k;
## END: Size Limits & Buffer Overflows ##


}

" > /opt/etc/docker_centos_httpd_php74_$HOSTING/httpd/nginx.conf

echo "
server {
        listen *:80;


        server_name localhost;

        root   /domains/$DOMAIN/web;



        index index.html index.htm index.php index.cgi index.pl index.xhtml;



        error_log /var/log/error.log;
        access_log /var/log/access.log combined;

        
 	location / {
                # This is cool because no php is touched for static content.
                # include the "?$args" part so non-default permalinks doesn't break when using query string
                try_files \$uri \$uri/ /index.php?q=$uri$args; #q= for wordpress and joomla param= or the like for cms simple
        }

        location ~ \.php$ {
                include /etc/nginx/fastcgi_params;
                fastcgi_intercept_errors on;
                fastcgi_pass unix:/run/php-fpm/www.sock;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;

        }



        location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                expires max;
                log_not_found off;
        }
        
}

" > /opt/etc/docker_centos_httpd_php74_$HOSTING/httpd/sites-enabled/$DOMAIN.vhost


echo "
# web service1 config.
server {
listen 80;
listen 443 ssl http2;
server_name $HOSTING.enter-your-domain-here $DOMAIN;

# Path for SSL config/key/certificate
ssl_certificate /etc/ssl/nginx/${DOMAIN}pem;
ssl_certificate_key /etc/ssl/nginx/${DOMAIN}.key;

location / {
include /etc/nginx/includes/proxy.conf;
proxy_pass http://docker_centos_httpd_php74_$HOSTING:8082/;
}

access_log off;
error_log  /var/log/nginx/web_proxy-$HOSTING-error.log error;
}

" > /opt/etc/docker_nginx_webproxy/httpd/sites-enabled/$DOMAIN.vhost

echo "

docker network connect mynetwork docker_centos_httpd_php74_$HOSTING

" >> /opt/deploy_docker_network.sh

