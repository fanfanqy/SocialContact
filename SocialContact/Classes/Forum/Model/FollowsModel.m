//
//  FollowsModel.m
//  SocialContact
//
//  Created by EDZ on 2019/4/1.
//  Copyright © 2019 ha. All rights reserved.
//

#import "FollowsModel.h"

@implementation FollowsModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"iD": @"id",
             };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass; {
    return @{
             @"customer": [SCUserInfo class],
             };
}

@end
