//
//  BottleModel.h
//  SocialContact
//
//  Created by EDZ on 2019/1/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BottleModel : NSObject

/*
 "id": 14,
 "text": "002的漂流瓶9",
 "create_at": "2019-01-22T22:11:48.996362"
 "customer": {
 "id": 1,
 "user_id": 1,
 "name": "Friends of Girl",
 "age": 18,
 "gender": 0,
 "avatar_url": "",
 "account": "18258180000",
 "im_token": "hmTGk4J+opIKDoxq8wTfHukaTe/VZ0hmtuyL1XcfdKU/HLVk/nMaZ0yWIdKzb8mbaggovssGiIpwntpEcn1ioQ=="
 }
 */
INS_P_ASSIGN(NSInteger, iD); // "id": 16,
INS_P_STRONG(NSString *, text);
INS_P_STRONG(NSString *, create_at);

// 捡瓶子，我捡到的瓶子包含的用户信息
INS_P_STRONG(SCUserInfo *, customer);

/*
 捡的瓶子不要了，不能加入无限聊天列表
 */
INS_P_ASSIGN(BOOL, isAbandon);

@end

NS_ASSUME_NONNULL_END
