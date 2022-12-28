#!/bin/bash 
PATH_PROJECT=$(pwd)

# build apk
fvm use 1.22.3
fvm flutter clean
fvm flutter pub get
fvm flutter build apk --release

# move file app-release.apk to root folder
cp "$PATH_PROJECT/build/app/outputs/apk/release/app-release.apk" "$PATH_PROJECT/mega-delivery.apk"
