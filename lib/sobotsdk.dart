import 'dart:async';
import 'package:flutter/services.dart';

class SobotApi {
  String startZhichiMethod = 'ZCSobot_Plugin_Start_SDK';
  String openSobotHelpCenterMethod = 'ZCSobot_Plugin_Open_Help_Center';
  String openSobotHelpMallCenterMethod = 'ZCSobot_Plugin_Open_Help_Mall_Center';
  String closeSobotChatMethod = 'ZCSobot_Plugin_Close_Sobot_Chat';
  String getUnReadMessageMethod = 'ZCSobot_Plugin_Get_Unread_Message';

  //交互的通道名称，flutter和native是通过这个标识符进行相互间的通信
  static const sobotMethodChannel = MethodChannel('flutter_sobot');

  //await会阻塞流程，等待紧跟着的的Future执行完毕之后，再执行下一条语句

  //异步执行调用原生方法，保持页面不卡住，因为调用原生的方法可能没实现会抛出异常，所以trycatch包住
  Future<dynamic> startZhichi(initParams) async {
    try {
      final result =
      sobotMethodChannel.invokeMethod(startZhichiMethod, initParams);
      return result;
    } on PlatformException catch (e) {
      //抛出异常
      print(e);
      return {};
    }
  }

  Future<dynamic> openSobotHelpCenter(initParams) async {
    try {
      final result = sobotMethodChannel.invokeMethod(
          openSobotHelpCenterMethod, initParams);
      return result;
    } on PlatformException catch (e) {
      //抛出异常
      print(e);
      return {};
    }
  }

  Future<dynamic> openSobotHelpMallCenter(initParams) async {
    try {
      final result = sobotMethodChannel.invokeMethod(
          openSobotHelpMallCenterMethod, initParams);
      return result;
    } on PlatformException catch (e) {
      //抛出异常
      print(e);
      return {};
    }
  }

  Future<dynamic> getUnReadMessage(partnerid) async {
    try {
      /*
          结果 type: 4 未读消息
          value: 未读消息数量
          desc: 文本获取未读消息数
          */
      final result =
      sobotMethodChannel.invokeMethod(getUnReadMessageMethod, partnerid);
      return result;
    } on PlatformException catch (e) {
      //抛出异常
      print(e);
      return {};
    }
  }

  Future<dynamic> closeSobotChat() async {
    try {
      final result = sobotMethodChannel.invokeMethod(closeSobotChatMethod);
      return result;
    } on PlatformException catch (e) {
      print(e);
      //抛出异常
      return {};
    }
  }
}
