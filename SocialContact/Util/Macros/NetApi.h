//
//  NetApi.h
//  GuaGua
//
//  Created by fqy on 2018/5/17.
//  Copyright © 2018年 HuangDeng. All rights reserved.
//

#ifndef NetApi_h
#define NetApi_h

#define URLSTR(main,str) [NSString stringWithFormat:@"%@%@",main,str]

//https://www.handanxiaohongniang.com/
//https://test.lhxq.top/
#define APP_HOST  @"https://test.lhxq.top/" //正式
#define Referer   APP_HOST



#define kApi_loginRegister_existsWithMobile 	URLSTR(HOST,@"/login/existsWithMobile.htm")

#define kApi_loginRegister_sendRegVerifyCode 	URLSTR(HOST,@"/regist/sendRegVerifyCode.htm")

#define kApi_loginRegister_verifyRegVerifyCode 	URLSTR(HOST,@"/regist/verifyRegVerifyCode.htm")

#define kApi_loginRegister_doRegistAndLogin 			URLSTR(HOST,@"/regist/doRegistAndLogin.htm")

#define kApi_loginRegister_loginByPwd 			URLSTR(HOST,@"/login/loginByPwd.htm")

#define kApi_loginRegister_sendModifyPwdVerifyCode	 URLSTR(HOST,@"/modifyPwd/sendModifyPwdVerifyCode.htm")

#define kApi_loginRegister_verifyModifyPwdVerifyCode URLSTR(HOST,@"/modifyPwd/verifyModifyPwdVerifyCode.htm")

#define kApi_loginRegister_doModifyPwd 				URLSTR(HOST,@"/modifyPwd/doModifyPwd.htm")

#define kApi_channel_getChanelList URLSTR(HOST,@"/chanel/getChanelList.htm")

#define kApi_channel_getChanelSelectConditionList URLSTR(HOST,@"/chanel/getChanelSelectConditionList.htm")

#define kApi_channel_createMessage URLSTR(HOST,@"/message/createMessage.htm")

#define kApi_channel_listMessage URLSTR(HOST,@"/message/listMessage.htm")

#define kApi_channel_createComment URLSTR(HOST,@"/comment/createComment.htm")

#define kApi_channel_listComment URLSTR(HOST,@"/comment/listComment.htm")

#define kApi_channel_createMessageZan URLSTR(HOST,@"/messageZan/createMessageZan.htm")

#define kApi_channel_cancelZan URLSTR(HOST,@"/messageZan/cancelZan.htm")

#define kApi_channel_listHotTopic URLSTR(HOST,@"/topic/listHotTopic.htm")

#define kApi_channel_getTopic URLSTR(HOST,@"/topic/getTopicByName.htm")

#define kApi_channel_getStudentInfo URLSTR(HOST,@"/student/getStudentInfo.htm")

#define kApi_channel_listChanelHomeActivityBan URLSTR(HOST,@"/activityBan/listChanelHomeActivityBan.htm")

#define kApi_channel_listMessageReportType     URLSTR(HOST,@"/messageReport/listMessageReportType.htm")

#define kApi_channel_createMessageReport URLSTR(HOST,@"/messageReport/createMessageReport.htm")

#define kApi_me_inputInviteCode URLSTR(HOST,@"/student/inputInviteCode.htm")

/**
 同意添加好友
 */
#define kApi_me_createFriend  URLSTR(HOST,@"/friend/createFriend.htm")

#define kApi_me_deleteFriend  URLSTR(HOST,@"/friend/deleteFriend.htm")

#define kApi_me_listSelectionArticle  URLSTR(HOST,@"/selectionArticle/listSelectionArticle.htm")

//获取好友列表
#define kApi_message_listFriend 	URLSTR(HOST,@"/friend/listFriend.htm")

//获取匹配时间
#define kApi_match_getMatchTime  	URLSTR(HOST,@"/match/getMatchTime.htm")

//修改用户信息接口
#define kApi_me_modifyStudentInfo  	URLSTR(HOST,@"/student/modifyStudentInfo.htm")

	// 添加好友申请
//http://localhost:81/friend/sendAddFriendAsk.htm
#define kApi_channel_sendAddFriendAsk URLSTR(HOST,@"/friend/sendAddFriendAsk.htm")

//获取匹配条件列表
#define kApi_match_listMatchCondition URLSTR(HOST,@"/match/listMatchCondition.htm")

// 开始匹配
#define kApi_match_createMatch URLSTR(HOST,@"/match/createMatch.htm")

// 取消匹配
#define kApi_match_cancelMatch URLSTR(HOST,@"/match/cancelMatch.htm")

//获取匹配信息
#define kApi_match_getMatch URLSTR(HOST,@"/match/getMatch.htm")

//获取聊天信息,用于主动查询聊天信息
#define kApi_match_chat_like URLSTR(HOST,@"/chat/like.htm")

#define kApi_match_chat_notlike URLSTR(HOST,@"/chat/notLike.htm")

#define kApi_match_chat_finishChat URLSTR(HOST,@"/chat/finishChat.htm")

#define kApi_match_getChat URLSTR(HOST,@"/chat/getChat.htm")

#define kApi_student_certify URLSTR(HOST,@"/student/certify.htm")

#define kApi_student_certifyDatum URLSTR(HOST,@"/studentCertifyDatum/create.htm")

//地址：http://localhost:81/message/deleteMessage.htm
#define kApi_message_deleteMessage URLSTR(HOST,@"/message/deleteMessage.htm")

/**
 发单
 */
#define kApi_currencyExchangeOrder_create URLSTR(HOST,@"/currencyExchangeOrder/create.htm")
/**
 接单
 */
#define kApi_currencyExchangeOrder_receive URLSTR(HOST,@"/currencyExchangeOrder/receive.htm")
/**
 信息和汇率
 */
#define kApi_currencyExchangeOrder_getStuCollAccAndCurrRate URLSTR(HOST,@"/studentCollectionAccount/getStuCollAccAndCurrRate.htm")
/**
 单子列表
 */
#define kApi_currencyExchangeOrder_list URLSTR(HOST,@"/currencyExchangeOrder/list.htm")

/**
 完善学生收款信息
 http://localhost:81/studentCollectionAccount/complateStuCollAccInfo.htm
 */
#define kApi_currencyExchangeOrder_complateStuCollAccInfo URLSTR(HOST,@"/studentCollectionAccount/complateStuCollAccInfo.htm")

/**
 兑换历史
 地址：http://localhost:81/currencyExchangeOrder/history.htm

 */
#define kApi_currencyExchangeOrder_history URLSTR(HOST,@"/currencyExchangeOrder/history.htm")

/**
 7取消兑换单
 接口图：
 
 地址：http://localhost:81/currencyExchangeOrder/cancel.htm
 请求：
 "data" : {
 "exchangeOrderId" : "1",  // 兑换单ID
 }
 */
#define kApi_currencyExchangeOrder_cancel URLSTR(HOST,@"/currencyExchangeOrder/cancel.htm")

/**
 8获取支付状态
 接口图：
 
 地址：http://localhost:81/currencyExchangeOrder/getExchangeOrderPayStatus.htm
 请求：
 "data" : {
 "exchangeOrderId" : "1",  // 兑换单ID
 }
 响应：
 {
 "code": 200,
 "msg": "",
 "result":  {
 “exchangeOrderId”:123123 // 兑换单Id
 ”payStatus”:1   // 支付状态(1支付中 2支付成功)
 }
 
 }
 */
#define kApi_currencyExchangeOrder_getExchangeOrderPayStatus URLSTR(HOST,@"/currencyExchangeOrder/getExchangeOrderPayStatus.htm")

/**
 重新支付
 */
#define kApi_currencyExchangeOrder_repay URLSTR(HOST,@"/currencyExchangeOrder/repay.htm")

/**
 8 发送认证码到邮箱
 接口图：
 
 地址：http://localhost:81/studentEmailCertify/sendMaillVerifyCode.htm
 请求：
 "data" : {
 "email":"2474445818@qq.com"
 }
 */
#define kApi_currencyExchangeOrder_sendMaillVerifyCode URLSTR(HOST,@"/studentEmailCertify/sendMaillVerifyCode.htm")

/**
 9 邮箱认证
 接口图：
 
 地址：http://localhost:81/studentEmailCertify/complateCertify.htm
 请求：
 "data" : {
 "email":"2474445818@qq.com",
 "code":"7882",
 "school":"西北炮兵学院",
 "name":"王二柱"  }
 */
#define kApi_currencyExchangeOrder_complateCertify URLSTR(HOST,@"/studentEmailCertify/complateCertify.htm")



















#endif /* NetApi_h */
