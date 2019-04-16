//
//  InviteFriendModel.m
//  SocialContact
//
//  Created by EDZ on 2019/3/1.
//  Copyright © 2019 ha. All rights reserved.
//

#import "InviteFriendModel.h"

@implementation InviteFriendModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"iD": @"id",
             };
}


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass; {
    return @{
             @"invited": [SCUserInfo class],
             };
}

@end
