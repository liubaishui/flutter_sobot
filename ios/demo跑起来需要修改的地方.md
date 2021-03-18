需要修改的地方

// 1. 本地flutter 仓库路径
FLUTTER_ROOT=/Users/wanglei/Desktop/USTH/Fluter 调研/flutter
// 2.当前仓库路径或demo跟路径
FLUTTER_APPLICATION_PATH=/Users/wanglei/Desktop/智齿科技/Pod/flutter_sobot
// 指定的那个dart 去启动
FLUTTER_TARGET=lib/main.dart
FLUTTER_BUILD_DIR=build
SYMROOT=${SOURCE_ROOT}/../build/ios
OTHER_LDFLAGS=$(inherited) -framework Flutter
// 3. 前半部分为本地flutter 仓库路径
FLUTTER_FRAMEWORK_DIR=/Users/wanglei/Desktop/USTH/Fluter 调研/flutter/bin/cache/artifacts/engine/ios
FLUTTER_BUILD_NAME=1.0.0
FLUTTER_BUILD_NUMBER=1
DART_OBFUSCATION=false
TRACK_WIDGET_CREATION=false
TREE_SHAKE_ICONS=false
PACKAGE_CONFIG=.packages
