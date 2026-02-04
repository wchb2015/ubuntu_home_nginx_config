server {
    listen 80;
    listen [::]:80;

    server_name allinonehabits.com www.allinonehabits.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name allinonehabits.com www.allinonehabits.com;

    root /usr/share/nginx/html;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    ssl_certificate /etc/letsencrypt/live/allinonehabits.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/allinonehabits.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}
