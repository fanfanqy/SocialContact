//
//  ServiceModel.h
//  SocialContact
//
//  Created by EDZ on 2019/2/14.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServiceModel : NSObject
/*
 "id": 1,
 "pricelist": [
 {
 "name": " 会员7天",
 "days": 7,
 "price": 10
 }
 ],
 "service_type": 1,
 "name": "雪球会员",
 "detail": null,
 "create_at": "2019-01-18T13:49:12.317406"
*/

INS_P_ASSIGN(NSInteger,iD);

INS_P_STRONG(NSArray<ProductInfoModel *> *,pricelist);

INS_P_ASSIGN(NSInteger,service_type);

INS_P_STRONG(NSString *,name);

INS_P_STRONG(NSString *,detail);

INS_P_STRONG(NSString *,create_at);

@end

NS_ASSUME_NONNULL_END
