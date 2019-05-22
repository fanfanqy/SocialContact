//
//  AuthenticationVC.h
//  SocialContact
//
//  Created by EDZ on 2019/2/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "Ins_ViewController.h"
#import "DemoMegNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthenticationVC : InsViewController

INS_P_STRONG(SCUserInfo *, userModel);

// 1: 进入软件使用界面
// 
INS_P_ASSIGN(NSInteger, type);

@end

NS_ASSUME_NONNULL_END
