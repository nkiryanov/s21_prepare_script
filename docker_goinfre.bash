#!/bin/bash

# Move network docker folder to local
mkdir -p ~/goinfre/Docker/Data
rm -rf ~/Library/Containers/com.docker.docker
ln -s ~/goinfre/Docker ~/Library/Containers/com.docker.docker
