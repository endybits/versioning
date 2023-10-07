#!/bin/sh -l

versioning_type=$1
echo "Versioning Type: $versioning_type"
initial_version='v0.1.0'

git log --oneline

git fetch --prune --unshallow 2>/dev/null
CURRENT_VERSION=`git describe --abbrev=0 --tags 2>/dev/null`
echo 'CURRENT_VERSION $CURRENT_VERSION'
CURRENT_VERSION=$initial_version
if [[ $CURRENT_VERSION != '']]; then
    CURRENT_VERSION=$initial_version
    echo "new_version_tag=$CURRENT_VERSION" >> $GITHUB_OUTPUT
else
    CURRENT_VERSION_SEGMENTS = $(${CURRENT_VERSION//./ })
    major_current_number = $CURRENT_VERSION_SEGMENTS[0]
    minor_current_number = $CURRENT_VERSION_SEGMENTS[1]
    patch_current_number = $CURRENT_VERSION_SEGMENTS[2]
    if [[ versioning_type == 'patch']]; then
        patch_current_number=$(( patch_current_number+1 ))
    elif [[ versioning_type == 'minor']]; then
        minor_current_number=$(( minor_current_number+1 ))
    elif [[ versioning_type == 'major']]; then
        major_current_number=$(( major_current_number+1 ))
    else
        echo "No version type SEMVER"
        exit 1
    fi
    NEW_VERSION_TAG="$major_current_number.$minor_current_number.$patch_current_number"
    echo "new_version_tag=$NEW_VERSION_TAG" >> $GITHUB_OUTPUT
fi