#!/bin/bash

echo '***********************'
echo '*** Build Maven *******'
echo '***********************'

docker run -w /app --rm -v $PWD/java_app:/app -v $PWD/root/.m2/:/root/.m2/ maven:3-alpine $@
