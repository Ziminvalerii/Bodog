#!/bin/bash

set -eo pipefail

    if [ -e "./$NAME.xcworkspace" ]
then
    xcodebuild archive -workspace "$NAME".xcworkspace -scheme "$NAME" -destination 'generic/platform=iOS' -archivePath build/"$NAME".xcarchive
else
    xcodebuild archive -project "$NAME".xcodeproj -scheme "$NAME" -destination 'generic/platform=iOS' -archivePath build/"$NAME".xcarchive
fi
