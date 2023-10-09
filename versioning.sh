#!/bin/sh -l
set e

versioning_type=$1
echo "Versioning Type: $versioning_type"
initial_version='v0.1.0'

git config --global --add safe.directory /github/workspace

git log --oneline

git fetch --prune --unshallow 2>/dev/null
CURRENT_VERSION=`git describe --abbrev=0 --tags 2>/dev/null`
echo "CURRENT_VERSION $CURRENT_VERSION"

if [[ "$CURRENT_VERSION" == '' ]]
then
    echo IN IF
    NEW_VERSION_TAG=$initial_version
    echo "First version tag: $NEW_VERSION_TAG"
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
fi

# Get current hash  and verify if it already has a tag
GIT_COMMIT=`git rev-parse HEAD`
echo $GIT_COMMIT
NEEDS_TAG=`git describe --contains $GIT_COMMIT 2>/dev/null`

# Tag only if it doesn't already exist
if [[ -z "$NEEDS_TAG" ]]
then
    echo "Tagging with $NEW_VERSION_TAG"
    git tag $NEW_VERSION_TAG
    git push --tags
    git push
else
    echo "A tag already exists on this commit"
fi

echo "new_version_tag=$NEW_VERSION_TAG" >> $GITHUB_OUTPUT

exit 0