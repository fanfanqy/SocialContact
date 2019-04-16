//
//  InviteInfoModel.h
//  SocialContact
//
//  Created by EDZ on 2019/3/29.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteInfoModel : NSObject


/*
 {
 "msg": "OK",
 "data": {
 "invited_count": 2,
 "customer_buy_count": 0,
 "toatl_available": 6,
 "total_handing": 1,
 "total_changed": 1
 }
 }
 invited_count    int    邀请人数
 customer_buy_count    int    邀请人购买服务的人数
 total_available    int    可用金额
 total_handing    int    正在处理的提现数量
 total_changed    int    已兑换
 */

INS_P_ASSIGN(NSInteger, invited_count);
INS_P_ASSIGN(NSInteger, customer_buy_count);
INS_P_ASSIGN(CGFloat, total_available);
INS_P_ASSIGN(CGFloat, total_handing);
INS_P_ASSIGN(CGFloat, total_changed);

@end

NS_ASSUME_NONNULL_END
