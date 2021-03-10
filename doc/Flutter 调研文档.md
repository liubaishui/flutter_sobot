## Flutter 调研文档
[1.依赖环境](#flutter1)

[2.Flutter介绍](#flutter2)

[3.Flutter安装以及需要的插件](#flutter3)

[4.第一个demo Helloword](#flutter4)


## <a name="flutter1"> 1.依赖环境 </a>
MacOS10.15   
Flutter v1.16.3

## <a name="flutter2"> 2.Flutter介绍 - 跨平台</a>
Flutter是谷歌的移动UI框架，可以快速在iOS和Android上构建高质量的原生用户界面。 Flutter可以与现有的代码一起工作。在全世界，Flutter正在被越来越多的开发者和组织使用，并且Flutter是完全免费、开源的。
【注：跨平台、免费、开源】

## <a name="flutter3"> 3.Flutter安装以及需要的插件 </a>

1.[安装XCode - iOS 必选](https://apps.apple.com/cn/app/xcode/id497799835?mt=12)
  
2.[安装VSCode - 2选1](https://code.visualstudio.com/)

3.[安装Android Studio - 2选1](http://www.android-studio.org/)

4.[Flutter 下载 -必须]

终端执行

```
git clone https://github.com/flutter/flutter.git
```
或

```
git clone https://gitee.com/ThreeStoneWang/flutter.git

```

5.其他插件-usb、手机连接的


```
brew install --HEAD usbmuxd
brew link usbmuxd
brew install --HEAD libimobiledevice
```

由于我这边是iOS 开发 所以需要执行以下命令 关联cocoapods 

```
brew install ideviceinstaller ios-deploy cocoapods
pod setup

```


6.编辑bash_profile文件-配置flutter环境变量-必须

在bash_profile中添加

```
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
# 此为flutter仓库本地路径
export PATH="$PATH:$HOME/Desktop/USTH/Fluter 调研/flutter/bin"
export PATH="/usr/local/sbin:$PATH"
```

保存好文件，然后终端执行如下命令

```
source ~/.bash_profile
echo $PATH
```

7.通过flutter doctor 检查依赖环境以及插件是否安装完成

![Image text]
(https://code.zhichidata.com/flutter_sobotsdk/flutter_sobot/raw/master/storage/flutterdoctor/flutter2.png)

如果显示如上图 就可以创建自己的第一个helloword 项目了

## <a name="flutter4"> 4.第一个demo Helloword</a>
1启动 VS Code

2调用 View>Command Palette…

3输入 ‘flutter’, 然后选择 ‘Flutter: New Project’ action

4输入 Project 名称 (如myapp), 然后按回车键

5指定放置项目的位置，然后按蓝色的确定按钮

6等待项目创建继续，并显示main.dart文件

7替换 lib/main.dart.

删除lib / main.dart中的所有代码，然后替换为下面的代码，它将在屏幕的中心显示“Hello World”.

```
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Center(
          child: new Text('Hello World'),
        ),
      ),
    );
  }
}
```

8 运行应用程序 

![image text](https://code.zhichidata.com/flutter_sobotsdk/flutter_sobot/raw/master/storage/sources/flutter1.png)
