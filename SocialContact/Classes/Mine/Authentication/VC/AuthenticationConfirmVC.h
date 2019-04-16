//
//  AuthenticationConfirmVC.h
//  SocialContact
//
//  Created by EDZ on 2019/2/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "Ins_ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AuthenticationConfirmVCDelegate <NSObject>

@optional

- (void)backBtnClicked;

- (void)dismiss;

@end
@interface AuthenticationConfirmVC: InsViewController

@property(nonatomic,weak)id<AuthenticationConfirmVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
