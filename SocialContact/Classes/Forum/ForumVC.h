//
//  ForumVC.h
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "Ins_ViewController.h"
#import "NewDynamicsLayout.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ForumVCType){
    ForumVCTypeMoment = 1, //  UI
    ForumVCTypeTopic = 2, // UI
    ForumVCTypeTopicSelect = 3,
    ForumVCTypeNoticeOrNearBy = 4,
    
};

typedef NS_ENUM(NSInteger,ForumVCGoToType){
    ForumVCTypeGoToMomentDetail = 1, // 进动态详情
    ForumVCTypeGoToUserHomePage = 2, // 进用户主页
};

@protocol ForumVCDelegate <NSObject>

@optional

- (void)topicSelected:(TopicModel *)topicModel;

@end


/**
 附近的人
 我关注的
 我的粉丝
 动态列表
 话题列表
 话题详情
 
 */
@interface ForumVC : InsViewController

@property(nonatomic,assign)MomentRequestType momentRequestType;

@property(nonatomic,assign)MomentUIType  momentUIType;

@property(nonatomic,assign)ForumVCType forumVCType;

@property(nonatomic,assign)CGFloat height;

@property(nonatomic,weak) id <ForumVCDelegate> delegate;

@property(nonatomic,strong)TopicModel *topicModel;

@property(nonatomic,strong)SCUserInfo *uesrInfo;

@property(nonatomic,strong)MomentModel *momentModel;

@property(nonatomic,assign)NSInteger momentId;

@property(nonatomic,weak)UIViewController *fatherVC;

- (void)clickComment:(NewDynamicsLayout *)layout;

- (void)fetchData:(BOOL)refresh;

- (void)fetchLikeUserData;

@property(nonatomic,strong) InsLoadDataTablView *tableView;

@end

NS_ASSUME_NONNULL_END
