//
//  AppDelegate.h
//  SocialContact
//
//  Created by EDZ on 2019/1/7.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MapManager *mapManager;

+(AppDelegate *)sharedDelegate;

- (void)configRootVC;

@end

