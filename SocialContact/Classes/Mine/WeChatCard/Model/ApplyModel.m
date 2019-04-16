//
//  ApplyModel.m
//  SocialContact
//
//  Created by EDZ on 2019/2/27.
//  Copyright © 2019 ha. All rights reserved.
//

#import "ApplyModel.h"

@implementation ApplyModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"iD": @"id",
             };
}


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass; {
    return @{
            
             @"customer": [SCUserInfo class],
             @"to_customer": [SCUserInfo class],
             };
}

@end
