//
//  ServiceModel.m
//  SocialContact
//
//  Created by EDZ on 2019/2/14.
//  Copyright © 2019 ha. All rights reserved.
//

#import "ServiceModel.h"

@implementation ServiceModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"iD": @"id",
             };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass; {
    return @{
             @"pricelist": [ProductInfoModel class]
             };
}
@end
