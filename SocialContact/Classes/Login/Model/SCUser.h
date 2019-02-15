//
//  SCUser.h
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUserInfo.h"


NS_ASSUME_NONNULL_BEGIN

@interface SCUser : NSObject
/*
"user_id": 2,
"name": "",
"im_token": ""
*/

INS_P_ASSIGN(NSInteger, user_id);

INS_P_STRONG(NSString *, name);

INS_P_STRONG(NSString *, im_token);

INS_P_STRONG(SCUserInfo *, userInfo);

INS_P_STRONG(NSString *, XCSRFToken);
@end

NS_ASSUME_NONNULL_END
