#!/bin/bash
git pull

docker stop fnagentcontainer
docker rm fnagentcontainer

docker build -t fnagentimage .
docker run -d -p 8080:8080 --name fnagentcontainer --restart always fnagentimage