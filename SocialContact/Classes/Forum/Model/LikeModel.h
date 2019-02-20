//
//  LikeModel.h
//  SocialContact
//
//  Created by EDZ on 2019/2/19.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LikeModel : NSObject

INS_P_ASSIGN(NSInteger, iD);
INS_P_STRONG(NSString *, create_at);
INS_P_STRONG(SCUserInfo *,customer);
@end

NS_ASSUME_NONNULL_END
