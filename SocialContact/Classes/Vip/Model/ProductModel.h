//
//  ProductModel.h
//  SocialContact
//
//  Created by EDZ on 2019/1/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 
 // 购买的项目
 "id": 1,
 "virtual_service": {
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
 },
 "expired_at": "2019-02-24T12:46:26.840845",
 "create_at": "2019-01-25T12:46:26.809115",
 "expired": false
 
 // 收费的项目
 "results": [
 {
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
 }
 ]
 */

@interface ProductModel : NSObject

INS_P_ASSIGN(NSInteger,iD);

INS_P_STRONG(NSArray<ServiceModel *> *,virtual_service);

INS_P_STRONG(NSString *,expired_at);

INS_P_STRONG(NSString *,create_at);

INS_P_ASSIGN(BOOL,expired);

@end

NS_ASSUME_NONNULL_END
