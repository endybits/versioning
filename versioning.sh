#!/bin/sh -l

echo "Versioning Type: $1"
default_version='v0.1.0'

git logs --oneline

git fetch --prune --unshalow 2>/dev/null
CURRENT_VERSION=`git describe --abbrev=0 --tags 2>/dev/null`
echo 'CURRENT_VERSION $CURRENT_VERSION'
if [[ $CURRENT_VERSION == '']]; then
    CURRENT_VERSION=$default_version
fi
echo "new_version=$CURRENT_VERSION" >> $GITHUB_OUTPUT