#**Android 和 IOS 智齿客服系统插件**

**概述**

智齿客服全面支持桌面网站、移动网站、微信、微博、APP五种接入方式，只要10分钟就可以将智齿客服嵌入所有营销路径，各渠道用户反馈汇总至智齿客服平台统一轻松管理，企业客服效率提升50%以上。

zhiChi-SobotKit是一款实现手机用户与企业保持随时随刻沟通的客服工具。本插件封装了智齿客服的相关接口。使用此插件之前需要先注册智齿获取appkey

##**一 、使用插件前准备**

**注册方法如下:**

使用管理员账号登陆[智齿管理后台](http://www.sobot.com/console/login.jsp)，在 **智齿管理后台 > 设置 > APP >添加App** 创建应用后可得到 `appkey` 用于配置，安卓和iOS可以共用一个，也可单独配置。

注意：本插件在ios上支持最低版本为8.0 , 在android 智齿最低版本为4.2


##**二、插件方法介绍**

 1、启动智齿客服
[startZhiChi](#1)

2、启动客户服务中心
[openSobotHelpCenter](#2)

3、获取未读消息数
[getUnReadMessage](#3)

4、注销会话
[closeSobotChat](#4)

5、启动消息中心（电商版本专用）
[openSobotHelpMallCenter](#5)

6、新消息事件和超链接拦截监听
[事件监听](#6)

7、参数说明[整体参数说明](#7)

8、补充说明[常见问题](#8)

##**三、 添加依赖和导包**
```js
sobotflutter: ^（填写版本号）

//导包
import "package:sobotflutter/SobotApi.dart";

//实例化
final zhiChiSobot = SobotApi();
```

<div id="1"></div>

##**四、启动智齿客服**

示例代码如下

```js
Future<void> startZhichi() async {
    var params = {
      'app_key': 'your appkey',
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
```



相关参数，请参考[参数说明](#6)

<div id="2"></div>

##**五、启动客户服务中心**

示例代码如下

```js
Future<void> openSobotHelpCenter() async {
    var params = {
      'app_key': 'your appkey',
      'partnerid': '123456789',
    };
    final result = await zhiChiSobot.openSobotHelpCenter(params);
    print(result);
  }
```

相关参数，请参考[参数说明](#6)


<div id="3"></div>

##**六、获取未读消息数**

示例代码如下

```js
Future getUnReadMessage() async {
    var params = {'partnerid': '123456789'};
    var result = await zhiChiSobot.getUnReadMessage(params);
    print(result);
  }
```

>partnerid：

- 类型：字符串
- 默认值：无
- 描述：用户标识，可为空（建议填写，对数据统计更准确，不填默认是设备唯一标识）

<div id="4"></div>

##**七、注销会话**

示例代码如下

```js
Future<void> closeSobotChat() async {
    final result = await zhiChiSobot.closeSobotChat();
    print(result);
  }
```

> isClosePush（仅适用iOS）:

- 类型：BOOL
- 默认值：NO
- 描述：是否同时关闭推送(离线用户后，可以继续接受客服推送的离线消息;如果没有开启推送，无需关注)

<div id="5"></div>

##**八、电商版消息中心**

示例代码如下

```js
Future<void> openSobotHelpMallCenter() async {
    var params = {'partnerid': '123456789'};
    final result = await zhiChiSobot.openSobotHelpMallCenter(params);
    print(result);
  }
```

<div id="6"></div>

##**九、事件监听**

// 新消息（不在聊天页，会话没结束，同时app没被杀死时才能监听到新消息）

// isCustomLinkClick:true时，开启超链接点击事件拦截的回调；拦截返回超链接url，可以自己处理

  示例代码如下

```js
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
```


<div id="7"></div>


##**十、参数说明**
适用于iOS和android系统(特殊说明除外)

> api_host：

- 类型：字符串
- 默认值：https://api.sobot.com
- 描述：默认SaaS平台域名为:https://api.sobot.com，可为空

>app_key：

- 类型：字符串
- 默认值：无
- 描述：注册智齿后，从智齿后台获得的app_key，不可为空


> customer_code：

- 类型：字符串
- 默认值：无
- 描述：智齿电商版本商户唯一标识，如果为获取商户app_key需要指定此参数。（普通版本无效）。



>platformUnionId：

- 类型：字符串
- 默认值：无
- 描述：智齿电商版唯一标识，注册智齿付费以后由智齿提供。（普通版本无效）。



> platform_key：

- 类型：字符串
- 默认值：无
- 描述：智齿电商版加密key，注册智齿以后由智齿提供。（普通版本无效）。



>partnerid：

- 类型：字符串
- 默认值：无
- 描述：用户标识，可为空（建议填写，对数据统计更准确，不填默认是设备唯一标识）


> choose_adminid：

- 类型：字符串
- 默认值：无
- 描述：指定客服ID，可为空



> tran_flag：

- 类型：字符串
- 默认值：0
- 描述：定指客服时转接类型，0 可转入其他客服  1 必须转入指定客服（注意：如果当前指定的客服不在线，选择之后不能在转接到其他客服），可为空



> robotid：

- 类型：字符串
- 默认值：0
- 描述：对接机器人ID  （可以转接到对应的机器人），可为空


> faqId：

- 类型：整数
- 默认值：0
- 描述：指定常见问题引导，可为空

>user_nick：

- 类型：字符串
- 默认值：无
- 描述：用户昵称，可为空（填写后，客服后台会同步到备注），可为空


>user_name：

- 类型：字符串
- 默认值：无
- 描述：用户真实姓名，可为空




>user_tels：

- 类型：字符串
- 默认值：无
- 描述：用户电话，可为空


>user_emails

- 类型：字符串
- 默认值：无
- 描述：用户邮箱，可为空


>isVip

- 类型：字符串
- 默认值：指定客户是否为vip，0:普通 1:vip
- 描述：同PC端 设置-在线客服分配-排队优先设置-VIP客户排队优先 开启传1 默认不设置开启后 指定客户发起咨询时，如果出现排队，系统将优先接入。


> vip_level

- 类型：字符串
- 默认值：无
- 描述：指定客户的vip等级，传入等级，设置-自定义字段-VIP等级(注意设置编码，不是显示值)，可为空


>user_label

- 类型：字符串
- 默认值：无
- 描述：用户标签,多个字段用逗号分隔，可为空


> qq

- 类型：字符串
- 默认值：无
- 描述：用户qq，可为空



> face

- 类型：字符串
- 默认值：无
- 描述：用户头像，可为空


>remark

- 类型：字符串
- 默认值：无
- 描述：用户备注，可为空


>params

- 类型：json字典
- 默认值：无
- 描述：自定义用户资料，自动同步到客户工作台，可为空


>transferaction

- 类型：json数组
- 默认值：无
- 描述：可为空，转人工 指定技能组 溢出，[{"actionType":"to_group","optionId":"3","deciId":"162bb6bb038d4a9ea018241a30694064","spillId":"7"},
 {"actionType":"to_group","optionId":"4","deciId":"a457f4dfe92842f8a11d1616c1c58dc1"}]

 actionType:执行动作类型：to_group:转接指定技能组
 optionId:是否溢出  指定技能组时：3：溢出，4：不溢出。
 deciId:指定的技能组。
 spillId:溢出条件  指定客服组时：4:技能组无客服在线,5:技能组所有客服忙碌,6:技能组不上班,7:智能判断



>customer_fields

- 类型：json字典
- 默认值：无
- 描述：固定KEY的自定义字段，所有的KEY均在工作台设置后生效（设置->自定义字段->用户信息字段），可为空

> multi_params

- 类型：json字典
- 默认值：无
- 描述：多轮会话 自定义字段，可为空


>visit_urL

- 类型：字符串
- 默认值：无
- 描述：接入的来源URL，可为空


>visit_title

- 类型：字符串
- 默认值：无
- 描述：接入的来源说明，可为空


>service_mode

- 类型：Int
- 默认值：0
- 描述：自定义接入模式，1只有机器人,2.仅人工 3.智能客服-机器人优先 4智能客服-人工客服优先，可为空



>groupid

- 类型：字符串
- 默认值：无
- 描述：技能组编号，根据传递的值转接到对应的技能组,可为空选


> group_name

- 类型：字符串
- 默认值：无
- 描述：技能组名称，可选



> flow_type

- 类型：Int
- 默认值：0
- 描述：跨公司转接人工(仅电商版本可用),默认0不开启 1-全部溢出，2-忙碌时溢出，3-不在线时溢出，可为空




> flow_companyid

- 类型：字符串
- 默认值：无
- 描述：转接到的公司ID，可选



> flow_groupid

- 类型：字符串
- 默认值：无
- 描述：转接到的公司技能组，可选





> title_type

- 类型：字符串
- 默认值：0
- 描述：ios 和安卓实现方式不一样。
(ios)聊天页顶部标题 的自定义方式 0.默认  1.企业名称  2.自定义字段，3.仅显示文字、4显示头像和文字，可选；(android)聊天页顶部标题和头像 的自定义方式 0.默认  1.企业名称 2.自定义字段，可选


> custom_title

- 类型：字符串
- 默认值：无
- 描述：聊天页顶部标题 自定义字段  （如果传入，优先使用该字段），可选

> is_show_custom_title (仅适用安卓)

- 类型：BOOL
- 默认值：false
- 描述：是否显示聊天页顶部标题, true 显示,false 隐藏, 可选


> title_url_type (仅适用安卓)
- 类型：字符串
- 默认值：0
- 描述：聊天页顶部头像的自定义方式 聊天页顶部标题和头像 的自定义方式 0.默认  1.企业头像 2.自定义头像，可选

> custom_title_url

- 类型：字符串
- 默认值：无
- 描述：自定义导航图像路径，可选

> is_show_custom_title_url (仅适用安卓)

- 类型：BOOL
- 默认值：false
- 描述：是否显示聊天页顶部头像, true 显示,false 隐藏, 可选




> scope_time

- 类型：Int
- 默认值：0
- 描述：历史记录时间范围，单位分钟(例:100-表示从现在起前100分钟的会话)
 最大支持查询60天，如果不传是查询所有的，可为空



>admin_hello_word

- 类型：字符串
- 默认值：无
- 描述：自定义客服欢迎语,默认为空。



>robot_hello_word

- 类型：字符串
- 默认值：无
- 描述：自定义机器人欢迎语,默认为空。




>user_out_word

- 类型：字符串
- 默认值：无
- 描述：自定义用户超时下线提示语，默认为空。


>user_tip_word

- 类型：字符串
- 默认值：无
- 描述：自定义用户超时提示语，默认为空。


>admin_tip_word

- 类型：字符串
- 默认值：无
- 描述：自定义客服超时提示语,默认为空。


>admin_offline_title

- 类型：字符串
- 默认值：无
- 描述：自定义客服不在线的说辞,默认为空。



> notifition_icon_url(仅适用ios)

- 类型：字符串
- 默认值：无
- 描述：通告的icon 的URL，可选




> is_enable_hot_guide （仅适用ios）

- 类型：BOOL
- 默认值：NO
- 描述：是否允许请求热点引导问题接口，可选


> margs：

- 类型：json 字典
- 默认值：nil
- 描述：热点引导问题的扩展字段，可选


> good_msg_type

- 类型：int
- 默认值：0
- 描述：自定发送信息类型，0 不发 1 给机器人发送 2 给人工发送  3 机器人和人工都发送，可选




> content

- 类型：字符串
- 默认值：无
- 描述：自动发送信息内容，可选




> queue_first

- 类型：int
- 默认值：0
- 描述：指定客户优先  同PC端 设置-在线客服分配-排队优先设置-指定客户优先   开启传1 默认不设置 开启后 指定客户发起咨询时，如果出现排队，系统将优先接入。




> default_language（仅适用iOS）

- 类型：字符串
- 默认值：en_lproj
- 描述：默认跟随系统语言，不识别默认为en_lproj,可选ar_lproj,zh-Hans_lproj,zh-Hant_lproj



> urlRegular

- 类型：字符串
- 默认值：@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z0-9]{1,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(([a-zA-Z0-9]{2,4}).[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
- 描述：链接地址正则表达式


> telRegular

- 类型：字符串
- 默认值：@"0+\\d{2}-\\d{8}|0+\\d{2}-\\d{7}|0+\\d{3}-\\d{8}|0+\\d{3}-\\d{7}|1+[34578]+\\d{9}|\\+\\d{2}1+[34578]+\\d{9}|400\\d{7}|400-\\d{3}-\\d{4}|\\d{11}|\\d{10}|\\d{8}|\\d{7}"
- 描述：电话号码正则表达式



> lineSpacing（仅适用iOS）

- 类型：Int
- 默认值：0
- 描述：调整行间距



> guideLineSpacing（仅适用iOS）

- 类型：Int
- 默认值：0
- 描述：调整机器人引导语 行间距



> changeBusinessStr（仅适用iOS）

- 类型：字符串
- 默认值：无
- 描述：自定义"换业务"切换机器人按钮文案内容



> isShowReturnTips

- 类型：BOOL
- 默认值：NO
- 描述：左上角返回时是否弹出(您是否结束会话？)。默认false，弹出，false不弹




> ishidesBottomBarWhenPushed（仅适用iOS）

- 类型：BOOL
- 默认值：YES
- 描述：push后隐藏 BottomBar




> showLeaveDetailBackEvaluate

- 类型：BOOL
- 默认值：NO
- 描述：已完成留言详情界面：返回时是否弹出服务评价窗口(只会第一次返回弹，下次返回不会再弹)


> isShowPortrait（仅适用iOS）

- 类型：BOOL
- 默认值：NO
- 描述：仅支持竖屏，跟随APP配置


> navcBarHidden（仅适用iOS）

- 类型：BOOL
- 默认值：NO
- 描述：SDK 页面中使用自定义的导航栏不在使用系统的导航栏（隐藏）,默认 为NO 跟随集成项目


> canSendLocation（仅适用iOS）

- 类型：BOOL
- 默认值：NO
- 描述：人工状态，是否可以发送位置


> hideMenuSatisfaction

- 类型：BOOL
- 默认值：NO
- 描述：聊天页面底部加号中功能：隐藏评价，默认NO(不隐藏)


> hideMenuLeave

- 类型：BOOL
- 默认值：NO
- 描述：聊天页面底部加号中功能：隐藏留言，默认NO(不隐藏)



> hideMenuPicture

- 类型：BOOL
- 默认值：NO
- 描述：聊天页面底部加号中功能：隐藏图片，默认NO(不隐藏)


> hideMenuCamera

- 类型：BOOL
- 默认值：NO
- 描述：聊天页面底部加号中功能：隐藏拍摄，默认NO(不隐藏)



> hideMenuFile

- 类型：BOOL
- 默认值：NO
- 描述：聊天页面底部加号中功能：隐藏文件，默认NO(不隐藏)



> hideMenuVedio (仅适用安卓)

- 类型：BOOL
- 默认值：false
- 描述：聊天页面底部加号中功能：隐藏视频，默认false(不隐藏)




> isShowEvaluation

- 类型：BOOL
- 默认值：NO
- 描述：导航栏右上角 是否显示 评价按钮  默认不显示



> isCloseInquiryForm

- 类型：BOOL
- 默认值：NO
- 描述：是否关闭询前表单（默认为NO，使用系统默认配置）



> isShowCloseSatisfaction

- 类型：BOOL
- 默认值：NO
- 描述：针对关闭按钮，单独设置是否显示评价界面，默认不显示



> isShowTelIcon（仅适用iOS）

- 类型：BOOL
- 默认值：NO
- 描述：导航栏右上角 是否显示 拨号按钮 默认不显示    注意：和isShowEvaluation 互斥 只能设置一个有效



> isShowClose

- 类型：BOOL
- 默认值：NO
- 描述：导航栏左上角 是否显示 关闭按钮 默认不显示，关闭按钮，点击后无法监听后台消息




> customTel

- 类型：字符串
- 默认值：无
- 描述：设置电话号码,当导航栏右上角 显示 拨号按钮时  （和isShowTelIcon 一起设置有效）




>isCloseAfterEvaluation

- 类型：BOOL
- 默认值：NO
- 描述：评价完人工是否关闭会话,默认为NO。



> isUseImagesxcassets(仅适用ios)

- 类型：BOOL
- 默认值：NO
- 描述：是否使用Images



> isOpenEvaluation：

- 类型：BOOL
- 默认值：NO
- 描述：返回时是否开启满意度评价 ,默认为NO 未开启



>unWordsCount

- 类型：Int
- 默认值：0
- 描述：未知问题或者向导问题出现 几次时，显示转人工按钮




> isOpenActiveUser：

- 类型：BOOL
- 默认值：NO
- 描述：是否开启智能转人工,(如输入“转人工”，直接转接人工)




> activeKeywords

- 类型：json字典
- 默认值：无
- 描述：智能转人工关键字，关键字作为key{@"转人工",@"1",@"R":@"1"}



>isOpenRecord

- 类型：BOOL
- 默认值：YES
- 描述：是否开启语音功能，默认开启。



>isOpenRobotVoice

- 类型：BOOL
- 默认值：NO
- 描述：是否开启机器人语音，（付费，否则语音无法识别）

>showNotification（仅适配安卓）

- 类型：BOOL
- 默认值：false
- 描述：是否消息提醒，会话没结束时可在通知栏中显示最新消息



> isSendInfoCard：

- 类型：BOOL
- 默认值：NO
- 描述：商品卡片信息是否自动发送（转人工成功时，自动发送商品卡片信息）


> goodsTitle

- 类型：字符串
- 默认值：无
- 描述：内容描述，如果要显示必须填写；自定义咨询内容，在转接人工成功时，方便用户发送自己咨询的信息



> goodsLabel

- 类型：字符串
- 默认值：无
- 描述：内容标签，如果要显示价格、分类等


>goodsDesc

- 类型：字符串
- 默认值：无
- 描述：发送给客服的商品摘要，如果要显示必须填写；自定义咨询内容，在转接人工成功时，方便用户发送自己咨询的信息


>goodsImage

- 类型：字符串
- 默认值：无
- 描述：图片URL；自定义咨询内容，在转接人工成功时，方便用户发送自己咨询的信息


>goodsLink

- 类型：字符串
- 默认值：无 必填，且是有效链接
- 描述：当前商品URL；自定义咨询内容，在转接人工成功时，方便用户发送自己咨询的信息



>autoSendOrderMessage

- 类型：BOOL
- 默认值：NO
- 描述：人工后，是否主动发送一条订单信息



>orderStatus

- 类型：Int
- 默认值：无
- 描述：订单状态待付款: 1,
待发货: 2,
运输中: 3,
派送中: 4,
已完成: 5,
待评价: 6,
已取消: 7,
其它: 不在编码中的


>createTime

- 类型：字符串
- 默认值：无
- 描述：例如：1569491413000，不是这样的值，会发送不成功


>orderCode

- 类型：字符串
- 默认值：无
- 描述：编号


>goods

- 类型：json数组
- 默认值：无
- 描述：[{"name":"商品名称","pictureUrl":"图片地址"}]


>orderUrl

- 类型：字符串
- 默认值：无
- 描述：订单链接


>goodsCount

- 类型：字符串
- 默认值：无
- 描述：商品数量



>totalFee

- 类型：字符串
- 默认值：无
- 描述：订单价格(价格的单位为分，比如1元，需要传100)



> leaveMsgGroupId

- 类型：字符串
- 默认值：无
- 描述：留言技能组 id，获取：设置 —>工单技能组设置

> isDebugMode（仅适用iOS）:

- 类型：boolean
- 默认值：NO
- 描述：根据此设置调用的推送证书，默认NO, NO:调用生产环境, YES:测试环境

> locale:

- 类型：字符串
- 默认值：NO
- 描述：服务端接口多语言指定,支持语言: 简体中文:zh-Hans 繁体中文:zh-Hant 英语:en 西班牙语:es 葡萄牙语:pt

***
自定义字体，（所有参数可选，仅适用iOS）
***
>titleFont：

- 类型：Float
- 默认值：18.0
- 描述：顶部标题颜色、评价标题，可为空


> subTitleFont：

- 类型：Float
- 默认值：18.0
- 描述：标题左右文字，可为空



>listTitleFont：

- 类型：Float
- 默认值：16.0
- 描述：页面返回按钮，输入框，评价提交按钮、Toast提示语，可为空

>listDetailFont：

- 类型：Float
- 默认值：14.0
- 描述：各种按钮，网络提醒，可为空


>listTimeFont：

- 类型：Float
- 默认值：12.0
- 描述：消息提醒(转人工、客服接待等)，可为空

>chatFont：（仅适用iOS）

- 类型：Float
- 默认值：15.0
- 描述：聊天气泡中文字，可为空

>voiceButtonFont：

- 类型：Float
- 默认值：14.0
- 描述：录音按钮的文字，可为空

>isCustomLinkClick:

- 类型：boolean
- 默认值：false
- 描述：描述：是否自定义链接点击事件，默认NO(false)不拦截由系统内部处理；如果设置为YES(true)，所有链接(聊天内容、商品、订单等)内部将不在处理

***
自定义背景颜色，（所有参数可选，并且仅适用iOS）
***

>backgroundColor：

- 类型：字符串
- 默认值：#f0f0f0
- 描述：对话页面背景，可为空


>leftChatColor：
- 类型：字符串
- 默认值：#FFFFFF
- 描述：左侧气泡颜色，可为空

>rightChatColor：

- 类型：字符串
- 默认值：#08b0b0
- 描述：右边气泡颜色，可为空


>leftChatSelectedColor：
- 类型：字符串
- 默认值：#FFFFFF
- 描述：左边聊天气泡复制选中的背景颜色，可为空

>rightChatSelectedColor：

- 类型：字符串
- 默认值：#08b0b0
- 描述：右边聊天气泡复制选中的背景颜色，可为空


>goodSendBtnColor：

- 类型：字符串
- 默认值：#08b0b0
- 描述：商品详情cell中 btn的背景色，可为空


>leaveSubmitBtnImgColor：

- 类型：字符串
- 默认值：#08b0b0
- 描述：留言页面中 提交按钮的背景颜色

***
自定义文字颜色，（所有参数可选，且仅适用iOS）
***

> topViewTextColor：

- 类型：字符串
- 默认值：#FFFFFF
- 描述：顶部文字颜色(返回、标题)，可为空

> leftChatTextColor：

- 类型：字符串
- 默认值：#000000
- 描述：左边聊天气泡文字颜色，可为空

> rightChatTextColor：

- 类型：字符串
- 默认值：#FFFFFF
- 描述：右边聊天气泡文字颜色，可为空

> timeTextColor：

- 类型：字符串
- 默认值：#666f6f
- 描述：聊天时间文字的颜色，可为空


> tipLayerTextColor：

- 类型：字符串
- 默认值：#FFFFFF
- 描述：提示气泡文字颜色，可为空

> serviceNameTextColor：

- 类型：字符串
- 默认值：#67706e
- 描述：客服昵称文字颜色，可为空

> nickNameTextColor：

- 类型：字符串
- 默认值：#888888
- 描述：提示cell中客服昵称文字颜色，可为空

> chatLeftLinkColor：

- 类型：字符串
- 默认值：#2fb9c3
- 描述：左边超链文字颜色，可为空

> chatRightLinkColor：

- 类型：字符串
- 默认值：#0d81c0
- 描述：右边超链文字颜色，可为空


> notificationTopViewLabelFont：

- 类型：字符串
- 默认值：14.0
- 描述：通告栏的字体设置


> notificationTopViewLabelColor：

- 类型：字符串
- 默认值：#ffffff
- 描述：通告栏的文字颜色，可为空

> notificationTopViewBgColor：

- 类型：字符串
- 默认值：#FFA500
- 描述：通告栏的背景色，可为空

> satisfactionSelectedBgColor：

- 类型：字符串
- 默认值：#2fb9c3
- 描述：评价页面中 已解决 未解决 按钮的选中的背景色，可为空

> satisfactionTextSelectedColor：

- 类型：字符串
- 默认值：#FFFFFF
- 描述：评价页面中 已解决，未解决 按钮的 高亮状态的文字颜色，可为空



<div id="8"></div>
##补充说明

1、无法启动插件
使用此插件，必须先传入app_key参数，其它参数可根据自己实际情况选择设置；

***