//
//  AppDelegate+ThirdLibraryConfig.h
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (ThirdLibraryConfig)<MapManagerLocationDelegate>



- (void)thirdLibraryApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
               otherOptions:(InitialOption *)initialOption;
@end

NS_ASSUME_NONNULL_END
