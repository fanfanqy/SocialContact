//
//  WechatOrderModel.h
//  SocialContact
//
//  Created by EDZ on 2019/3/12.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WechatOrderModel : NSObject

/*
 
 {
 "msg": "OK",
 "data": {
 "order_string": {
 
 "appid": "wx502707dff6e8ce6c",
 "partnerid": "1527643731",
 "prepayid": "wx1622001805251087cf297fa50355217185",
 "noncestr": "2bzYAziZHufOkfFm",
 "timestamp": "1552744818",
 "package": "Sign=WXPay",
 "sign": "A3863536F3BF1ACDA962E3981A53DDEC"
 
 }
 }
 }
 
 */

INS_P_STRONG(NSString *,appid);
INS_P_STRONG(NSString *,partnerid);
INS_P_STRONG(NSString *,prepayid);
INS_P_STRONG(NSString *,noncestr);
INS_P_STRONG(NSString *,timestamp);
INS_P_STRONG(NSString *,package);
INS_P_STRONG(NSString *,sign);




@end

NS_ASSUME_NONNULL_END
