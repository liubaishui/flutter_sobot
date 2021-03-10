# Flutter 发布文档 
发布之后 程序员就可以通过flutter 插件平台拉取代码
一定要提前把所有谷歌账号退出，保证没有谷歌账号登陆，然后在发布时 会提示登陆谷歌账号，这时使用发布账号发布

[1.登陆pub.dev](#flutter1)

[2.iOS设置](#flutter2)

[3.pubspec.yaml 设置](#flutter3)

[4.发布插件](#flutter4)

[5.注意事项](#flutter5)
## <a name="flutter1"> 1.登陆pub.dev </a>

一定要使用 https://pub.dev/flutter/packages 使用这个域名才登陆成功
千万不要使用 https://pub.flutter-io.cn/ 使用这个域名点击登陆没有反应
软件翻墙不好使，除非路由器翻墙

## <a name="flutter2"> 2.iOS设置 - 本地依赖 </a>

[podspec 配置文件]
(https://code.zhichidata.com/flutter_sobotsdk/flutter_sobot/blob/master/ios/flutter_sobot.podspec)

```
【podspec编辑 注意podspec文件一定要与仓库名称相同 
如果不相同 之后可能需要手动更改项目pod配置】
```


## <a name="flutter3"> 3.pubspec.yaml 设置 </a>

[podspec 配置文件]
(https://code.zhichidata.com/flutter_sobotsdk/flutter_sobot/blob/master/pubspec.yaml)


## <a name="flutter4"> 4.发布插件 </a>

终端进入到差点跟目录下 执行如下命令
这个命令是检查能够上传flutter插件平台的 也就是缺啥补啥

```
dart pub publish --dry-run
```

这期间可能会提示你缺少某些文件如license和changelog 根据提示添加
就行

发布命令如下 加上sudo的原因是发布的时候需要读写文件

```
sudo flutter packages pub publish 
```

发布成功如下提示 这时就可以去插件平台管理了
```

```

## <a name="flutter4"> 5.注意事项 </a>

1.翻墙软件可能不大好使 最好是硬件翻墙 从路由器着手

2.发布的时候需要耐心 大概率超时

