server {
    listen 80;
    listen [::]:80;

    server_name allinonehabits.com www.allinonehabits.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    server_name allinonehabits.com www.allinonehabits.com;

    root /usr/share/nginx/html;
    index index.html index.htm;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    location / {
        try_files $uri $uri/ =404;
    }

    ssl_certificate /etc/letsencrypt/live/allinonehabits.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/allinonehabits.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}
