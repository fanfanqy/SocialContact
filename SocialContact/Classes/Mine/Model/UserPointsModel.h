//
//  UserPointsModel.h
//  SocialContact
//
//  Created by EDZ on 2019/1/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 
 "id": 3,
 "desc": "兑换",
 "amount": 10,
 "total_left": 30,
 "in_or_out": 0,
 "create_at": "2019-01-26T12:39:19.544840"
 
 */

@interface UserPointsModel : NSObject

INS_P_ASSIGN(NSInteger, iD); // "id": 16,
INS_P_STRONG(NSString *, desc);
INS_P_ASSIGN(NSInteger, amount);
INS_P_ASSIGN(NSInteger, total_left);
INS_P_ASSIGN(NSInteger, in_or_out);
INS_P_STRONG(NSString *, create_at);

@end

NS_ASSUME_NONNULL_END
