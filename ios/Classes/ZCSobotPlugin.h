//
//  ZCSobotPlugin.h
//  Runner
//
//  Created by 王磊 on 2021/1/21.
//

#import <Flutter/Flutter.h>
// @import UIKit;
// @import Flutter;

NS_ASSUME_NONNULL_BEGIN
/*
 环境监测
 */
//String startZhichiMethod = 'ZCSobot_Plugin_Start_SDK';
//  String openSobotHelpCenterMethod = 'ZCSobot_Plugin_Open_Help_Center';
//  String closeSobotChatMethod = 'ZCSobot_Plugin_Close_Sobot_Chat';
//  String getUnReadMessageMethod = 'ZCSobot_Plugin_Get_Unread_Message';

#define ZC_SOBOT_ENV_CHECK @"ZCSobot_Plugin_Env_Check"
// 频道名称
#define ZC_SOBOT_PLUGIN_CHANNEL @"flutter_sobot"

// 频道名称
#define ZC_SOBOT_PLUGIN_EVENT_CHANNEL @"sobot"
// 启动聊天
#define ZC_SOBOT_START_SDK_METHOD @"ZCSobot_Plugin_Start_SDK"
/*
 打开普通版中心
 */
#define ZC_SOBOT_OPEN_HELP_CENTER_METHOD @"ZCSobot_Plugin_Open_Help_Center"
/*
 // 启动消息中心，电商使用
 */
#define ZC_SOBOT_OPEN_HELP_MALL_CENTER_METHOD @"ZCSobot_Plugin_Open_Help_Mall_Center"
// 离线用户
#define ZC_SOBOT_CLOSE_CHAT_METHOD @"ZCSobot_Plugin_Close_Sobot_Chat"
// 获取未读消息数
#define ZC_SOBOT_GET_UNREAD_MESSAGE_METHOD @"ZCSobot_Plugin_Get_Unread_Message"
// 发送位置消息
#define ZC_SOBOT_SEND_LOCATION_METHOD @"ZCSobot_Plugin_Send_Location"


typedef NS_ENUM(NSInteger,ZCPageListener) {
    ZCPageGoBack         = 1,
    ZCPageLinkClick      = 2,
    ZCPageNewMessage     = 3, // 未读消息数 或离线消息
    ZCPageGetUnRead      = 4,
    ZCPageSendLocation   = 5,
};

@interface ZCSobotPlugin : FlutterAppDelegate <FlutterPlugin ,FlutterStreamHandler>

@end

NS_ASSUME_NONNULL_END
