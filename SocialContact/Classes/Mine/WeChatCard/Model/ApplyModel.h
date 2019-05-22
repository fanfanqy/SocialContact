//
//  ApplyModel.h
//  SocialContact
//
//  Created by EDZ on 2019/2/27.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 <#Description#>
 */
@interface ApplyModel : NSObject

/*
"id": 5,
"customer": {
    "id": 1,
    "name": "Friends of Girl",
    "age": null,
    "gender": 0,
    "avatar_url": ""
},
 
 "status": 1, // 0：未处理， 1：接收， 2:拒绝
"create_at": "2019-02-26T11:58:15.737995"
*/

INS_P_ASSIGN(NSInteger, iD); // "id": 16,
INS_P_ASSIGN(NSInteger, status);

INS_P_STRONG(SCUserInfo *,customer);
INS_P_STRONG(SCUserInfo *,to_customer);
INS_P_STRONG(SCUserInfo *,accepted_customer);
INS_P_STRONG(NSString *, wechat);

INS_P_STRONG(NSString *, create_at);



@end

NS_ASSUME_NONNULL_END
