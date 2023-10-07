#!/bin/sh -l
versioning_type='patch'
versioning_type=$1
echo "Versioning Type: $versioning_type"
initial_version='v0.1.0'

git log --oneline

git fetch --prune --unshallow 2>/dev/null
CURRENT_VERSION=`git describe --abbrev=0 --tags 2>/dev/null`
echo 'CURRENT_VERSION $CURRENT_VERSION'
CURRENT_VERSION='v1.0.3'

echo $CURRENT_VERSION
if [[ "$CURRENT_VERSION" == '' ]]
then
    echo IN IF
    CURRENT_VERSION=$initial_version
    echo "new_version_tag=$CURRENT_VERSION" >> $GITHUB_OUTPUT
else
    # If exists, extract `v` example `v0.1.0` becomes in `0.1.0`
    NUMBERS_TAG=$(echo ${CURRENT_VERSION} | tr 'v' '\n')
    echo $NUMBERS_TAG
    # Destructure the tag for appy Semantic Versioning
    major_number=$(echo $NUMBERS_TAG | awk -F '.' '{ print $1 }')
    minor_number=$(echo $NUMBERS_TAG | awk -F '.' '{ print $2 }')
    patch_number=$(echo $NUMBERS_TAG | awk -F '.' '{ print $3 }')
    
    if [[ "$versioning_type" == 'patch' ]]
    then
        patch_number=$(($patch_number + 1))
    elif [[ "$versioning_type" == 'minor' ]]
    then
        minor_number=$(($minor_number + 1))
    elif [[ "$versioning_type" == 'major' ]]
    then
        major_number=$(($major_number + 1))
    else
        echo "No version type SEMVER"
        exit 1
    fi
    NEW_VERSION_TAG="$major_number.$minor_number.$patch_number"
    echo $NEW_VERSION_TAG
    echo "new_version_tag=$NEW_VERSION_TAG" >> $GITHUB_OUTPUT
fi