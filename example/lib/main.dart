import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

import "package:flutter_sobot/sobotsdk.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ZCSobotWidge(),
    );
  }
}

class ZCSobotWidge extends StatefulWidget {
  @override
  ZCSobotWidgeState createState() => ZCSobotWidgeState();
}

class ZCSobotWidgeState extends State<ZCSobotWidge> {
  final zhiChiSobot = SobotApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('text'),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              MaterialButton(
                color: Colors.blue,
                child: Text('启动智齿'),
                onPressed: () {
                  startZhichi();
                },
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text('启动客户服务中心'),
                onPressed: () {
                  openSobotHelpCenter();
                },
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text('获取未读消息数'),
                onPressed: () {
                  getUnReadMessage();
                },
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text('关闭智齿'),
                onPressed: () {
                  closeSobotChat();
                },
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text('电商版消息中心'),
                onPressed: () {
                  openSobotHelpMallCenter();
                },
              ),
              //新消息来了
              MaterialButton(
                color: Colors.green,
                child: Text(msg),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startZhichi() async {
    var params = {
      'app_key': '1c1da2c0aad047d7ba1d14ecd18ae4f6',
      'partnerid': '123456789',
      'isCustomLinkClick': true,
      'user_nick': 'sobot123123123',
      'user_name': '智齿jkhkjhk',
      'user_tels': '18510002000',
      'user_emails': '123@qq.com',
      'qq': '123456789',
      'remark': '好好学习，天天向上',
      'params': {
        'actionType': 'to_group',
        'optionId': '4',
        'deciId': 'a457f4dfe92842f8a11d1616c1c58dc1'
      },
      'service_mode': 0,
      'title_type': 1,
      'custom_title': '自定义标题',
      'is_show_custom_title': true,
      'is_show_custom_title_url': true,
      'showNotification': true,
      'isShowReturnTips': true,
      'isShowClose': true,
      'isShowCloseSatisfaction': true,
      'isCloseAfterEvaluation': true,
      'isOpenEvaluation': true,
      'goodsTitle': '商品名字',
      'goodsLabel': '30.5\$',
      'goodsDesc': '商品描述',
      'goodsImage':
      'https://img.sobot.com/chatres/75574e5fa29a48458d1f57ab5489a4c5/msg/20200612/75574e5fa29a48458d1f57ab5489a4c5123456789/aae707c620744e92bb112de8b67cd3ed.png',
      'goodsLink': 'https://home.firefoxchina.cn/',
      'isSendInfoCard': true,
      'orderStatus': 1,
      'orderUrl': 'https://www.baidu.com',
      'orderCode': 'v2131232132',
      'autoSendOrderMessage': true,
      'goodsCount': 2,
      'totalFee': 3034,
      'createTime': '1569491413000',
      'canSendLocation': true,
      'goods': [
        {
          'name': '商品名称',
          'pictureUrl':
          'https://img.sobot.com/chatres/75574e5fa29a48458d1f57ab5489a4c5/msg/20200612/75574e5fa29a48458d1f57ab5489a4c5123456789/aae707c620744e92bb112de8b67cd3ed.png'
        },
        {
          'name': '商品名称',
          'pictureUrl':
          'https://img.sobot.com/chatres/75574e5fa29a48458d1f57ab5489a4c5/msg/20200612/75574e5fa29a48458d1f57ab5489a4c5123456789/aae707c620744e92bb112de8b67cd3ed.png'
        }
      ]
    };
    final result = await zhiChiSobot.startZhichi(params);
    handleJson(result);
  }

  Future<void> openSobotHelpCenter() async {
    var params = {
      'app_key': '1c1da2c0aad047d7ba1d14ecd18ae4f6',
      'partnerid': '123456789',
    };
    final result = await zhiChiSobot.openSobotHelpCenter(params);
    handleJson(result);
  }

  Future<void> openSobotHelpMallCenter() async {
    var params = {'partnerid': '123456789'};
    final result = await zhiChiSobot.openSobotHelpMallCenter(params);

    handleJson(result);
  }

  Future getUnReadMessage() async {
    var params = {'partnerid': '123456789'};
    var result = await zhiChiSobot.getUnReadMessage(params);
    handleJson(result);
  }

  Future<void> closeSobotChat() async {
    final result = await zhiChiSobot.closeSobotChat();
    handleJson(result);
  }

  Future<void> handleJson(json) async {
    print(json);
  }

  //事件监听
  // 新消息（不在聊天页，会话没结束，同时app没被杀死时才能监听到新消息）
  //超链接点击事件的拦截返回超链接url，可以自己处理
  static const EventChannel eventChannel = EventChannel('sobot');
  String msg = '';

  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(Object event) {
    print(event.toString());
    setState(() {
      msg = event.toString();
    });
  }

  void _onError(Object error) {
    print(error);
  }
}
