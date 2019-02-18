//
//  ProductInfoModel.h
//  SocialContact
//
//  Created by EDZ on 2019/1/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 
 "pricelist": [
 {
 "name": " 会员7天",
 "days": 7,
 "price": 10
 }
 ],
 
 
 */
@interface ProductInfoModel : NSObject

INS_P_STRONG(NSString *,name);

INS_P_ASSIGN(NSInteger,days);

INS_P_ASSIGN(CGFloat,price);




@end

NS_ASSUME_NONNULL_END
