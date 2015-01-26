#!/bin/bash

# start debug mode
set -x

stopDebugModeAndExit () {
  set +x; git checkout develop ; exit $1
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

# change to branch develop
git checkout develop || stopDebugModeAndExit 1
git merge develop master || stopDebugModeAndExit 2

# change to branch master
git checkout master || stopDebugModeAndExit 3
# set new version in pom.xml
mvn versions:set -DnewVersion=$RELEASEVERSION || stopDebugModeAndExit 4
git add .
git commit -m "Release version $RELEASEVERSION" || stopDebugModeAndExit 5
git push origin master || stopDebugModeAndExit 6
# tag
git tag -a v$RELEASEVERSION -m "tag v$RELEASEVERSION" || stopDebugModeAndExit 7
git push --tags || stopDebugModeAndExit 8
# deploy on nexus
mvn clean deploy || stopDebugModeAndExit 9

# change to branch develop
git checkout develop || stopDebugModeAndExit 10
mvn versions:set -DnewVersion=$DEVELOPMENTVERSION || stopDebugModeAndExit 11
git add pom.xml || stopDebugModeAndExit 12
git commit -m "Setting new snapshot version $DEVELOPMENTVERSION" || stopDebugModeAndExit 13
git push origin develop || stopDebugModeAndExit 14

stopDebugModeAndExit 0



