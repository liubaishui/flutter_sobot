package com.flutter_sobot;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.sobot.chat.SobotApi;
import com.sobot.chat.SobotUIConfig;
import com.sobot.chat.ZCSobotApi;
import com.sobot.chat.api.apiUtils.SobotBaseUrl;
import com.sobot.chat.api.enumtype.SobotAutoSendMsgMode;
import com.sobot.chat.api.enumtype.SobotChatAvatarDisplayMode;
import com.sobot.chat.api.enumtype.SobotChatTitleDisplayMode;
import com.sobot.chat.api.model.ConsultingContent;
import com.sobot.chat.api.model.Information;
import com.sobot.chat.api.model.OrderCardContentModel;
import com.sobot.chat.listener.NewHyperlinkListener;
import com.sobot.chat.utils.LogUtils;
import com.sobot.chat.utils.SharedPreferencesUtil;
import com.sobot.chat.utils.ZhiChiConstant;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static com.sobot.chat.api.apiUtils.SobotApp.getApplicationContext;

/** FlutterSobotPlugin */
public class ZCSobotPlugin implements FlutterPlugin, MethodCallHandler , EventChannel.StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private EventChannel eventChannel;

  private String startZhichiMethod = "ZCSobot_Plugin_Start_SDK";
  private String openSobotHelpCenterMethod = "ZCSobot_Plugin_Open_Help_Center";
  private String openSobotHelpMallCenterMethod = "ZCSobot_Plugin_Open_Help_Mall_Center";
  private String closeSobotChatMethod = "ZCSobot_Plugin_Close_Sobot_Chat";
  private String getUnReadMessageMethod = "ZCSobot_Plugin_Get_Unread_Message";

  private Context mContext;
  private MyReceiver receiver;
  public EventChannel.EventSink mEventSink;

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    mEventSink=events;
    //注册广播获取新收到的信息和未读消息数
    if (receiver == null) {
      receiver = new MyReceiver(events);
    }
    IntentFilter filter = new IntentFilter();
    filter.addAction("sobot_unreadCountBrocast");
    if (mContext != null) {
      mContext.registerReceiver(receiver, filter);
    }
  }

  @Override
  public void onCancel(Object arguments) {
    if (mContext != null && receiver != null) {
      mContext.unregisterReceiver(receiver);
      receiver = null;
    }
  }

  //设置广播获取新收到的信息和未读消息数
  class MyReceiver extends BroadcastReceiver {
    public EventChannel.EventSink mEventSink;

    public MyReceiver(EventChannel.EventSink eventSink) {
      this.mEventSink = eventSink;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
      if (ZhiChiConstant.sobot_unreadCountBrocast.equals(intent.getAction())) {
        //未读消息数
        int noReadNum = intent.getIntExtra("noReadCount", 0);
        //新消息内容
        String content = intent.getStringExtra("content");
        JSONObject ret = new JSONObject();
        try {
          ret.put("type", "3");
          ret.put("num", noReadNum);
          ret.put("value", content);
          ret.put("desc", "新消息和未读消息数");
          if (mEventSink != null) {
            mEventSink.success(ret);
          }
        } catch (Exception e) {
          e.printStackTrace();
        }
        LogUtils.i(" 未读消息数:" + noReadNum + "   新消息内容:" + content);
      }
    }
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_sobot");
    eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "sobot");
    channel.setMethodCallHandler(this);
    eventChannel.setStreamHandler(this);
    mContext = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
    ZCSobotApi.setShowDebug(true);
    if (call.method.equals(startZhichiMethod)) {
      if (getInfo(call, result) == null) {
        result.success("appKey不能为空");
      } else {
        ZCSobotApi.openZCChat(mContext, getInfo(call, result));
        result.success("启动成功");
      }
    } else if (call.method.equals(openSobotHelpCenterMethod)) {
      if (getInfo(call, result) == null) {
        result.success("appKey不能为空");
      } else {
        ZCSobotApi.openZCServiceCenter(mContext, getInfo(call, result));
        result.success("启动客户服务中心成功");
      }
    } else if (call.method.equals(closeSobotChatMethod)) {
      ZCSobotApi.outCurrentUserZCLibInfo(mContext);
      result.success("结束会话成功");
    } else if (call.method.equals(getUnReadMessageMethod)) {
      int unReadNum = 0;
      if (call.hasArgument("partnerid")) {
        unReadNum = ZCSobotApi.getUnReadMessage(mContext, (String) call.argument("partnerid"));
      }
      JSONObject ret = new JSONObject();
      try {
        ret.put("type", "4");
        ret.put("value", "" + unReadNum);
        ret.put("desc", "获取未读消息数");
        result.success(ret.toJSONString());
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else if (call.method.equals(openSobotHelpMallCenterMethod)) {
      if (call.hasArgument("partnerid")) {
        ZCSobotApi.openZCChatListView(mContext, (String) call.argument("partnerid"));
      }
      result.success("结束会话成功");
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }


  public Information getInfo(MethodCall call, final Result result) {
    //注册智齿后，从智齿后台获得的appKey，不可为空
    String appKey = "";
    if (!TextUtils.isEmpty((String) call.argument("app_key"))) {
      appKey = (String) call.argument("app_key");
    }
    if (!TextUtils.isEmpty((String) call.argument("appKey"))) {
      appKey = (String) call.argument("appKey");
    }
    if (!TextUtils.isEmpty((String) call.argument("appkey"))) {
      appKey = (String) call.argument("appkey");
    }
    //类型：boolean  默认值：0 描述：自己处理消息中的链接，如果设置为1，将通过callBack返回到页面ret=1,value为link实际地址，desc为描述
    if (call.hasArgument("isCustomLinkClick")) {
      boolean isCustomLinkClick = (boolean) call.argument("isCustomLinkClick");
      if (isCustomLinkClick) {
        ZCSobotApi.setNewHyperlinkListener(new NewHyperlinkListener() {
          @Override
          public boolean onUrlClick(String url) {
            JSONObject ret = new JSONObject();
            try {
              ret.put("type", "2");
              ret.put("value", url);
              ret.put("desc", "点击了超链接");
              if (mEventSink!=null){
                mEventSink.success(ret);
              }
            } catch (Exception e) {
              e.printStackTrace();
            }
            return true;
          }

          @Override
          public boolean onEmailClick(String email) {
            return false;
          }

          @Override
          public boolean onPhoneClick(String phone) {
            return false;
          }
        });
      }
    }
    //类型：boolean  默认值：false  描述：是否使用机器人语音功能 默认false时机器人不可以使用语音功能。注意这是一个付费功能
    //默认值：false 描述：是否开启消息通知
    if (call.hasArgument("showNotification")) {
      boolean showNotification = (boolean) call.argument("showNotification");
      if (showNotification) {
        //设置是否开启消息提醒
        SobotApi.setNotificationFlag(getApplicationContext(), true, R.drawable.sobot_logo_small_icon, R.drawable.sobot_logo_icon);
      }
    }

    if (TextUtils.isEmpty(appKey)) {
      LogUtils.i("jsmethod_startZhiChiSobot: appKey不能为空");
      return null;
    }
    String apiHost = (String) call.argument("apiHost");
    if (!TextUtils.isEmpty(apiHost)) {
      SobotBaseUrl.setApi_Host(apiHost);
    }

    String api_host = (String) call.argument("api_host");
    if (!TextUtils.isEmpty(api_host)) {
      SobotBaseUrl.setApi_Host(api_host);
    }
    //用户标识，自动备注客户资料，可为空（建议填写，对数据统计更准确，不填默认是设备唯一标识）
    String partnerid = (String) call.argument("partnerid");
    SobotApi.initSobotSDK(mContext, appKey, partnerid);
    // initPlatformUnion()在initSobotSDK()之后调用
    if (call.hasArgument("platformUnionId") && !TextUtils.isEmpty((String) call.argument("platformUnionId"))) {
      String platformUnionId = (String) call.argument("platformUnionId");
      String platformSecretkey = "";
      if (call.hasArgument("platformSecretkey")) {
        platformSecretkey = (String) call.argument("platformSecretkey");
      }
      //初始化电商平台
      ZCSobotApi.initPlatformUnion(getApplicationContext(), platformUnionId, platformSecretkey); // platformUnionCode - 平台id
      if (call.hasArgument("flow_type") && !TextUtils.isEmpty((String) call.argument("flow_type"))) {
        //flowType -是否溢出到主商户 0-不溢出 , 1-全部溢出，2-忙碌时溢出，3-不在线时溢出,  默认不溢出
        ZCSobotApi.setFlow_Type(getApplicationContext(), (String) call.argument("flow_type"));
      }
      if (call.hasArgument("flow_groupid") && !TextUtils.isEmpty((String) call.argument("flow_groupid"))) {
        //转人工溢出公司技能组id
        ZCSobotApi.setFlow_GroupId(getApplicationContext(), (String) call.argument("flow_groupid"));
      }
      if (call.hasArgument("flow_companyid") && !TextUtils.isEmpty((String) call.argument("flow_companyid"))) {
        //设置溢出公司id
        ZCSobotApi.setFlow_Company_Id(getApplicationContext(), (String) call.argument("flow_companyid"));
      }
    }
    Information info = new Information();
    info.setApp_key(appKey);/* 必填 */
    if (call.hasArgument("customer_code")) {
      String customerCode = (String) call.argument("customer_code");
      info.setCustomer_code(customerCode);
    }

    if (!TextUtils.isEmpty(partnerid)) {
      info.setPartnerid(partnerid);
    }
    //指定客服ID
    String choose_adminid = (String) call.argument("choose_adminid");
    if (!TextUtils.isEmpty(choose_adminid)) {
      info.setChoose_adminid(choose_adminid);
    }

    if (call.hasArgument("tran_flag")) {
      //机器⼈模式定指客服时转接类型，0 可转入其他客服 1 必须转入指定客服（注意：如果当前指定的客服不在线，选择之后不能在转接到其他客服）下输⼊关键字主动转⼈⼯,多个请使用英文逗号隔开如"R,r,转人工"。可为空
      int tran_flag = call.argument("tran_flag");
      //转接类型(0-可转入其他客服，1-必须转入指定客服)
      info.setTranReceptionistFlag(tran_flag);
    }

    //对接机器人ID （可以转接到对应的机器人）
    String robotid = (String) call.argument("robotid");
    if (!TextUtils.isEmpty(robotid)) {
      info.setRobotCode(robotid);
    }

    //用户昵称，可为空
    String user_nick = (String) call.argument("user_nick");
    if (!TextUtils.isEmpty(user_nick)) {
      info.setUser_nick(user_nick);
    }

    //用户的真实姓名
    String user_name = (String) call.argument("user_name");
    if (!TextUtils.isEmpty(user_name)) {
      info.setUser_name(user_name);
    }

    //用户电话，可为空
    String user_tels = (String) call.argument("user_tels");
    if (!TextUtils.isEmpty(user_tels)) {
      info.setUser_tels(user_tels);/* 用户电话，选填 */
    }

    //用户邮箱，可为空
    String user_emails = (String) call.argument("user_emails");
    if (!TextUtils.isEmpty(user_emails)) {
      info.setUser_emails(user_emails);/* 用户邮箱，选填 */
    }

    //用户QQ，可为空
    String qq = (String) call.argument("qq");
    if (!TextUtils.isEmpty(qq)) {
      info.setQq(qq);/*用户QQ*/
    }

    //用户头像，可为空
    String face = (String) call.argument("face");
    if (!TextUtils.isEmpty(face)) {
      info.setFace(face);/*自定义头像 http://img.taopic.com/uploads/allimg/130711/318756-130G1222R317.jpg*/
    }

    //用户备注，可为空
    String remark = (String) call.argument("remark");
    if (!TextUtils.isEmpty(remark)) {
      info.setRemark(remark);/*用户备注*/
    }

    //指定客户是否为vip，0:普通 1:vip;同PC端 设置-在线客服分配-排队优先设置-VIP客户排队优先 开启传1 默认不设置开启后 指定客户发起咨询时，如果出现排队，系统将优先接入。
    String isVip = (String) call.argument("isVip");
    if (!TextUtils.isEmpty(isVip)) {
      info.setIsVip(isVip);
    }

    //指定客户的vip等级，传入等级，设置-自定义字段-VIP等级(注意设置编码，不是显示值)，可为空
    String vip_level = (String) call.argument("vip_level");
    if (!TextUtils.isEmpty(vip_level)) {
      info.setVip_level(vip_level);
    }

    //用户标签,多个字段用逗号分隔，可为空
    String user_label = (String) call.argument("user_label");
    if (!TextUtils.isEmpty(user_label)) {
      info.setUser_label(user_label);
    }

    //自定义用户资料，自动同步到客户工作台，可为空
    Map params = (HashMap) call.argument("params");
    if (params != null) {
      info.setParams(params);/* 自定义用户资料 */
    }

    //描述：固定KEY的自定义字段,设置用户自定义字段.(自定义字段的key参考 www.sobot.com登录成功-->设置-->自定义字段-->客户字段-->查看显示ID就是这里的key)
    String customer_fields = (String) call.argument("customer_fields");
    if (!TextUtils.isEmpty(customer_fields)) {
      info.setCustomer_fields(customer_fields);
    }

    //转人工 指定技能组 溢出
    String transferaction = (String) call.argument("transferaction");
    if (!TextUtils.isEmpty(transferaction)) {
      info.setTransferAction(transferaction);
    }

    //多轮会话 自定义字段
    String multi_params = (String) call.argument("multi_params");
    if (!TextUtils.isEmpty(multi_params)) {
      info.setMulti_params(multi_params);
    }

    //接入的来源URL，可为空
    String visit_urL = (String) call.argument("visit_urL");
    if (!TextUtils.isEmpty(visit_urL)) {
      info.setVisit_url(visit_urL);
    }
    //接入的来源Title，可为空
    String visit_title = (String) call.argument("visit_title");
    if (!TextUtils.isEmpty(visit_title)) {
      info.setVisit_title(visit_title);
    }

    //自定义接入模式，1只有机器人,2.仅人工 3.智能客服-机器人优先 4智能客服-人工客服优先，可为空
    int service_mode = 100;
    if (call.hasArgument("service_mode")) {
      service_mode = call.argument("service_mode");
    }
    if (service_mode != 100) {
      info.setService_mode(service_mode);// 客服模式控制
    }

    //技能组编号，根据传递的值转接到对应的技能组，可选
    String groupid = (String) call.argument("groupid");
    if (!TextUtils.isEmpty(groupid)) {
      info.setGroupid(groupid);
    }

    //技能组名称，可选
    String group_name = (String) call.argument("group_name");
    if (!TextUtils.isEmpty(group_name)) {
      info.setGroup_name(group_name);
    }

    if (call.hasArgument("is_show_custom_title")) {
      //ios 和安卓实现方式不一样。
      //(ios)聊天页顶部标题 的自定义方式 0.默认  1.企业名称  2.自定义字段，3.仅显示文字、4显示头像和文字，可选；(android)聊天页顶部标题和头像 的自定义方式 0.默认  1.企业名称 2.自定义字段，可选
      int title_type = call.argument("title_type");
      String custom_title = (String) call.argument("custom_title");
      boolean is_show_custom_title = (boolean) call.argument("is_show_custom_title");
      // 聊天页顶部头像 的自定义方式 0.默认(头像)  1.企业头像  2.自定义头像
      switch (title_type) {
        case 0:
          SobotApi.setChatTitleDisplayMode(getApplicationContext(),
                  SobotChatTitleDisplayMode.Default, custom_title, is_show_custom_title);
          break;
        case 1:
          SobotApi.setChatTitleDisplayMode(getApplicationContext(),
                  SobotChatTitleDisplayMode.ShowCompanyName, custom_title, is_show_custom_title);
          break;
        case 2:
          SobotApi.setChatTitleDisplayMode(getApplicationContext(),
                  SobotChatTitleDisplayMode.ShowFixedText, custom_title, is_show_custom_title);
          break;
      }
    }
    if (call.hasArgument("is_show_custom_title_url")) {
      int title_url_type = 0;
      //聊天页顶部头像的自定义方式 聊天页顶部标题和头像 的自定义方式 0.默认  1.企业头像 2.自定义头像，可选
      if (call.hasArgument("title_url_type")) {
        title_url_type = (int) call.argument("title_url_type");
      }
      String custom_title_url = "";
      if (call.hasArgument("custom_title_url")) {
        custom_title_url = (String) call.argument("custom_title_url");
      }
      boolean is_show_custom_title_url = (boolean) call.argument("is_show_custom_title_url");
      //设置聊天界面头部标题栏的头像模式
      switch (title_url_type) {
        case 0:
          SobotApi.setChatAvatarDisplayMode(getApplicationContext(), SobotChatAvatarDisplayMode.Default, custom_title_url, is_show_custom_title_url);
          break;
        case 1:
          SobotApi.setChatAvatarDisplayMode(getApplicationContext(), SobotChatAvatarDisplayMode.ShowCompanyAvatar, custom_title_url, is_show_custom_title_url);
          break;
        case 2:
          SobotApi.setChatAvatarDisplayMode(getApplicationContext(), SobotChatAvatarDisplayMode.ShowFixedAvatar, custom_title_url, is_show_custom_title_url);
          break;
      }
    }

    if (call.hasArgument("scope_time")) {
      //历史记录时间范围，单位分钟(例:100-表示从现在起前100分钟的会话)
      int scope_time = call.argument("scope_time");
      //设置隐藏几分钟之前的历史消息
      //time-查询时间(例:100-表示从现在起前100分钟的会话)  默认为0  表示不隐藏历史记录
      SobotApi.setScope_time(getApplicationContext(), scope_time);
    }

    //自定义用户超时下线提示语，默认为空。
    String customUserOutWord = (String) call.argument("user_out_word");
    //自定义用户超时提示语，默认为空。
    String customUserTipWord = (String) call.argument("user_tip_word");
    //自定义客服超时提示语,默认为空。
    String customAdminTipWord = (String) call.argument("admin_tip_word");
    //自定义机器人欢迎语,默认为空。
    String customRobotHelloWord = (String) call.argument("robot_hello_word");
    //自定义客服不在线的说辞,默认为空。
    String customAdminNonelineTitle = (String) call.argument("admin_offline_title");
    //自定义客服欢迎语,默认为空。
    String customAdminHelloWord = (String) call.argument("admin_hello_word");
    if (!TextUtils.isEmpty(customAdminHelloWord)) {
      SobotApi.setAdmin_Hello_Word(mContext, customAdminHelloWord);//自定义客服欢迎语,默认为空 （如果传入，优先使用该字段）
    }
    if (!TextUtils.isEmpty(customRobotHelloWord)) {
      SobotApi.setRobot_Hello_Word(mContext, customRobotHelloWord);//自定义机器人欢迎语,默认为空 （如果传入，优先使用该字段）
    }
    if (!TextUtils.isEmpty(customUserTipWord)) {
      SobotApi.setUser_Tip_Word(mContext, customUserTipWord);//自定义用户超时提示语,默认为空 （如果传入，优先使用该字段）
    }
    if (!TextUtils.isEmpty(customAdminTipWord)) {
      SobotApi.setAdmin_Tip_Word(mContext, customAdminTipWord);//自定义客服超时提示语,默认为空 （如果传入，优先使用该字段）
    }
    if (!TextUtils.isEmpty(customAdminNonelineTitle)) {
      SobotApi.setAdmin_Offline_Title(mContext, customAdminNonelineTitle);// 自定义客服不在线的说辞,默认为空 （如果传入，优先使用该字段）
    }
    if (!TextUtils.isEmpty(customUserOutWord)) {
      SobotApi.setUser_Out_Word(mContext, customUserOutWord);// 自定义用户超时下线提示语,默认为空 （如果传入，优先使用该字段）
    }

    //热点引导问题的扩展字段 map
    String hotguideDict = (String) call.argument("margs");
    if (!TextUtils.isEmpty(hotguideDict)) {
      info.setMargs(getMap(hotguideDict));
    }

    if (call.hasArgument("good_msg_type") && call.hasArgument("content")) {
      //------会话创建后自动发送消息的模式---------
      //聊天页顶部头像的自定义方式 聊天页顶部标题和头像 的自定义方式 0.默认  1.企业头像 2.自定义头像，可选
      int good_msg_type = call.argument("good_msg_type");
      String content = (String) call.argument("content");
      //自定发送信息类型，0 不发 1 给机器人发送 2 给人工发送  3 机器人和人工都发送，可选
      switch (good_msg_type) {
        case 1:
          info.setAutoSendMsgMode(SobotAutoSendMsgMode.SendToRobot.setContent(content));
          break;
        case 2:
          info.setAutoSendMsgMode(SobotAutoSendMsgMode.SendToOperator.setContent(content));
          break;
        case 3:
          info.setAutoSendMsgMode(SobotAutoSendMsgMode.SendToAll.setContent(content));
          break;
      }
    }
    if (call.hasArgument("orderStatus") && call.hasArgument("orderCode") && call.hasArgument("autoSendOrderMessage")) {
      //----------订单卡片-----------
      List<OrderCardContentModel.Goods> goodsList = new ArrayList<>();
      if (call.hasArgument("goods")) {
        List goodsList1 = call.argument("goods");
        if (goodsList1 != null) {
          String goodsList2 = JSON.toJSONString(goodsList1);
          if (!TextUtils.isEmpty(goodsList2)) {
            List<OrderCardContentModel.Goods> goodsList3 = getGoodsList(goodsList2);
            if (goodsList3 != null) {
              goodsList.addAll(goodsList3);
            }
          }
//
        }
      }

      OrderCardContentModel orderCardContent = new OrderCardContentModel();
      //订单编号（必填）
      orderCardContent.setOrderCode((String) call.argument("orderCode"));
      //订单状态
      orderCardContent.setOrderStatus((int) call.argument("orderStatus"));
      //订单总金额
      orderCardContent.setTotalFee((int) call.argument("totalFee"));
      //订单商品总数
      orderCardContent.setGoodsCount((int) call.argument("goodsCount") + "");
      //订单链接
      orderCardContent.setOrderUrl((String) call.argument("orderUrl"));
      //订单创建时间
      orderCardContent.setCreateTime((String) call.argument("createTime"));
      orderCardContent.setAutoSend((boolean) call.argument("autoSendOrderMessage"));
      //订单商品集合
      orderCardContent.setGoods(goodsList);
      info.setOrderGoodsInfo(orderCardContent);
    }

    String leaveMsgGroupId = (String) call.argument("leaveMsgGroupId");
    if (!TextUtils.isEmpty(leaveMsgGroupId)) {
      info.setLeaveMsgGroupId(leaveMsgGroupId);
    }


    //内容描述，如果要显示必须填写；自定义咨询内容，在转接人工成功时，方便用户发送自己咨询的信息
    String goodsTitle = (String) call.argument("goodsTitle");
    //内容标签，如果要显示价格、分类等
    String goodsLabel = (String) call.argument("goodsLabel");
    //发送给客服的商品摘要，如果要显示必须填写；自定义咨询内容，在转接人工成功时，方便用户发送自己咨询的信息
    String goodsDesc = (String) call.argument("goodsDesc");
    //图片URL；自定义咨询内容，在转接人工成功时，方便用户发送自己咨询的信息
    String goodsImage = (String) call.argument("goodsImage");
    //当前商品URL；自定义咨询内容，在转接人工成功时，方便用户发送自己咨询的信息
    String goodsFromUrl = (String) call.argument("goodsLink");
    if (call.hasArgument("goodsTitle")) {
      ConsultingContent consultingContent = new ConsultingContent(); //咨询内容
      consultingContent.setSobotGoodsTitle(goodsTitle); //咨询内容标题
      consultingContent.setSobotGoodsImgUrl(goodsImage); //咨询内容图片 选填
      consultingContent.setSobotGoodsFromUrl(goodsFromUrl); //发送内容
      consultingContent.setSobotGoodsDescribe(goodsDesc);
      consultingContent.setSobotGoodsLable(goodsLabel);
      if (call.hasArgument("isSendInfoCard")) {
        boolean isSendInfoCard = (boolean) call.argument("isSendInfoCard");
        consultingContent.setAutoSend(isSendInfoCard);
      }
      info.setContent(consultingContent);
    }


    //机器⼈模式下输⼊关键字主动转⼈⼯,多个请使用英文逗号隔开如"R,r,转人工"。可为空
    String transferKeyWord = (String) call.argument("activeKeywords");
    if (!TextUtils.isEmpty(transferKeyWord)) {
      String[] transferKeys = transferKeyWord.split(",");
      if (transferKeys.length > 0) {
        HashSet<String> tmpSet = new HashSet<>();
        for (int i = 0; i < transferKeys.length; i++) {
          tmpSet.add(transferKeys[i]);
        }
        info.setTransferKeyWord(tmpSet);//设置转人工关键字
      }
    }

    if (call.hasArgument("isCloseAfterEvaluation")) {
      //评价完人工是否关闭会话,默认为NO。
      boolean isCloseAfterEvaluation = (boolean) call.argument("isCloseAfterEvaluation");
      //配置用户提交人工满意度评价后释放会话
      SobotApi.setEvaluationCompletedExit(mContext, isCloseAfterEvaluation);
    }
    if (call.hasArgument("isShowReturnTips")) {
      //左上角返回时是否弹出(您是否结束会话？)。默认false，弹出，false不弹
      boolean isShowReturnTips = (boolean) call.argument("isShowReturnTips");
      info.setShowLeftBackPop(isShowReturnTips);
    }

    if (call.hasArgument("isOpenEvaluation")) {
      //描述：点击返回时是否弹出满意度评价。默认true，弹出满意度评价，false不弹满意度。
      boolean isShowEvaluate = (boolean) call.argument("isOpenEvaluation");
      info.setShowSatisfaction(isShowEvaluate);
    }

    if (call.hasArgument("isOpenActiveUser")) {
      //是否开启智能转人工,(如输入“转人工”，直接转接人工) 需要隐藏转人工按钮，请参见isShowTansfer和unWordsCount属性
      boolean isOpenActiveUser = (boolean) call.argument("isOpenActiveUser");
      info.setArtificialIntelligence(isOpenActiveUser);
    }

    if (call.hasArgument("unWordsCount")) {
      //描述：未知问题或者向导问题出现 几次时，显示转人工按钮
      int unWordsCount = call.argument("unWordsCount");
      info.setArtificialIntelligenceNum(unWordsCount);/* 未知问题或者向导问题出现 几次时，显示转人工按钮 */
    }
    //是否开启语音功能，默认开启。
    boolean isOpenRecord = true;
    if (call.hasArgument("isOpenRecord")) {
      isOpenRecord = call.argument("isOpenRecord");
    }
    info.setUseVoice(isOpenRecord);/*是否使用语音功能*/

    if (call.hasArgument("isOpenRobotVoice")) {
      boolean isUseRobotVoice = (boolean) call.argument("isOpenRobotVoice");
      info.setUseRobotVoice(isUseRobotVoice);
    }

    //导航栏右上角 是否显示 关闭按钮 默认不显示
    if (call.hasArgument("isShowClose")) {
      boolean isShowClose = (boolean) call.argument("isShowClose");
      info.setShowCloseBtn(isShowClose);//置是否显示关闭按钮，不设置默认不显示
    }

    //针对关闭按钮，单独设置是否显示评价界面，默认不显示
    if (call.hasArgument("isShowCloseSatisfaction")) {
      boolean isShowCloseSatisfaction = (boolean) call.argument("isShowCloseSatisfaction");
      info.setShowCloseSatisfaction(isShowCloseSatisfaction);////这个方法是针对关闭按钮的，设置是否显示评价界面，默认不显示
    }

    //导航栏右上角 是否显示 评价按钮  默认不显示
    if (call.hasArgument("isShowEvaluation")) {
      boolean isShowEvaluation = (boolean) call.argument("isShowEvaluation");
      if (isShowEvaluation) {
        SobotUIConfig.sobot_title_right_menu2_display = isShowEvaluation;//设置 toolbar右边第二个按钮是否显示（评价）
      }
    }

    boolean isShowTelIcon = false;
    //导航栏右上角 是否显示 拨号按钮 默认不显示    注意：和isShowEvaluation 互斥 只能设置一个有效
    if (call.hasArgument("isShowTelIcon")) {
      isShowTelIcon = (boolean) call.argument("isShowTelIcon");
    }
    //设置电话号码
    String customTel = (String) call.argument("customTel");
    if (isShowTelIcon) {
      SobotUIConfig.sobot_title_right_menu2_display = isShowTelIcon;
      SobotUIConfig.sobot_title_right_menu2_call_num = customTel;
    }

    //转人工自定义字段
    String summaryParams = (String) call.argument("summaryParams");
    if (!TextUtils.isEmpty(summaryParams)) {
      info.setSummary_params(summaryParams);
    }

    //指定常见问题引导
    if (call.hasArgument("faqId")) {
      int faqId = call.argument("faqId");
      info.setFaqId(faqId);
    }

    // 机器人问答是否支持分词联想
    if (call.hasArgument("isEnableAutoTips")) {
      boolean isEnableAutoTips = (boolean) call.argument("isEnableAutoTips");
      SharedPreferencesUtil.saveBooleanData(mContext, ZhiChiConstant.SOBOT_CONFIG_SUPPORT, isEnableAutoTips);
    }

    //  指定客户优先  同PC端 设置-在线客服分配-排队优先设置-指定客户优先   开启传1 默认不设置  开启后 指定客户发起咨询时，如果出现排队，系统将优先接入
    if (call.hasArgument("queue_first")) {
      boolean queueFirst = (boolean) call.argument("queue_first");
      //设置排队优先接入 true:优先接入  false:默认值，正常排队
      info.setIs_Queue_First(queueFirst);
    }

    return info;
  }

  /**
   * 将json 数组转换为Map 对象
   *
   * @param jsonString
   * @return
   */

  public static Map<String, String> getMap(String jsonString) {
    if (TextUtils.isEmpty(jsonString))
      return null;
    JSONObject jsonObject = JSONObject.parseObject(jsonString);
    //json对象转Map
    Map<String, String> map = JSONObject.parseObject(jsonObject.toJSONString(), new TypeReference<Map<String, String>>() {
    });

    return map;
  }

  public static List<OrderCardContentModel.Goods> getGoodsList(String goodsStr) {
    List<OrderCardContentModel.Goods> goodsList = new ArrayList<>();
    JSONArray jsonArray = null;
    try {
      jsonArray = new JSONArray(goodsStr);
      if (jsonArray != null && jsonArray.length() > 0) {
        for (int i = 0; i < jsonArray.length(); i++) {
          org.json.JSONObject jsonObject = (org.json.JSONObject) jsonArray.get(i);
          OrderCardContentModel.Goods goods = new OrderCardContentModel.Goods();
          goods.setName(jsonObject.getString("name"));
          goods.setPictureUrl(jsonObject.getString("pictureUrl"));
          goodsList.add(goods);
        }
      }
      return goodsList;
    } catch (JSONException e) {
      e.printStackTrace();
    }
    return goodsList;
  }

}
