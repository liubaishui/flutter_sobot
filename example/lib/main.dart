import 'package:flutter/material.dart';

import 'package:flutter_sobot/sobotsdk.dart';

// import 'package';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:async';

class ZCSobotWidge extends StatefulWidget {
  @override
  ZCSobotWidgeState createState() => ZCSobotWidgeState();
}

class ZCSobotWidgeState extends State<ZCSobotWidge> {
  String newmesaage = "";
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
              MaterialButton(
                color: Colors.blue,
                child: Text(newmesaage),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startZhichi() async {
    var params = {
      'app_key': '3869eb0f3d8d4ccaa563c88781391a1c',
      'api_host': '',
      'partnerid': '123456789',
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
      'app_key': '3869eb0f3d8d4ccaa563c88781391a1c',
      'api_host': '',
      'partnerid': '123456789',
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
      'orderCode': 'v2131232132',
      'autoSendOrderMessage': true,
      'goodsCount': 2,
      'totalFee': 3034,
      'createTime': '1569491413000',
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
    final result = zhiChiSobot.openSobotHelpCenter(params);
    // result.then((value) => Map<String,Object>);
    handleJson(result);
  }

  Future<void> openSobotHelpMallCenter() async {
    var params = {
      'app_key': '3869eb0f3d8d4ccaa563c88781391a1c',
      'api_host': '',
      'partnerid': '123456789',
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
      'isDebugMode': 1,
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
      'orderCode': 'v2131232132',
      'autoSendOrderMessage': true,
      'goodsCount': 2,
      'totalFee': 3034,
      'createTime': '1569491413000',
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
    final result = zhiChiSobot.openSobotHelpMallCenter(params);

    handleJson(result);
  }

  Future<void> closeSobotChat() async {
    await zhiChiSobot.closeSobotChat();
  }

  Future<void> handleJson(json) async {
    if (json['type'] == '5') {
    } else if (json['type'] == '1') {
      // 点击返回按钮回掉

    } else if (json['type'] == '4') {
      // 未读消息回掉
      final unreadNumber = json['value'];
      print(unreadNumber);
    }
    print(json);
    // textShow.set
    // data = json['type'];
    // TextSpan(text: json['type']);
    // newmesaage = json['type'];
    // Text(newmesaage);
    setState(() {
      newmesaage = json['type'];
    });
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
