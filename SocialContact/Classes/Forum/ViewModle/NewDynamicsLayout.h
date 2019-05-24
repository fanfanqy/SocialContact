//
//  NewDynamicsLayout.h
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/27.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MomentModel.h"
#import "LikeModel.h"

#define GuaFriendCircleTopicName @"topic"

typedef NS_ENUM(NSInteger,MomentUIType){
	MomentUITypeList = 1, // 列表 UI
	MomentUITypeDetail = 2, //详情 UI
	MomentUITypeMineList = 3,// 个人列表 UI
    MomentUITypeNearby = 4, // 附近的人，谁看过我，我的粉丝，我的关注
    MomentUITypeNotice = 5, // 通知
    MomentUITypeActivity = 6, // 活动
    MomentUITypeAskWeChatOrYueTa = 21, // 交换微信、约她
    MomentUITypePointsStore = 22, // 积分商城
};

typedef NS_ENUM(NSInteger,MomentRequestType){
    MomentRequestTypeNewest = 1,// 最新动态，进动态详情
    MomentRequestTypeSearch = 2,// 搜索动态，进动态详情
    MomentRequestTypeFollow = 3,// 关注的动态列表，进动态详情
    MomentRequestTypeMyList = 4,// 我的动态详情，进动态详情
    MomentRequestTypeUserList = 5,//他人的动态列表，进动态详情
    MomentRequestTypeMyMomentDetail = 6,//自己的动态详情
    MomentRequestTypeUserMomentDetail = 7,//他人的动态详情
    MomentRequestTypeNearby = 8,//附近的人 ，进用户主页
    MomentRequestTypeVisitors = 9,//谁看过我 ，进用户主页
    MomentRequestTypeSkill = 10, // 技能，进用户主页
    MomentRequestTypeUnknow = 11, // 陌生人，进用户主页
    MomentRequestTypeRecentlyUser = 12,// 最近使用用户，进用户主页
    MomentRequestTypeTopicList = 13, // 话题列表，进动态详情
    MomentRequestTypeFollowMe = 14,// 我的粉丝
    MomentRequestTypeFollows = 15,// 我关注的
    MomentRequestTypeTop = 16,// 置顶用户
    MomentRequestTypeNotice = 17,// 通知，消息列表
    MomentRequestTypeWhoLookMe = 18, // 谁看过我
    MomentRequestTypeJiFenList = 19, // 积分列表
    MomentRequestTypeActivity = 20, // 活动
    MomentRequestTypeAskWeChatSend = 21, // 交换微信、约她
    MomentRequestTypeAskWeChatReceived = 22, // 交换微信、约她
    MomentRequestTypeYueTaSend = 23, // 交换微信、约她
    MomentRequestTypeYueTaReceived = 24, // 交换微信、约她
    MomentRequestTypePointSkus = 25,// 积分商品列表
    MomentRequestTypePointSkusExchages = 26,// 我的兑换记录
    MomentRequestTypeBothFollowing = 27,// 互相关注
    MomentRequestTypeAskWeChatCard = 28, // 微信名片
    
};


static CGFloat const kMomentContentInsetLeft = 15;
static CGFloat const kMomentContentInsetTop = 20;
static CGFloat const kMomentContentInsetRight = 15;
static CGFloat const kMomentContentInsetBootm = 15;

static CGFloat const kMomentAvatarRightNickLeft = 15;

static CGFloat const kMomentAvatarBottomContentTop = 5;

static CGFloat const kMomentContentBottomPhotoContainTop =20;

static CGFloat const kMomentPhotoContainBottomTopicTop =20;

static CGFloat const kMomentPortraitWH =44;

static CGFloat const kDynamicsLineSpacing = 6;

static CGFloat const kDynamicsSectionViewHeight = 6;


typedef void(^ClickUserBlock)(NSString * user_Id);
typedef void(^ClickUrlBlock)(NSString * url);
typedef void(^ClickPhoneNumBlock)(NSString * phoneNum);

@interface NewDynamicsLayout : NSObject

/**
 <#Description#>
 */
@property (assign, nonatomic) BOOL shouldResetLayout;

/**
 <#Description#>
 */
@property(nonatomic,strong)MomentModel * model;

/**
 <#Description#>
 */
@property (assign, nonatomic)MomentUIType momentUIType;

/**
 <#Description#>
 */
@property (assign, nonatomic)MomentRequestType momentRequestType;

/**
 <#Description#>
 */
@property(nonatomic,strong)YYTextLayout * contentLayout;

@property(nonatomic,assign)CGFloat contentHeight;

/**
 <#Description#>
 */
@property (strong, nonatomic) NSString *formatedTimeString;

/**
 <#Description#>
 */
@property(nonatomic,assign)CGSize photoContainerSize;
@property(nonatomic,assign)CGFloat itemWidth;
@property(nonatomic,assign)CGFloat itemHeight;
@property(nonatomic,assign)NSInteger perRowItemCount;
/**
 <#Description#>
 */
@property(nonatomic,strong)NSMutableArray *photosUrlsArray;

/**
 点赞人员
 */
@property(nonatomic,strong)YYTextLayout * zanUsersLayout;

@property(nonatomic,strong)NSMutableArray * zanUsers;

@property(nonatomic,assign)CGFloat zanUsersHeight;

/**
 评论
 */
@property(nonatomic,strong)NSMutableArray * commentLayoutArr;


/**
 点赞区域高度
 */
@property(nonatomic,assign)CGFloat commentHeight;

/**
 <#Description#>
 */
@property(nonatomic,assign)CGFloat height;

/**
 <#Description#>
 */
- (instancetype)initWithModel:(MomentModel *)model momentUIType:(MomentUIType)momentUIType momentRequestType:(MomentRequestType)momentRequestType;

/**
 <#Description#>
 */
- (void)resetLayout;

@end

@interface CommentLayout : NSObject

@property(nonatomic,strong)CommentModel * model;

@property(nonatomic,strong)YYTextLayout * commentLayout;

@property(nonatomic,strong)YYTextLayout * nickNameLayout;

@property(nonatomic,assign)CGFloat commentHeight;

@property(nonatomic,assign)CGFloat height;

- (instancetype)initWithModel:(CommentModel *)model;

- (void)resetLayout;

@end

