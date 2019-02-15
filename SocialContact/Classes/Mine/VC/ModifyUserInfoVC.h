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
    ModifyTypeNickName,
    ModifyTypeSelfIntroduce,
};

NS_ASSUME_NONNULL_BEGIN

@interface ModifyUserInfoVC : InsViewController


@property (assign, nonatomic) ModifyType modifyType;

@property (strong, nonatomic) SCUserInfo *userInfo;

@end

NS_ASSUME_NONNULL_END
