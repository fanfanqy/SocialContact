//
//  Notice.h
//  SocialContact
//
//  Created by EDZ on 2019/2/15.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUserInfo.h"

NS_ASSUME_NONNULL_BEGIN
/*
 
 "id": 3,
 "action_type": 3,
 "object_id": 16,
 "result_id": 15,
 "from_customer": {
 "id": 3,
 "user_id": 3,
 "name": "frankie",
 "age": null,
 "gender": 0,
 "avatar_url": "",
 "im_token": "sSSi/utmY8FOQ82JfQEsHcSHwO0LfRde21ZRgMdXUZyqqdCxNhANotgmugOMgnY/KQOkFmVe5V4="
 },
 "create_at": "2018-12-26T18:02:38.880544",
 "text": "frankie回复了你的评论",
 "status": 1
 
 */

@interface Notice : NSObject

INS_P_ASSIGN(NSInteger, iD);
INS_P_ASSIGN(NSInteger, action_type);
INS_P_ASSIGN(NSInteger, object_id);
INS_P_ASSIGN(NSInteger, result_id);
INS_P_STRONG(SCUserInfo *, from_customer);

INS_P_STRONG(NSString *, create_at);
INS_P_STRONG(NSString *, text);
INS_P_ASSIGN(NSInteger, status);



@end

NS_ASSUME_NONNULL_END
