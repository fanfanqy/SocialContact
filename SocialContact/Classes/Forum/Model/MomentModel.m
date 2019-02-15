//
//  MomentModel.m
//  SocialContact
//
//  Created by EDZ on 2019/1/12.
//  Copyright © 2019 ha. All rights reserved.
//

#import "MomentModel.h"

@implementation MomentModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"iD": @"id",
             };
}


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass; {
    return @{
             @"topic": [TopicModel class],
             @"images": [MomentImageModel class],
             @"from_customer": [SCUserInfo class],
             @"to_customer": [SCUserInfo class],
             };
}

@end
