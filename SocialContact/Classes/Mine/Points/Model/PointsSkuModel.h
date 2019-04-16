//
//  PointsSkuModel.h
//  SocialContact
//
//  Created by EDZ on 2019/3/7.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PointsSkuModel : NSObject

/*
 
 "id": 1,
 "name": "卡爱的小瓜瓜",
 "cover_image": "http://lhxq.top/file/2019/02/27/4c315b9b98cf4b79a1f997d8be759e2b.jpeg",
 "description": "卡爱的小瓜瓜卡爱的小瓜瓜卡爱的小瓜瓜",
 "total": 10,
 "point": 10000
 
 */

INS_P_ASSIGN(NSInteger, iD);
INS_P_STRONG(NSString *,name);
INS_P_STRONG(NSString *,cover_image);
INS_P_STRONG(NSString *,des);
INS_P_ASSIGN(NSInteger, total);
INS_P_ASSIGN(NSInteger, point);

@end

NS_ASSUME_NONNULL_END
