//
//  SCUserInfo.m
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "SCUserInfo.h"

@implementation SCUserInfo

+ (NSString *)getTableName {
    return @"_SCUserInfo";
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"iD": @"id",
             };
}

- (BOOL)isOnlineSwitch{
    AppConfigModel *model = [AppDelegate sharedDelegate].appConfigModel;
    if (model) {
        return model.isOnlineSwitch;
    }
    return NO;
}

@end
