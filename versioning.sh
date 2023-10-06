#!/bin/sh -l

echo "Versioning Type: $1"

version='v0.5.0'

echo "new_version=$version" >> $GITHUB_OUTPUT