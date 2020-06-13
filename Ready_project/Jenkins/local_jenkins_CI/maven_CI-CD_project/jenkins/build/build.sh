#!/bin/bash

#Copy the new jar to the build folder
cp java_app/target/*.jar jenkins/build/docker

echo '************************'
echo '*** Build Docker Image**'
echo '************************'
cd jenkins/build/docker && docker-compose -f docker-compose-build.yml build
