//
//  InviteFriendModel.h
//  SocialContact
//
//  Created by EDZ on 2019/3/1.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteFriendModel : NSObject

/*
 
 "id": 1,
 "invited": {
 "id": 9,
 "name": "",
 "age": null,
 "gender": 0,
 "avatar_url": ""
 },
 "platform": 0,
 "create_at": "2019-01-30T15:21:58.513315"
 
 */

INS_P_ASSIGN(NSInteger, iD); 
INS_P_ASSIGN(NSInteger, platform);
INS_P_STRONG(SCUserInfo *,invited);
INS_P_STRONG(NSString *,create_at);

@end

NS_ASSUME_NONNULL_END
