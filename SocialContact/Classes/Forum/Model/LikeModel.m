//
//  LikeModel.m
//  SocialContact
//
//  Created by EDZ on 2019/2/19.
//  Copyright © 2019 ha. All rights reserved.
//

#import "LikeModel.h"

@implementation LikeModel

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
