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
 */
INS_P_ASSIGN(NSInteger, iD); // "id": 16,
INS_P_STRONG(NSString *, text);
INS_P_STRONG(NSString *, create_at);

@end

NS_ASSUME_NONNULL_END
