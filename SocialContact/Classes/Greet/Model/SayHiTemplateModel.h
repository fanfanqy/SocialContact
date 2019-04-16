//
//  SayHiTemplateModel.h
//  SocialContact
//
//  Created by EDZ on 2019/3/29.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SayHiTemplateModel : NSObject

/*
 "id": 2,
 "text": "叫你一声逗比 你敢答应吗",
 "create_at": "2019-02-26T14:32:12.318809"
 */

INS_P_ASSIGN(NSInteger,iD);

INS_P_STRONG(NSString *,text);

INS_P_STRONG(NSString *,create_at);

@end

NS_ASSUME_NONNULL_END
