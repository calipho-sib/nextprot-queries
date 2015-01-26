#!/bin/bash

# start debug mode
set -x

stopDebugModeAndExit () {
  set +x; exit $1
}

if [ -z "$1" ]; then
    echo "Specify release version as first argument"
    stopDebugModeAndExit 0
fi

if [ -z "$2" ]; then
    echo "Specify development version as second argument"
    stopDebugModeAndExit 0
fi

RELEASEVERSION=${1}
DEVELOPMENTVERSION=${2}-SNAPSHOT

# change to branch master
git checkout master || stopDebugModeAndExit 1
git merge develop || stopDebugModeAndExit 2

# set new version in pom.xml
mvn versions:set -DnewVersion=$RELEASEVERSION || stopDebugModeAndExit 3
git add pom.xml
git commit -m "New release version $RELEASEVERSION" || stopDebugModeAndExit 4
git push origin master || stopDebugModeAndExit 5
# tag
git tag -a v$RELEASEVERSION -m "tag v$RELEASEVERSION" || stopDebugModeAndExit 6
git push --tags || stopDebugModeAndExit 7
# deploy on nexus
mvn clean deploy || stopDebugModeAndExit 8

# change to branch develop
git checkout develop || stopDebugModeAndExit 9
mvn versions:set -DnewVersion=$DEVELOPMENTVERSION || stopDebugModeAndExit 10
git add pom.xml || stopDebugModeAndExit 11
git commit -m "New snapshot version $DEVELOPMENTVERSION" || stopDebugModeAndExit 12
git push origin develop || stopDebugModeAndExit 13

stopDebugModeAndExit 0



