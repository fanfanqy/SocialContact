//
//  AppDelegate.h
//  SocialContact
//
//  Created by EDZ on 2019/1/7.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfigModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MapManager *mapManager;

@property (strong, nonatomic) AppConfigModel *appConfigModel;

+(AppDelegate *)sharedDelegate;

- (void)configRootVC;

/*
 漂流瓶聊天列表
 */
@property (strong, nonatomic) NSMutableArray *isBottleCharts;

@end

