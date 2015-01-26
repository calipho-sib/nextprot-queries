#!/bin/bash

if [ -z "$1" ] 
    then 
        echo "Specify release version as first argument"
    exit 0
fi

if [ -z "$2" ]
    then
        echo "Specify development version as second argument"
        exit 0
fi


RELEASEVERSION=${1}
DEVELOPMENTVERSION=${2}-SNAPSHOT

echo "Releasing with version: $RELEASEVERSION"

git merge develop master
git checkout master
mvn versions:set -DnewVersion=$RELEASEVERSION
git add .
git commit -m "poms for release version $RELEASEVERSION"
git push origin master
git tag -a v$RELEASEVERSION -m "tag v$RELEASEVERSION"
git push --tags
mvn clean deploy
# change to develop 
git checkout develop
mvn versions:set -DnewVersion=$DEVELOPMENTVERSION
git add pom.xml
git commit -m "poms for development version $DEVELOPMENTVERSION"
git push origin develop





