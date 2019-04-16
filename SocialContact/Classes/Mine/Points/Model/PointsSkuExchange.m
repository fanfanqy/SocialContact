//
//  PointsSkuExchange.m
//  SocialContact
//
//  Created by EDZ on 2019/3/7.
//  Copyright © 2019 ha. All rights reserved.
//

#import "PointsSkuExchange.h"

@implementation PointsSkuExchange

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"iD": @"id",
             };
}

// 数组下 含有深层结构对应关系
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass; {
    return @{
             @"sku": [PointsSkuModel class],
             };
}

@end
