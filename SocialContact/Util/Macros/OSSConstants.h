//
//  Constant.h
//  AliyunOSSiOS
//
//  Created by jingdan on 2017/9/8.
//  Copyright © 2017年 zhouzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const BUCKET_NAME;
extern NSString* const UPLOAD_OBJECT_KEY;
extern NSString* const DOWNLOAD_OBJECT_KEY;
extern NSString* const endPoint;
extern NSString* const imageEndPoint;
extern NSString* const callbackAddress;
extern NSString* const STS_AUTH_URL;

extern NSString* const OSSStyle;

extern NSString* const GDAppKey;

extern NSString *const HOST;
extern NSInteger const RequestTimeoutInterval;
extern NSInteger const kRequest_OK;
/**
 DEBUG 下，请求出错，可能客户端请求写错，或服务器错误
 发布 下，服务器错误，前提是测试阶段已测试接口无错误
 */
extern NSString *const kServerBusyAlert; //@"请求出错" //@"服务器忙，请稍后再试"



extern NSInteger const kNickNameMaxWords; //20
extern NSInteger const kSelfIntroduceMaxWords; //100


extern NSString *const HXAppKey;// @"1142180504177015#guagua"
extern NSString *const HXPushName;
/* 搜索历史 */
extern NSString *const GuaSEARCH_SEARCH_HISTORY_CACHE_PATH;// @"GuaSEARCH_SEARCH_HISTORY_CACHE_PATH"
extern NSString *const LAST_RUN_VERSION_KEY;      // @"last_run_version_of_application"

// APP 设置
extern NSString *const kAppLaunchNumber;

/* cache */
extern NSString *const Gua_Cache;
extern NSString *const Gua_Match_ChatModel_Cache;
extern NSString *const Gua_Match_Match_Cache;
extern NSString *const Gua_Match_MatchConditions_Cache;
extern NSString *const Gua_Match_MatchTime_Cache;
extern NSString *const Gua_Match_Like_Cache;
extern NSString *const Gua_UserInfo_Cache;
extern NSString *const Gua_Cache_FriendList;

extern NSString *const kGua_EXPAND_EXT_NAME;
extern NSString *const kMESSAGE_COMMENT;
extern NSString *const kCOMMENT_COMMENT;
extern NSString *const kMESSAGE_ZAN;
extern NSString *const kADD_FRIEND_ASK;
extern NSString *const kADD_FRIEND_AGREE;
extern NSString *const kDELETE_FRIEND;
extern NSString *const kCHAT_START;
extern NSString *const kCHAT_QUIT;
extern NSString *const kMATCH_PAIR;
extern NSString *const kGET_POINTS;
extern NSString *const kCER_CHK_RES;

extern NSString *const kMessageDidReceive;

// 发表成功的通知
extern NSString *const kMessagePostSuccess;

extern NSString *const kCustomMessageUnreadCount;

extern NSString *const kUserMessageUnreadCount;


// token

extern NSString *const kRongYunKey;
extern NSString *const kQiNiuTokenKey;
extern NSString *const kQINIU_HOSTKey;


// 色值
extern NSString *const kIMNearByBtnBackgroundColor;

extern NSString *const kIMDriftingBottleBtnBackgroundColor;

extern NSString *const kIMLoveSkillBtnBackgroundColor;

extern NSString *const kIMInviteFriendBtnBackgroundColor;
