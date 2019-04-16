//
//  PointsSkuModel.m
//  SocialContact
//
//  Created by EDZ on 2019/3/7.
//  Copyright © 2019 ha. All rights reserved.
//

#import "PointsSkuModel.h"

@implementation PointsSkuModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"iD": @"id",
             @"des":@"description",
             };
}

@end
