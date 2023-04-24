#!/bin/bash

set -eo pipefail

    if [ -e "$NAME.xcworkspace" ]
then
    xcodebuild -workspace "$NAME".xcworkspace -scheme "$NAME" -resolvePackageDependencies
else
    xcodebuild -project "$NAME".xcodeproj -scheme "$NAME" -resolvePackageDependencies
fi
