//
//  ZCSobotPlugin.m
//  Runner
//
//  Created by 王磊 on 2021/1/21.
//

#import "ZCSobotPlugin.h"


#pragma mark ---- 判断是否包含智齿SDK
#if __has_include(<SobotKit/SobotKit.h>)
#define ZC_SOBOT_SUPPORTED 1
#else
#define ZC_SOBOT_SUPPORTED 0

#endif

#if ZC_SOBOT_SUPPORTED
@import SobotKit;
#endif

#pragma mark ---- 项目创建时是OC的AppDelegate还是Swift的Delegate
#if __has_include("AppDelegate.h")
#define ZC_SOBOT_APPDELEGATE_OBJECTIVE_C_FILE 1
#elif __has_include("Runner-Swift.h")
#define ZC_SOBOT_APPDELEGATE_SWIFT_FILE 1
#endif

#if ZC_SOBOT_APPDELEGATE_OBJECTIVE_C_FILE
#import "AppDelegate.h"
#endif

#if ZC_SOBOT_APPDELEGATE_SWIFT_FILE
#import "Runner-Swift.h"
#endif


@interface ZCSobotPlugin()

@property (nonatomic ,strong) NSMutableDictionary *locationInfo;

@property (nonatomic, strong) FlutterEventSink eventSink;

@end

@implementation ZCSobotPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:ZC_SOBOT_PLUGIN_CHANNEL binaryMessenger:[registrar messenger]];
    ZCSobotPlugin *instance = [[ZCSobotPlugin alloc]init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:ZC_SOBOT_PLUGIN_EVENT_CHANNEL binaryMessenger:[registrar messenger]];
    
    [eventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:ZC_SOBOT_START_SDK_METHOD]) {
        if (call.arguments && [call.arguments isKindOfClass:[NSDictionary class]]) {
            [self startZhiChi:call.arguments result:result];
            return;
        }
    } else if ([call.method isEqualToString:ZC_SOBOT_OPEN_HELP_CENTER_METHOD]) {
        if (call.arguments && [call.arguments isKindOfClass:[NSDictionary class]]) {
            [self openSobotHelpCenter:call.arguments result:result];
            return;
        }
    } else if ([call.method isEqualToString:ZC_SOBOT_CLOSE_CHAT_METHOD]) {
        if (call.arguments && [call.arguments isKindOfClass:[NSDictionary class]]) {
            [self closeSobotChat:call.arguments];
            return;
        }
    } else if ([call.method isEqualToString:ZC_SOBOT_GET_UNREAD_MESSAGE_METHOD]) {
        if (call.arguments && [call.arguments isKindOfClass:[NSDictionary class]]) {
            [self getUnReadMessage:call.arguments result:result];
            return;
        }
    } else if ([call.method isEqualToString:ZC_SOBOT_OPEN_HELP_MALL_CENTER_METHOD]) {
        if (call.arguments && [call.arguments isKindOfClass:[NSDictionary class]]) {
            [self openSobotHelpMallCenter:call.arguments result:result];
            return;
        }
    } else if ([call.method isEqualToString:ZC_SOBOT_SEND_LOCATION_METHOD]) {
        if (call.arguments && [call.arguments isKindOfClass:[NSDictionary class]]) {
            [self sendLocation:call.arguments];
            return;
        }
    }
    
    result(FlutterMethodNotImplemented);
}

- (void)startZhiChi:(NSDictionary *)argus result:(FlutterResult)result {
#if ZC_SOBOT_SUPPORTED
    
    NSString *api_host = [self convertString:[argus objectForKey:@"api_host"]];
    NSString * app_key = [self convertString:[argus objectForKey:@"app_key"]];
    NSString *partnerid = [self convertString:[argus objectForKey:@"partnerid"]];
    [ZCSobotApi initSobotSDK:app_key host:api_host result:^(id  _Nonnull object) {
        
        ZCLibInitInfo *info = [self setZCLibInfoValue:argus];
        
        [ZCLibClient getZCLibClient].libInitInfo = info;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        UIViewController *from = window.rootViewController;
        
        ZCKitInfo *kitInfo = [self setKitInfoValue:argus];
        
        [ZCSobotApi openZCChat:kitInfo with:from pageBlock:^(id  _Nonnull object, ZCPageBlockType type) {
            
            if(type==ZCPageBlockLoadFinish){
                [ZCSobotApi clearUnReadNumber:info.partnerid];
            }
            // 点击返回事件回调
            if(type==ZCPageBlockGoBack){
                NSDictionary *ret = @{@"type":[self convertIntToString:ZCPageGoBack],@"value":@"",@"desc":@"执行返回操作"};
                if(result){
                    result(ret);
                }
            }
        }];
        
        [self messageLinkClick:result];
        
        [self onReceiveMessage];
    }];
#endif
}

- (void)openSobotHelpCenter:(NSDictionary *)argus result:(FlutterResult)result {
#if ZC_SOBOT_SUPPORTED
    
    NSString *api_host = [self convertString:[argus objectForKey:@"api_host"]];
    NSString * app_key = [self convertString:[argus objectForKey:@"app_key"]];
    NSString *partnerid = [self convertString:[argus objectForKey:@"partnerid"]];
    [ZCSobotApi initSobotSDK:app_key host:api_host result:^(id  _Nonnull object) {
        
        ZCLibInitInfo *info = [self setZCLibInfoValue:argus];
        
        [ZCLibClient getZCLibClient].libInitInfo = info;
        
        ZCKitInfo *kitInfo = [self setKitInfoValue:argus];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            
            UIViewController *from = window.rootViewController;
            
            [ZCSobot openZCServiceCentreVC:kitInfo with:from onItemClick:nil];
        });
        //        [ZCSobotApi ]
        
        //        [ZCSobotApi getLastLeaveReplyMessage:partnerid resultBlock:^(NSDictionary * _Nonnull dict, NSMutableArray * _Nonnull arr, int code) {
        
        //        }];
    }];
    [self messageLinkClick:result];
    
    [self onReceiveMessage];
    //    receivedBlock
#endif
}

- (void)openSobotHelpMallCenter:(NSDictionary *)argus result:(FlutterResult)result {
#if ZC_SOBOT_SUPPORTED
    NSString *api_host = [self convertString:[argus objectForKey:@"api_host"]];
    NSString * app_key = [self convertString:[argus objectForKey:@"app_key"]];
    
    NSString *partnerid = [self convertString:[argus objectForKey:@"partnerid"]];
    
    [ZCSobotApi initSobotSDK:app_key host:api_host result:^(id  _Nonnull object) {
        
        ZCLibInitInfo *info = [self setZCLibInfoValue:argus];
        
        [ZCLibClient getZCLibClient].libInitInfo = info;
        
        ZCKitInfo *kitInfo = [self setKitInfoValue:argus];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            
            UIViewController *from = window.rootViewController;
            
            [ZCSobot startZCChatListView:kitInfo with:from onItemClick:nil];
        });
        
        [self messageLinkClick:result];
        
        [self onReceiveMessage];
    }];
#endif
}
- (void)messageLinkClick:(FlutterResult)result {
#if ZC_SOBOT_SUPPORTED
    [ZCSobotApi setMessageLinkClick:^BOOL(NSString * _Nonnull link) {
        
        if ([link containsString:@"sobot://sendOrderMsg"]) {
            [ZCSobotApi sendOrderGoodsInfo:[ZCUICore getUICore].kitInfo.orderGoodsInfo resultBlock:^(NSString * _Nonnull msg, int code) {
                
            }];
            return YES;
        }
        if ([link containsString:@"sobot://sendlocation"]) {
            // 发送位置信息
            NSDictionary *res = @{@"type": [self convertIntToString:ZCPageSendLocation] ,@"value": @"",@"desc":@"发送位置"};
            result(res);
            return YES;
        }
        
        if([link containsString:@"sobot://sendProductInfo"]){
            [ZCSobotApi sendProductInfo:[ZCUICore getUICore].kitInfo.productInfo resultBlock:^(NSString * _Nonnull msg, int code) {
                
            }];
            return YES;
        }
        return NO;
    }];
#endif
}
- (void)getUnReadMessage:(NSDictionary *)argus result:(FlutterResult)result {
    
#if ZC_SOBOT_SUPPORTED
    
    [[ZCLibClient getZCLibClient] checkIMConnected];
    int num = [ZCSobotApi getUnReadMessage];
    
    NSDictionary *retData = @{@"type":[self convertIntToString:ZCPageGetUnRead],@"value":[NSString stringWithFormat:@"%d",num],@"desc":@"获取未读消息数"};
    NSLog(@"%@",retData);
    if(result){
        result(retData);
    }
#endif
}

- (void)closeSobotChat:(NSDictionary *)argus {
#if ZC_SOBOT_SUPPORTED
    [ZCLibClient closeAndoutZCServer:[[self convertString:[argus objectForKey:@"isClosePush"]] boolValue]];
#endif
}
// 发送位置消息
- (NSMutableDictionary *)locationInfo {
    if (!_locationInfo) {
        _locationInfo = [NSMutableDictionary new];
    }
    return _locationInfo;
}
- (void)sendLocation:(NSDictionary *)argus {
    
#if ZC_SOBOT_SUPPORTED
    [ZCSobotApi sendLocation:argus resultBlock:^(NSString * _Nonnull msg, int code) {
        
    }];
#endif
}

- (void)onReceiveMessage {
#if ZC_SOBOT_SUPPORTED
    [ZCLibClient getZCLibClient].receivedBlock = ^(id message, int nleft, NSDictionary *object) {
        
        NSDictionary *ret = @{@"type":[self convertIntToString:ZCPageNewMessage],@"value":message,@"desc":@"收到离线消息",@"num":@(nleft) };
        if(self.eventSink){
            self.eventSink(ret);
        }
    };
#endif
}

#if ZC_SOBOT_SUPPORTED
-(ZCLibInitInfo *) setZCLibInfoValue:(NSDictionary *)dict{
    //    dict = [self defaultInitParams];
    [ZCLibClient getZCLibClient].platformUnionCode = [self convertString:[dict objectForKey:@"platformUnionCode"]];
    
    if(dict[@"isDebugMode"]!=nil){
        [ZCLibClient getZCLibClient].isDebugMode = [[self convertString:dict[@"isDebugMode"]] boolValue];
    }
    if(dict[@"autoCloseConnect"]!=nil){
        [ZCLibClient getZCLibClient].autoCloseConnect = [[self convertString:dict[@"autoCloseConnect"]] boolValue];
    }
    
    if(dict[@"isShowTurnBtn"]!=nil){
        [ZCLibClient getZCLibClient].isShowTurnBtn = [[self convertString:dict[@"isShowTurnBtn"]] boolValue];
    }
    if(dict[@"autoNotification"]!=nil){
        [ZCLibClient getZCLibClient].autoNotification = [[self convertString:dict[@"autoNotification"]] boolValue];
    }
    ZCLibInitInfo *info = [ZCLibClient getZCLibClient].libInitInfo;
    // 获取路径信息
    
    info.platform_key = [self convertString:[dict objectForKey:@"platform_key"]];
    info.customer_code    = [self convertString:[dict objectForKey:@"customer_code"]];
    
    // 溢出相关
    info.flow_type    = [[self convertString:[dict objectForKey:@"flow_type"]] intValue];
    info.flow_companyid    = [self convertString:[dict objectForKey:@"flow_companyid"]];
    info.flow_groupid    = [self convertString:[dict objectForKey:@"flow_groupid"]];
    
    NSString *userId = [dict objectForKey:@"partnerid"];
    if([self convertString:userId].length == 0){
        userId = [dict objectForKey:@"userId"];
    }
    info.partnerid            =  [self convertString:userId];
    
    info.user_nick          = [dict objectForKey:@"user_nick"];
    info.user_name          = [dict objectForKey:@"user_name"];
    info.user_tels             = [dict objectForKey:@"user_tels"];
    info.user_emails             = [dict objectForKey:@"user_emails"];
    info.face         = [self convertString:[dict objectForKey:@"face"]];
    
    info.visit_url         = [self convertString:[dict objectForKey:@"visit_url"]];
    info.visit_title         = [self convertString:[dict objectForKey:@"visit_title"]];
    
    info.isVip    = [self convertString:[dict objectForKey:@"isVip"]];
    info.vip_level    = [self convertString:[dict objectForKey:@"vip_level"]];
    info.user_label    = [self convertString:[dict objectForKey:@"user_label"]];
    
    info.params        = [dict objectForKey:@"params"];
    
    info.customer_fields    = [dict objectForKey:@"customer_fields"];
    
    info.qq          = [self convertString:[dict objectForKey:@"qq"]];
    info.remark         = [self convertString:[dict objectForKey:@"remark"]];
    
    
    info.service_mode         = [[self convertString:[dict objectForKey:@"service_mode"]] intValue];
    
    info.robotid           = [self convertString:[dict objectForKey:@"robotid"]];
    info.choose_adminid    = [self convertString:[dict objectForKey:@"choose_adminid"]];
    info.tran_flag    = [[self convertString:[dict objectForKey:@"tran_flag"]] intValue];
    
    info.transferaction        = [dict objectForKey:@"transferaction"];
    info.summary_params        = [dict objectForKey:@"summary_params"];
    
    info.multi_params    = [dict objectForKey:@"multi_params"];
    
    
    info.groupid        =  [self convertString:[dict objectForKey:@"groupid"]];
    info.group_name      =  [self convertString:[dict objectForKey:@"group_name"]];
    
    
    info.title_type      =  [self convertString:[dict objectForKey:@"title_type"]];
    info.custom_title      =  [self convertString:[dict objectForKey:@"custom_title"]];
    info.custom_title_url      =  [self convertString:[dict objectForKey:@"custom_title_url"]];
    info.scope_time      =  [[self convertString:[dict objectForKey:@"scope_time"]] intValue];
    
    info.admin_hello_word =  [self convertString:[dict objectForKey:@"admin_hello_word"]];
    info.robot_hello_word =  [self convertString:[dict objectForKey:@"robot_hello_word"]];
    info.user_tip_word =  [self convertString:[dict objectForKey:@"user_tip_word"]];
    info.admin_offline_title =  [self convertString:[dict objectForKey:@"admin_offline_title"]];
    info.admin_tip_word =  [self convertString:[dict objectForKey:@"admin_tip_word"]];
    info.user_out_word =  [self convertString:[dict objectForKey:@"user_out_word"]];
    
    info.notifition_icon_url = [self convertString:[dict objectForKey:@"notifition_icon_url"]];
    
    info.is_enable_hot_guide = [[self convertString:[dict objectForKey:@"is_enable_hot_guide"]] boolValue];
    
    info.margs = [dict objectForKey:@"margs"];
    
    info.good_msg_type = [[self convertString:[dict objectForKey:@"good_msg_type"]] intValue];
    info.content = [self convertString:[dict objectForKey:@"content"]];
    info.queue_first = [[self convertString:[dict objectForKey:@"queue_first"]] intValue];
    info.default_language = [self convertString:[dict objectForKey:@"default_language"]];
    if([dict objectForKey:@"absolute_language"]){
        info.absolute_language = [self convertString:[dict objectForKey:@"absolute_language"]];
    }
    if([dict objectForKey:@"locale"]){
        info.locale = [self convertString:[dict objectForKey:@"locale"]];
    }
    
    //2.9.2新增
    if([dict objectForKey:@"faqId"]){
        //        info.faqId = [self convertString:[dict objectForKey:@"faqId"]];
    }
    return info;
}
-(ZCKitInfo *)setKitInfoValue:(NSDictionary *)dict {
    //    dict = [self defaultInitParams];
    // 设置初始化信息
    ZCKitInfo *kitInfo=[ZCKitInfo new];
    kitInfo.lineSpacing = [[self convertString:[dict objectForKey:@"lineSpacing"]] intValue];
    kitInfo.themeStyle = [[self convertString:[dict objectForKey:@"themeStyle"]] intValue];
    if([dict objectForKey:@"useDefaultDarkTheme"]){
        kitInfo.useDefaultDarkTheme = [[self convertString:[dict objectForKey:@"useDefaultDarkTheme"]] boolValue];
    }
    kitInfo.urlRegular = [self convertString:[dict objectForKey:@"urlRegular"]];
    kitInfo.telRegular = [self convertString:[dict objectForKey:@"telRegular"]];
    kitInfo.guideLineSpacing = [[self convertString:[dict objectForKey:@"guideLineSpacing"]] intValue];
    kitInfo.changeBusinessStr = [self convertString:[dict objectForKey:@"changeBusinessStr"]];
    
    kitInfo.isShowReturnTips = [[self convertString:[dict objectForKey:@"isShowReturnTips"]] boolValue];
    if(dict[@"ishidesBottomBarWhenPushed"]!=nil){
        kitInfo.ishidesBottomBarWhenPushed = [[self convertString:dict[@"ishidesBottomBarWhenPushed"]] boolValue];
    }
    if(dict[@"leaveCompleteCanReply"]!=nil){
        kitInfo.leaveCompleteCanReply = [[self convertString:dict[@"leaveCompleteCanReply"]] boolValue];
    }
    
    kitInfo.showLeaveDetailBackEvaluate = [[self convertString:[dict objectForKey:@"showLeaveDetailBackEvaluate"]] boolValue];
    kitInfo.isShowPortrait = [[self convertString:[dict objectForKey:@"isShowPortrait"]] boolValue];
    kitInfo.navcBarHidden = [[self convertString:[dict objectForKey:@"navcBarHidden"]] boolValue];
    kitInfo.canSendLocation = [[self convertString:[dict objectForKey:@"canSendLocation"]] boolValue];
    kitInfo.hideMenuSatisfaction = [[self convertString:[dict objectForKey:@"hideMenuSatisfaction"]] boolValue];
    kitInfo.hideMenuLeave = [[self convertString:[dict objectForKey:@"hideMenuLeave"]] boolValue];
    kitInfo.hideMenuPicture = [[self convertString:[dict objectForKey:@"hideMenuPicture"]] boolValue];
    
    kitInfo.hideMenuCamera = [[self convertString:[dict objectForKey:@"hideMenuCamera"]] boolValue];
    kitInfo.hideMenuFile = [[self convertString:[dict objectForKey:@"hideMenuFile"]] boolValue];
    
    kitInfo.isShowEvaluation = [[self convertString:[dict objectForKey:@"isShowEvaluation"]] boolValue];
    kitInfo.isShowTelIcon = [[self convertString:[dict objectForKey:@"isShowTelIcon"]] boolValue];
    kitInfo.customTel = [self convertString:[dict objectForKey:@"customTel"]];
    kitInfo.isShowClose = [[self convertString:[dict objectForKey:@"isShowClose"]] boolValue];
    kitInfo.isCloseInquiryForm = [[self convertString:[dict objectForKey:@"isCloseInquiryForm"]] boolValue];
    kitInfo.isUseImagesxcassets = [[self convertString:[dict objectForKey:@"isUseImagesxcassets"]] boolValue];
    kitInfo.isShowCloseSatisfaction = [[self convertString:[dict objectForKey:@"isShowCloseSatisfaction"]] boolValue];
    kitInfo.isCloseAfterEvaluation = [[self convertString:[dict objectForKey:@"isCloseAfterEvaluation"]] boolValue];
    
    kitInfo.isOpenEvaluation = [[self convertString:[dict objectForKey:@"isOpenEvaluation"]] boolValue];
    kitInfo.canBackWithNotEvaluation = [[self convertString:[dict objectForKey:@"canBackWithNotEvaluation"]] boolValue];
    
    if(dict[@"isShowTansfer"]!=nil){
        kitInfo.isShowTansfer = [[self convertString:dict[@"isShowTansfer"]] boolValue];
    }
    
    kitInfo.unWordsCount = [self convertString:[dict objectForKey:@"unWordsCount"]];
    
    kitInfo.isOpenActiveUser = [[self convertString:[dict objectForKey:@"isOpenActiveUser"]] boolValue];
    NSString *keys = [self convertString:[dict objectForKey:@"activeKeywords"]];
    if(keys.length > 0){
        NSMutableDictionary *keydict = [NSMutableDictionary dictionaryWithCapacity:1];
        for (NSString *itemKey in [keys componentsSeparatedByString:@","]) {
            [keydict setObject:@"1" forKey:itemKey];
        }
        kitInfo.activeKeywords = keydict;
    }
    if(dict[@"cusMenuArray"]!=nil && [dict[@"cusMenuArray"] isKindOfClass:[NSArray class]]){
        kitInfo.cusMenuArray = dict[@"cusMenuArray"];
    }
    kitInfo.cusMoreArray = dict[@"cusMoreArray"];
    kitInfo.cusRobotMoreArray = [self getCustomMenu:dict[@"cusRobotMoreArray"]];
    
    
    if(dict[@"isOpenRecord"]!=nil){
        kitInfo.isOpenRecord = [[self convertString:dict[@"isOpenRecord"]] boolValue];
    }
    if(dict[@"isUseRobotVoice"]!=nil){
        kitInfo.isOpenRobotVoice = [[self convertString:dict[@"isUseRobotVoice"]] boolValue];
    }else if(dict[@"isOpenRobotVoice"]!=nil){
        kitInfo.isOpenRobotVoice = [[self convertString:dict[@"isOpenRobotVoice"]] boolValue];
    }
    
    kitInfo.isSendInfoCard = [[self convertString:dict[@"isSendInfoCard"]] boolValue];
    if([self convertString:[dict objectForKey:@"goodsTitle"]].length > 0 && [self convertString:[dict objectForKey:@"goodsLink"]].length > 0){
        ZCProductInfo *productInfo = [ZCProductInfo new];
        // 发送商品信息，可不填
        productInfo.title = [self convertString:[dict objectForKey:@"goodsTitle"]];
        productInfo.desc = [self convertString:[dict objectForKey:@"goodsDesc"]];
        productInfo.label = [self convertString:[dict objectForKey:@"goodsLabel"]];
        productInfo.link = [self convertString:[dict objectForKey:@"goodsLink"]];
        productInfo.thumbUrl = [self convertString:[dict objectForKey:@"goodsImage"]];
        kitInfo.productInfo = productInfo;
    }
    
    kitInfo.autoSendOrderMessage = [[self convertString:dict[@"autoSendOrderMessage"]] boolValue];
    if([self convertString:[dict objectForKey:@"orderCode"]].length > 0 && dict[@"goods"]!=nil){
        ZCOrderGoodsModel *model = [ZCOrderGoodsModel new];
        model.orderStatus = [[self convertString:[dict objectForKey:@"orderStatus"]] intValue];
        model.createTime = [self convertString:[dict objectForKey:@"createTime"]];
        model.goodsCount =[self convertString:[dict objectForKey:@"goodsCount"]];
        model.orderUrl  = [self convertString:[dict objectForKey:@"orderUrl"]];
        model.orderCode = [self convertString:[dict objectForKey:@"orderCode"]];
        model.goods = [dict objectForKey:@"goods"]; //@[@{@"name":@"商品名称",@"pictureUrl":@"http://pic25.nipic.com/20121112/9252150_150552938000_2.jpg"},@{@"name":@"商品名称",@"pictureUrl":@"http://pic31.nipic.com/20130801/11604791_100539834000_2.jpg"}];
        model.totalFee = [self convertString:[dict objectForKey:@"totalFee"]];
        kitInfo.orderGoodsInfo = model;
    }
    
    
    // 字体
    kitInfo.titleFont = [self getFont:dict[@"titleFont"]];
    kitInfo.subTitleFont = [self getFont:dict[@"subTitleFont"]];
    kitInfo.listTitleFont = [self getFont:dict[@"listTitleFont"]];
    kitInfo.listDetailFont = [self getFont:dict[@"listDetailFont"]];
    kitInfo.customlistDetailFont = [self getFont:dict[@"customlistDetailFont"]];
    
    
    kitInfo.listTimeFont = [self getFont:dict[@"listTimeFont"]];
    kitInfo.chatFont = [self getFont:dict[@"chatFont"]];
    kitInfo.voiceButtonFont = [self getFont:dict[@"voiceButtonFont"]];
    
    kitInfo.goodsTitleFont = [self getFont:dict[@"goodsTitleFont"]];
    kitInfo.goodsDetFont = [self getFont:dict[@"goodsDetFont"]];
    kitInfo.notificationTopViewLabelFont = [self getFont:dict[@"notificationTopViewLabelFont"]];
    
    
    ////////////////////////////////////////////////////////////////
    // 自定义背景、边框线颜色，（可选）
    ////////////////////////////////////////////////////////////////
    
    kitInfo.goodSendBtnColor = [self getColor:dict[@"goodSendBtnColor"]];
    kitInfo.leaveSubmitBtnImgColor = [self getColor:@"leaveSubmitBtnImgColor"];
    kitInfo.scoreExplainTextColor = [self getColor:@"scoreExplainTextColor"];
    
    
    kitInfo.backgroundColor = [self getColor:dict[@"backgroundColor"]];
    kitInfo.leftChatColor = [self getColor:dict[@"leftChatColor"]];
    kitInfo.rightChatColor = [self getColor:dict[@"rightChatColor"]];
    kitInfo.leftChatSelectedColor = [self getColor:dict[@"leftChatSelectedColor"]];
    kitInfo.rightChatSelectedColor = [self getColor:dict[@"rightChatSelectedColor"]];
    kitInfo.chatTextViewColor = [self getColor:dict[@"chatTextViewColor"]];
    kitInfo.backgroundBottomColor = [self getColor:dict[@"backgroundBottomColor"]];
    kitInfo.bottomLineColor = [self getColor:dict[@"bottomLineColor"]];
    kitInfo.commentCommitButtonColor = [self getColor:dict[@"commentCommitButtonColor"]];
    kitInfo.commentButtonTextColor = [self getColor:dict[@"commentButtonTextColor"]];
    kitInfo.commentButtonBgColor = [self getColor:dict[@"commentButtonBgColor"]];
    
    kitInfo.BgTipAirBubblesColor = [self getColor:dict[@"BgTipAirBubblesColor"]];
    kitInfo.videoCellBgSelColor = [self getColor:dict[@"videoCellBgSelColor"]];
    kitInfo.LineRichColor = [self getColor:dict[@"LineRichColor"]];
    
    // 通过栏的颜色
    kitInfo.notificationTopViewBgColor = [self getColor:dict[@"notificationTopViewBgColor"]];
    kitInfo.notificationTopViewLabelColor = [self getColor:dict[@"notificationTopViewLabelColor"]];
    
    ////////////////////////////////////////////////////////////////
    // 自定义文字颜色，（可选）
    ////////////////////////////////////////////////////////////////
    kitInfo.submitEvaluationColor = [self getColor:dict[@"submitEvaluationColor"]];
    kitInfo.topViewTextColor = [self getColor:dict[@"topViewTextColor"]];
    kitInfo.leftChatTextColor = [self getColor:dict[@"leftChatTextColor"]];
    kitInfo.rightChatTextColor = [self getColor:dict[@"rightChatTextColor"]];
    kitInfo.emojiSendBgColor = [self getColor:dict[@"emojiSendBgColor"]];
    kitInfo.emojiSendTextColor = [self getColor:dict[@"emojiSendTextColor"]];
    kitInfo.timeTextColor = [self getColor:dict[@"timeTextColor"]];
    kitInfo.tipLayerTextColor = [self getColor:dict[@"tipLayerTextColor"]];
    kitInfo.serviceNameTextColor = [self getColor:dict[@"serviceNameTextColor"]];
    kitInfo.chatLeftLinkColor = [self getColor:dict[@"chatLeftLinkColor"]];
    kitInfo.chatRightLinkColor = [self getColor:dict[@"chatRightLinkColor"]];
    
    
    kitInfo.goodsTitleTextColor = [self getColor:dict[@"goodsTitleTextColor"]];
    kitInfo.goodsDetTextColor = [self getColor:dict[@"goodsDetTextColor"]];
    kitInfo.goodsTipTextColor = [self getColor:dict[@"goodsTipTextColor"]];
    kitInfo.goodsSendTextColor = [self getColor:dict[@"goodsSendTextColor"]];
    
    
    // 评价页面中 已解决和未解决 的颜色
    kitInfo.satisfactionTextColor = [self getColor:dict[@"satisfactionTextColor"]];
    kitInfo.satisfactionTextSelectedColor = [self getColor:dict[@"satisfactionTextSelectedColor"]];
    kitInfo.satisfactionSelectedBgColor = [self getColor:dict[@"satisfactionSelectedBgColor"]];
    kitInfo.satisfactionTextSelectedColor = [self getColor:dict[@"satisfactionTextSelectedColor"]];
    
    
    kitInfo.isSetPhotoLibraryBgImage = [[self convertString:dict[@"isSetPhotoLibraryBgImage"]] boolValue];
    
    kitInfo.chatLeftMultColor = [self getColor:dict[@"chatLeftMultColor"]];
    kitInfo.openMoreBtnTextColor = [self getColor:dict[@"openMoreBtnTextColor"]];
    kitInfo.moreBtnNolImg = [self convertString:dict[@"moreBtnNolImg"]];
    kitInfo.moreBtnSelImg = [self convertString:dict[@"moreBtnSelImg"]];
    kitInfo.turnBtnNolImg = [self convertString:dict[@"turnBtnNolImg"]];
    kitInfo.turnBtnSelImg = [self convertString:dict[@"turnBtnSelImg"]];
    kitInfo.topBackNolImg = [self convertString:dict[@"topBackNolImg"]];
    kitInfo.topBackSelImg = [self convertString:dict[@"topBackSelImg"]];
    
    kitInfo.topBackNolColor = [self getColor:dict[@"topBackNolColor"]];
    kitInfo.topBackSelColor = [self getColor:dict[@"topBackSelColor"]];
    kitInfo.topViewBgColor = [self getColor:dict[@"topViewBgColor"]];
    kitInfo.topBtnNolColor = [self getColor:dict[@"topBtnNolColor"]];
    kitInfo.topBtnSelColor = [self getColor:dict[@"topBtnSelColor"]];
    kitInfo.topBtnGreyColor = [self getColor:dict[@"topBtnGreyColor"]];
    
    kitInfo.topBackTitle = [self convertString:dict[@"topBackTitle"]];
    
    
    kitInfo.leaveSubmitBtnTextColor = [self getColor:dict[@"leaveSubmitBtnTextColor"]];
    kitInfo.leaveSubmitBtnImgColor = [self getColor:dict[@"leaveSubmitBtnImgColor"]];
    kitInfo.scTopTextColor = [self getColor:dict[@"scTopTextColor"]];
    kitInfo.scTopTextFont = [self getFont:dict[@"scTopTextFont"]];
    kitInfo.scTopBgColor = [self getColor:dict[@"scTopBgColor"]];
    kitInfo.scTopBackTextColor = [self getColor:dict[@"scTopBackTextColor"]];
    kitInfo.scTopBackTextFont = [self getFont:dict[@"scTopBackTextFont"]];
    
    kitInfo.documentLookImgProgressColor = [self getColor:dict[@"documentLookImgProgressColor"]];
    kitInfo.documentBtnDownColor = [self getColor:dict[@"documentBtnDownColor"]];
    
    
    kitInfo.leaveContentPlaceholder = [self convertString:dict[@"leaveContentPlaceholder"]];
    kitInfo.leaveMsgGuideContent = [self convertString:dict[@"leaveMsgGuideContent"]];
    
    if(dict[@"leaveCusFieldArray"]!=nil && [dict[@"leaveCusFieldArray"] isKindOfClass:[NSArray class]]){
        kitInfo.leaveCusFieldArray = dict[@"leaveCusFieldArray"];
    }
    kitInfo.leaveMsgGroupId = [self convertString:dict[@"leaveMsgGroupId"]];
    
    
    return kitInfo;
}

-(NSMutableArray *) getCustomMenu:(NSArray *) obj{
    if(obj && [obj isKindOfClass:[NSArray class]]){
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (NSDictionary *item in obj) {
            ZCLibCusMenu *menu1 = [[ZCLibCusMenu alloc] init];
            menu1.title = [self convertString:item[@"title"]];
            menu1.url = [self convertString:item[@"url"]];
            menu1.imgName = [self convertString:item[@"imgName"]];
            [items addObject:menu1];
        }
    }
    return nil;
}


-(NSString *)convertIntToString:(int) value{
    return [NSString stringWithFormat:@"%d",value];
}

-(NSString *) convertString:(id) object{
    if ([object isKindOfClass:[NSNull class]]) {
        return @"";
    }else if(!object){
        return @"";
    }else if([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    }else{
        return [NSString stringWithFormat:@"%@",object];
    }
}


-(UIColor *)getColor:(NSString *)hexColor
{
    if(hexColor==nil && hexColor.length<=6){
        return nil;
    }
    hexColor=[hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

-(UIFont *) getFont:(NSString *) fontSize{
    fontSize = [self convertString:fontSize];
    if(fontSize!=nil && ![@"" isEqual:fontSize]){
        if([fontSize floatValue]>0){
            return [UIFont fontWithName:@"Helvetica Neue" size:[fontSize floatValue]];
        }
    }
    return nil;
}
- (NSString *)castToJsonStringWithJson:(id)json {
    
    if ([json isKindOfClass:[NSString class]]) {
        
        return json;
    }
    if ([NSJSONSerialization isValidJSONObject:json]) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
        
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"";
}
#endif

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    
    
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    
    self.eventSink = events;
    
    return nil;
}

//- (BOOL)hasPlugin:(nonnull NSString *)pluginKey {
//
//
//}
//
//- (nullable NSObject<FlutterPluginRegistrar> *)registrarForPlugin:(nonnull NSString *)pluginKey {
//
//    return nil;
//}
//
//- (nullable NSObject *)valuePublishedByPlugin:(nonnull NSString *)pluginKey {
//
//}

//- (void)addApplicationLifeCycleDelegate:(nonnull NSObject<FlutterApplicationLifeCycleDelegate> *)delegate {
//
//
//}

@end
