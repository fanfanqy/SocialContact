//
//  CommentListModel.h
//  SocialContact
//
//  Created by EDZ on 2019/1/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentListModel : NSObject

/*
"count": 3,
"next": null,
"previous": null,
"page_count": 1,
"results": [
            {
                "id": 7,
                "from_customer": {
                    "id": 3,
                    "user_id": 3,
                    "name": "",
                    "age": null,
                    "gender": 0,
                    "avatar_url": "",
                    "im_token": "sSSi/utmY8FOQ82JfQEsHcSHwO0LfRde21ZRgMdXUZyqqdCxNhANotgmugOMgnY/KQOkFmVe5V4="
                },
                "reply_to_id": null,
                "text": "this is a comment",
                "create_at": "2018-12-24T23:48:07.109714",
                "to_customer": null
            },
 ]
            */
INS_P_ASSIGN(NSInteger,count);
INS_P_STRONG(NSString *,next);
INS_P_STRONG(NSString *,previous);
INS_P_ASSIGN(NSInteger,page_count);
INS_P_STRONG(NSArray<CommentModel *> *,results);

@end

NS_ASSUME_NONNULL_END
