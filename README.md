# Oracle WebLogic 14c Domain configuration Docker Overview

Create an Oracle WebLogic 14c Domain configuration in a Docker image.

Build the wls14c image first using the wls14c docker file

## Building

    docker build --rm=true  --tag=some/tag/wls14cdomain -f wls14cdomain.dockerfile .

## Running

    docker run -d --init --restart unless-stopped --name WLS14c some/tag/wls14cdomain

## Connecting

In order to connect to your running container, simply execute the following command:

    docker exec -it WLS14c /bin/bash


[back](./README.md) 
