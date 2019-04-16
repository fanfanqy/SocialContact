//
//  NSDate+SCDate.h
//  SocialContact
//
//  Created by EDZ on 2019/3/31.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define SECOND    (1)
#define MINUTE    (60 * SECOND)
#define HOUR    (60 * MINUTE)
#define DAY        (24 * HOUR)
#define MONTH    (30 * DAY)
#define YEAR    (12 * MONTH)

@interface NSDate (SCDate)
- (NSString *)timeAgo;

@end

NS_ASSUME_NONNULL_END
