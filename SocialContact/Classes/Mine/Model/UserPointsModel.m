//
//  UserPointsModel.m
//  SocialContact
//
//  Created by EDZ on 2019/1/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import "UserPointsModel.h"

@implementation UserPointsModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"iD": @"id",
             };
}

@end
