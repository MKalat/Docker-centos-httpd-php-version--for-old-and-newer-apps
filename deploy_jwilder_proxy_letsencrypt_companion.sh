docker run --detach \
    --name nginx-proxy-letsencrypt \
    --volumes-from jwilder_nginx_proxy \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume /etc/acme.sh \
    --env "DEFAULT_EMAIL=enter-your-email-here" \
    jrcs/letsencrypt-nginx-proxy-companion
