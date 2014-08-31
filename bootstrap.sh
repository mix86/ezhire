#!/usr/bin/env bash

RAILS_ENV=production
APP_DIR=/home/core/ezhire
DATA_DIR=$APP_DIR/data

MONGO=ez-mongo0
APP=ez-app0
NGINX=ez-ngx0

# Setup mongo
docker pull mongo:latest
docker run -v $DATA_DIR:/data/db \
           --name $MONGO \
           -d mongo

# Setup rails app
docker pull mixael/ruby:latest
docker run -v $APP_DIR:$APP_DIR \
           --link $MONGO:mongo \
           --name $APP \
           --env RAILS_ENV=$RAILS_ENV \
           --entrypoint 'bin/run' \
           --workdir $APP_DIR/current \
           -d mixael/ruby

# Setup nginx
docker pull dockerfile/nginx:latest
docker run -p 80:80 \
           -v $APP_DIR/current/config/nginx:/etc/nginx/sites-enabled:ro \
           -v $APP_DIR/shared/log/nginx:/var/log/nginx \
           -v $APP_DIR:$APP_DIR:ro \
           --link $APP:app \
           --name $NGINX \
           -d dockerfile/nginx
