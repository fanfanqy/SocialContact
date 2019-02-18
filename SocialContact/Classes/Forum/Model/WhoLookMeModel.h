//
//  WhoLookMeModel.h
//  SocialContact
//
//  Created by EDZ on 2019/2/16.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface WhoLookMeModel : NSObject

INS_P_STRONG(SCUserInfo *, customer);
INS_P_STRONG(NSString *, create_at);

@end

NS_ASSUME_NONNULL_END
