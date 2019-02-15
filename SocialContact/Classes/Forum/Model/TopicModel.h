//
//  TopicModel.h
//  SocialContact
//
//  Created by EDZ on 2019/1/12.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopicModel : NSObject

/*
 "id": 1,
 "name": "群聊asd",
 "logo_url": "https://pic1.zhimg.com/80/v2-d843fad58b419c499932a6e2105b3e04_hd.jpg",
 "create_at": "2018-12-30T21:01:35.851049"
 */

INS_P_ASSIGN(NSInteger, iD);
INS_P_STRONG(NSString *, name);
INS_P_STRONG(NSString *, logo_url);
INS_P_STRONG(NSString *, create_at);
INS_P_STRONG(NSString *, desc);
INS_P_ASSIGN(NSInteger, order_num);


@end

NS_ASSUME_NONNULL_END
