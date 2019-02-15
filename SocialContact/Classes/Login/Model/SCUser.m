//
//  SCUser.m
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "SCUser.h"

@implementation SCUser

+ (NSString *)getTableName {
    return @"_SCUser";
}

- (void)setUserInfo:(SCUserInfo *)userInfo{
    
    _userInfo = userInfo;
}

@end
