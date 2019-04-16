//
//  PointsSkuExchange.h
//  SocialContact
//
//  Created by EDZ on 2019/3/7.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PointsSkuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PointsSkuExchange : NSObject

/*

 "id": 1,
 "sku": {
     "id": 1,
     "name": "卡爱的小瓜瓜",
     "cover_image": "http://lhxq.top/file/2019/02/27/4c315b9b98cf4b79a1f997d8be759e2b.jpeg",
     "description": "卡爱的小瓜瓜卡爱的小瓜瓜卡爱的小瓜瓜",
     "total": 10,
     "point": 1
 },
 "status": 0,
 "create_at": "2019-02-27T17:01:29.765811"
 
 */

INS_P_ASSIGN(NSInteger, iD);
INS_P_STRONG(PointsSkuModel *,sku);

/*
  0: 提交申请， 1：申请成功， 2： 申请被拒绝
 */
INS_P_ASSIGN(NSInteger, status);
INS_P_STRONG(NSString *,create_at);

@end

NS_ASSUME_NONNULL_END
