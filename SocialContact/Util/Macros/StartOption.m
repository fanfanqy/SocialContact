//
//  StartOption.m
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "StartOption.h"

@implementation StartOption

static StartOption *option = nil;

+ (StartOption *) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( option == NULL ) {
            option = [[StartOption alloc] init];
            
        }
    });
    
    return option;
}


/**
 启动App
 */
+ (void) startAppWithOption: (InitialOption *) option{
    
}


+ (void) setProduct {
    // 切换到开发模式
    [StartOption sharedInstance]->_debugger = NO;
}

+ (void) setDebugger {
    // 切换到调试模式
    [StartOption sharedInstance]->_debugger = YES;
}

- (void) applyTheme {
    
    [UIApplication sharedApplication].keyWindow.tintColor = MAIN_COLOR_Blur;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"back_icon"];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back_icon"];
    [UINavigationBar appearance].tintColor = [UIColor colorWithHexString:@"333"];
    [UINavigationBar appearance].translucent = NO;
    
    [[UITableView appearance] setBackgroundColor:BackGroundColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName :[UIColor colorWithHexString:@"333"],
                                                           NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                                                           }];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = false;
    [SVProgressHUD setMinimumSize:CGSizeMake(100, 100)];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setMinimumDismissTimeInterval:5];
    [SVProgressHUD setMaximumDismissTimeInterval:10];
    
}

- (void) initFrameworks {
    
//    [AMapServices sharedServices].apiKey = self.option.gdConfig[GDKey];
//    [PPGetAddressBook requestAddressBookAuthorization];
//
//    [EZOpenSDKTool initEZOpenSDK];
    
}


@end
