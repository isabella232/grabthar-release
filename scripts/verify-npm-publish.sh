#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Invalid arguments. Expected <version> and <dist-tag>."
    exit 1;
fi

local_version=$1
dist_tag=$2

package_name=$(node --eval "
    const PACKAGE = './package.json';
    let pkg = require(PACKAGE);
    console.log(pkg.name);
")

echo "package name: $package_name"
echo "dist tag: $dist_tag"
echo "local version: $local_version"

interval=5
max_time=300
counter=0

sleep $interval;

npm_public_registry_version=$(npm view "$package_name" "dist-tags.$dist_tag");
echo "npm version: $npm_public_registry_version"

while [ "$local_version" != "$npm_public_registry_version" ]
do
    if [ "$counter" == "$max_time" ]; then
      echo "Failed to verify version in $max_time seconds."
      exit 1;
    fi
    echo "Version mismatch between local version $local_version and npm version $npm_public_registry_version. Trying again in $interval seconds..."
    sleep $interval;
    npm_public_registry_version=$(npm view "$package_name" version "$dist_tag");
    counter=$(( counter + interval ));
done

echo "Successful version match."
