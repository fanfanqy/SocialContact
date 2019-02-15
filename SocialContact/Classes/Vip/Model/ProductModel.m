//
//  ProductModel.m
//  SocialContact
//
//  Created by EDZ on 2019/1/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"iD": @"id",
             };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass; {
    return @{
             @"virtual_service": [ServiceModel class]
             };
}
    
@end
