mkdir -p shopware

cd shopware

cat << EOF > docker-compose.yaml
services:
    shopware:
      # use either tag "latest" or any other version like "6.5.3.0", ...
      image: dockware/play:latest
      #image: dockware/dev:6.5.0.0-rc4

      container_name: shopware
      ports:
         - "8080:80"
         - "3306:3306"
         - "8022:22"
         - "8888:8888"
         - "9999:9999"
      volumes:
         - "db_volume:/var/lib/mysql"
         - "shop_volume:/var/www/html"
      environment:
         - APP_URL=${APP_URL}
         - APP_ENV=${APP_ENV}
         - SHOP_DOMAIN=${SHOP_DOMAIN}
         - SHOPWARE_HTTP_CACHE_ENABLED:=0
         #- APP_URL_CHECK_DISABLED=0
         # default = 0, recommended to be OFF for frontend devs
         - XDEBUG_ENABLED=0
         # default = latest PHP, optional = specific version
         #- PHP_VERSION=8.1

volumes:
  db_volume:
    driver: local
  shop_volume:
    driver: local
EOF

docker compose up -d
docker compose exec -it shopware bash -c "php bin/console sales-channel:update:domain localhost:8080"
