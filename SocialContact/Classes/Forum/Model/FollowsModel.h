//
//  FollowsModel.h
//  SocialContact
//
//  Created by EDZ on 2019/4/1.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUserInfo.h"
NS_ASSUME_NONNULL_BEGIN

/*
 关注，粉丝
 */
@interface FollowsModel : NSObject

/*
 1：正在关注， 2：互相关注
 */
INS_P_ASSIGN(NSInteger, status);
INS_P_ASSIGN(NSInteger, iD);
INS_P_STRONG(SCUserInfo *,customer);
INS_P_STRONG(NSString *, create_at);

@end

NS_ASSUME_NONNULL_END
