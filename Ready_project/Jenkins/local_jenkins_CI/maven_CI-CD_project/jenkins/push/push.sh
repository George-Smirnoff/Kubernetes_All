#!/bin/bash

echo '************************'
echo '*** Push Docker Image***'
echo '************************'

IMAGE="maven-project"

echo "*** Login in ***"
docker login -u $REGISTRY_USER -p $REGISTRY_PASS
echo "*** Pushing image ***"
docker push $REGISTRY_DNS/$IMAGE_NAME:$BUILD_TAG
