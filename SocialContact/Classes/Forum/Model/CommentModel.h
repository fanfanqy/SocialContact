//
//  CommentModel.h
//  SocialContact
//
//  Created by EDZ on 2019/1/12.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : NSObject

INS_P_ASSIGN(NSInteger, iD); // "id": 16,
INS_P_STRONG(SCUserInfo *,from_customer);
INS_P_ASSIGN(NSInteger, reply_to_id);
INS_P_STRONG(NSString *, text); // "text": "this is a title 2222333ww",
INS_P_STRONG(NSString *,create_at);
INS_P_STRONG(SCUserInfo *,to_customer);


@end

NS_ASSUME_NONNULL_END
