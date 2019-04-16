//
//  ModifyUserInfoVC.h
//  SocialContact
//
//  Created by EDZ on 2019/1/19.
//  Copyright © 2019 ha. All rights reserved.
//

#import "Ins_ViewController.h"
#import "SCUserInfo.h"

typedef NS_ENUM(NSInteger,ModifyType){
    ModifyTypeNickName, // 昵称
    ModifyTypeSelfIntroduce, // 个人介绍
    ModifyTypeWeChat, // 个人微信修改
};

NS_ASSUME_NONNULL_BEGIN

/**
 个人信息修改
 */
@interface ModifyUserInfoVC : InsViewController


@property (assign, nonatomic) ModifyType modifyType;

@property (strong, nonatomic) SCUserInfo *model;

@end

NS_ASSUME_NONNULL_END
