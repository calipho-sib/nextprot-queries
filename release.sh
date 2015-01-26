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

git merge develop master || exit 1


# change to branch master
git checkout master || exit 2
# set new version in pom.xml
mvn versions:set -DnewVersion=$RELEASEVERSION || exit 3
git add .
git commit -m "Release version $RELEASEVERSION" || exit 4
git push origin master || exit 5
# tag
git tag -a v$RELEASEVERSION -m "tag v$RELEASEVERSION" || exit 5
git push --tags || exit 6
# deploy on nexus
mvn clean deploy || exit 7

# change to branch develop
git checkout develop || exit 8
mvn versions:set -DnewVersion=$DEVELOPMENTVERSION || exit 9
git add pom.xml || exit 10
git commit -m "Setting new snapshot version $DEVELOPMENTVERSION" || exit 11
git push origin develop || exit 12





