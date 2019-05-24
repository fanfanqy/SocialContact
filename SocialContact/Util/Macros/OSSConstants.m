//
//  Constant.m
//  AliyunOSSiOS
//
//  Created by jingdan on 2017/9/8.
//  Copyright © 2017年 zhouzhuo. All rights reserved.
//

#import "OSSConstants.h"

NSString * const BUCKET_NAME = @"guagua-huangdeng";
NSString * const UPLOAD_OBJECT_KEY = @"upload_object_key";
NSString * const DOWNLOAD_OBJECT_KEY = @"download_object_key";
NSString * const endPoint = @"oss-cn-hangzhou.aliyuncs.com";
NSString * const imageEndPoint = @"oss-cn-hangzhou.aliyuncs.com";
NSString * const callbackAddress = @"http://oss-demo.aliyuncs.com:23450";
/**
 STS_AUTH_URL 到/oss 之前的host，需要和HOST保持一致
 */
NSString * const STS_AUTH_URL = @"http://api.devot.guaguaclub.com/oss/getAppToken.htm";

NSString* const OSSStyle = @"test-style";

NSString *const GDAppKey = @"83387a1fc656b6c33b8428df94313465";
/**
 生产服务器：
 海外测试：http://api.devot.guaguaclub.com
 */
NSString *const HOST = @"http://api.devot.guaguaclub.com";////
NSInteger const RequestTimeoutInterval = 15;
NSInteger const kRequest_OK = 200;
/**
 DEBUG 下，请求出错，可能客户端请求写错，或服务器错误
 发布 下，服务器错误，前提是测试阶段已测试接口无错误
 */
NSString *const kServerBusyAlert = @"服务器忙，请稍后再试";//@"服务器忙，请稍后再试"


NSInteger const kNickNameMaxWords = 8; //20
NSInteger const kSelfIntroduceMaxWords = 100; //100


NSString *const HXAppKey = @"1142180504177015#guagua";// @"1142180504177015#guagua"
#if DEBUG
NSString *const HXPushName = @"DevPush_Board";
#else
NSString *const HXPushName = @"ProPush_Board";
#endif

/* 搜索历史 */
NSString *const GuaSEARCH_SEARCH_HISTORY_CACHE_PATH = @"GuaSEARCH_SEARCH_HISTORY_CACHE_PATH";// @"GuaSEARCH_SEARCH_HISTORY_CACHE_PATH"
NSString *const LAST_RUN_VERSION_KEY = @"last_run_version_of_application";      // @"last_run_version_of_application"

NSString *const kAppLaunchNumber = @"AppLaunchNumber";


NSString *const Gua_Cache = @"Gua_Cache";
NSString *const Gua_Match_ChatModel_Cache = @"Gua_Match_ChatModel_Cache";
NSString *const Gua_Match_Match_Cache = @"Gua_Match_Match_Cache";
NSString *const Gua_Match_MatchConditions_Cache = @"Gua_Match_MatchConditions_Cache";
NSString *const Gua_Match_MatchTime_Cache = @"Gua_Match_MatchTime_Cache";
NSString *const Gua_Match_Like_Cache = @"Gua_Match_Like_Cache";//是否点击喜欢
NSString *const Gua_UserInfo_Cache = @"Gua_UserInfo_Cache";
NSString *const Gua_Cache_FriendList = @"Gua_Cache_FriendList";


// 自己的通过环信扩展的通知
NSString *const kGua_EXPAND_EXT_NAME = @"dataRes";

NSString *const kMESSAGE_COMMENT = @"MESSAGE_COMMENT";
NSString *const kCOMMENT_COMMENT = @"COMMENT_COMMENT";
NSString *const kMESSAGE_ZAN = @"MESSAGE_ZAN";
NSString *const kADD_FRIEND_ASK = @"ADD_FRIEND_ASK";
NSString *const kADD_FRIEND_AGREE = @"ADD_FRIEND_AGREE";
NSString *const kDELETE_FRIEND = @"BEEN_DELETE";
NSString *const kCHAT_START = @"CHAT_START";
NSString *const kCHAT_QUIT = @"CHAT_QUIT";
NSString *const kMATCH_PAIR = @"MATCH_PAIR";
NSString *const kGET_POINTS = @"GET_POINTS";
NSString *const kCER_CHK_RES = @"CER_CHK_RES";

NSString *const kMessageDidReceive = @"MessageDidReceive";

// 帖子发表成功
NSString *const kMessagePostSuccess = @"MessagePostSuccess";

// 自定义消息未读个数
NSString *const kCustomMessageUnreadCount = @"CustomMessageUnreadCount";

NSString *const kUserMessageUnreadCount = @"UserMessageUnreadCount";


//new:  x18ywvqfxcc6c
//old:  mgb7ka1nmdwtg
NSString *const kRongYunKey = @"x18ywvqfxcc6c";

NSString *const kQINIU_TokenKey = @"";

NSString *const kQINIU_HOSTKey = @"http://lhxq.top/";

NSString *const kWeChatPartnerId = @"1527643731";

NSString *const kWeChatAppId = @"wx502707dff6e8ce6c";

NSString *const kWeChatAppS = @"7968e86926fc96525807d0256edaadff";

NSString *const  kFaceIDKey = @"pEZrk6jsACf6cVL-W3L1AyJC-OA_RG-6";
NSString *const  kFaceIDSecret  = @"qjWK2Jzg46rOuDtz2Ew35zUlyFcmNRUp";


// 色值

NSString *const kIMNearByBtnBackgroundColor = @"FF5122";

NSString *const kIMDriftingBottleBtnBackgroundColor = @"ff9f70";

NSString *const kIMLoveSkillBtnBackgroundColor = @"03A9F4";

NSString *const kIMInviteFriendBtnBackgroundColor = @"4CAF50";


// 主动发消息 每天个数
NSInteger const kConstChatCount = 3; //3

// 一键打招呼 每天个数
 NSInteger const kConstSayHiCount = 1; //1


NSInteger const kConstPickBottleCount = 3; //1

NSInteger const kConstSendBottleCount = 3; //1

