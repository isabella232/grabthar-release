#!/bin/bash

set -e;

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
$DIR/grabthar-validate-git;

if [ -z "$1" ]; then
    echo 'Must specify module to add';
    exit 1;
else
    $DIR/grathar-upgrade "$1";
fi;
