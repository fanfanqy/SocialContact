//
//  GeRenZiLiaoVC.h
//  SocialContact
//
//  Created by EDZ on 2019/1/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import "Ins_ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GeRenZiLiaoVC : InsViewController

INS_P_STRONG(SCUserInfo *, userModel);

/*
 0:个人资料
 1：完善个人信息
 */
INS_P_ASSIGN(NSInteger, vcType);

@end

NS_ASSUME_NONNULL_END
