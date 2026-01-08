#!/bin/bash

# 定义项目名
PROJECT_NAME="boilerplate"

git pull

docker stop ${PROJECT_NAME}_container
docker rm ${PROJECT_NAME}_container

docker build --build-arg ENVIRONMENT=production -t ${PROJECT_NAME}_image .
docker run -d -p 8000:8000 --name ${PROJECT_NAME}_container --restart always -e ENVIRONMENT=production ${PROJECT_NAME}_image
