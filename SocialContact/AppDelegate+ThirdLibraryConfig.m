//
//  AppDelegate+ThirdLibraryConfig.m
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "AppDelegate+ThirdLibraryConfig.h"

@implementation AppDelegate (ThirdLibraryConfig)

- (void)thirdLibraryApplication:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                   otherOptions:(InitialOption *)initialOption{
    
    [self applyTheme];
    
    [self mapManager];
}

- (void)mapManagerConfig{
    self.mapManager = [MapManager new];
    self.mapManager.delegate = self;
    [self.mapManager start];
}

#pragma mark 定位
- (void)mapManager:(MapManager *)manager didUpdateAndGetLastCLLocation:(CLLocation *)location{
    [SCUserCenter sharedCenter].currentUser.userInfo.latitude = location.coordinate.latitude;
    [SCUserCenter sharedCenter].currentUser.userInfo.longitude = location.coordinate.longitude;
}

- (void)mapManager:(MapManager *)manager didReverseCLLocation:(CLPlacemark *)placemark{
    [SCUserCenter sharedCenter].currentUser.userInfo.placemark = placemark;
    NSDictionary *addressDic = placemark.addressDictionary;
    NSString *state=[addressDic objectForKey:@"State"];
    NSString *city = placemark.locality;
    if (!city) {
        city = placemark.administrativeArea;//四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
    }
    NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
    NSString *street=[addressDic objectForKey:@"Street"];
    if (!subLocality) {
        subLocality = @"";
    }
    if (!street) {
        street = @"";
    }
    [SCUserCenter sharedCenter].currentUser.userInfo.myLocation = [NSString stringWithFormat:@"%@%@%@%@",state?:@"",city?:@"",subLocality?:@"",street?:@""];
  
}

- (void)mapManager:(MapManager *)manager didFailed:(NSError *)error{
    [self.mapManager start];
}

- (void)mapManagerServerClosed:(MapManager *)manager{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"无法使用定位服务，允许访问位置信息以便为您推荐身边的帅哥、美女" message:@"请在iPhone的\"设置-隐私-定位服务-郸城红娘\"中允许访问位置信息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alertC dismissViewControllerAnimated:YES completion:^{
            // 打电话
            
        }];
    }];
    [alertC addAction:action];
    [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
    
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
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = false;
    [SVProgressHUD setMinimumSize:CGSizeMake(100, 100)];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setMaximumDismissTimeInterval:4];
}

@end
