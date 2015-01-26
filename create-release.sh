#!/bin/bash

# debug mode
set -x

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

debugOffAndExit () {

  set +x; exit $1
}

RELEASEVERSION=${1}
DEVELOPMENTVERSION=${2}-SNAPSHOT

git merge develop master || debugOffAndExit 1


# change to branch master
git checkout master || debugOffAndExit 2
# set new version in pom.xml
mvn versions:set -DnewVersion=$RELEASEVERSION || debugOffAndExit 3
git add .
git commit -m "Release version $RELEASEVERSION" || debugOffAndExit 4
git push origin master || exit 5
# tag
git tag -a v$RELEASEVERSION -m "tag v$RELEASEVERSION" || debugOffAndExit 5
git push --tags || debugOffAndExit 6
# deploy on nexus
mvn clean deploy || debugOffAndExit 7

# change to branch develop
git checkout develop || debugOffAndExit 8
mvn versions:set -DnewVersion=$DEVELOPMENTVERSION || debugOffAndExit 9
git add pom.xml ||  set +x  ; exit 10
git commit -m "Setting new snapshot version $DEVELOPMENTVERSION" || debugOffAndExit 11
git push origin develop || debugOffAndExit 12

# stop debug mode
debugOffAndExit 0