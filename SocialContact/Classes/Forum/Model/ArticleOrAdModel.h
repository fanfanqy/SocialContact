//
//  ArticleOrAdModel.h
//  SocialContact
//
//  Created by EDZ on 2019/2/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 文章、广告
 */
@interface ArticleOrAdModel : NSObject

/*
 
 "category": 2,
 "headline": "雪球平台上线了",
 "content": "全球最大的相亲平台上线了",
 "create_at": "2019-01-25T17:59:53.514205"
 
 */

INS_P_ASSIGN(NSInteger, category);
INS_P_STRONG(NSString *, headline);
INS_P_STRONG(NSString *, content);
INS_P_STRONG(NSString *, create_at);
INS_P_STRONG(NSString *, bgimage_url);

@end

NS_ASSUME_NONNULL_END
