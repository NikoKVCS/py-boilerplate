#!/bin/bash
git pull

docker stop fnagentcontainer
docker rm fnagentcontainer

docker build -t fnagentimage .
docker run -d -p 8000:8000 --name fnagentcontainer --restart always fnagentimage