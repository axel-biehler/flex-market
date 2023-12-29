#!/bin/bash

# Get the latest Git tag (e.g., v0.0.1)
TAG=$(git describe --tags --abbrev=0)

# Remove the 'v' from the beginning of the tag (e.g., v0.0.1 -> 0.0.1)
VERSION=${TAG:1}

# Update the pubspec.yaml with the new version
sed -i "" "s/version: .*/version: $VERSION+1/g" pubspec.yaml
