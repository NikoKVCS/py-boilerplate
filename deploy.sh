#!/bin/bash

# 定义项目名
PROJECT_NAME="py_boilerplate"

git pull

docker stop ${PROJECT_NAME}_container
docker rm ${PROJECT_NAME}_container

docker build -t ${PROJECT_NAME}_image .
docker run -d -p 8000:8000 --name ${PROJECT_NAME}_container --restart always ${PROJECT_NAME}_image