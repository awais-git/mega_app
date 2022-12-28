#!/bin/bash 
PATH_PROJECT=$(pwd)

URL=https://pedidos.megadelivery.online
./changeEnv.sh $URL
date

# # build apk
flutter clean
flutter pub get
flutter build appbundle --target-platform android-arm,android-arm64,android-x64

# move file app-release.apk to root folder
cp "$PATH_PROJECT/build/app/outputs/bundle/release/app-release.aab" "$PATH_PROJECT/mega-delivery.aab"
date