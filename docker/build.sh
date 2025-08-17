#!/bin/bash


DOCKER_USERNAME="theekeeper"
APP_NAME="actividad3-app"
REDIS_NAME="actividad3-redis"
VERSION="1.0"


docker build -f docker/Dockerfile.app -t $DOCKER_USERNAME/$APP_NAME:$VERSION .
docker tag $DOCKER_USERNAME/$APP_NAME:$VERSION $DOCKER_USERNAME/$APP_NAME:latest



docker build -f docker/Dockerfile.redis -t $DOCKER_USERNAME/$REDIS_NAME:$VERSION .
docker tag $DOCKER_USERNAME/$REDIS_NAME:$VERSION $DOCKER_USERNAME/$REDIS_NAME:latest


echo "docker login"
echo "docker push $DOCKER_USERNAME/$APP_NAME:$VERSION"
echo "docker push $DOCKER_USERNAME/$APP_NAME:latest"
echo "docker push $DOCKER_USERNAME/$REDIS_NAME:$VERSION"
echo "docker push $DOCKER_USERNAME/$REDIS_NAME:latest" 