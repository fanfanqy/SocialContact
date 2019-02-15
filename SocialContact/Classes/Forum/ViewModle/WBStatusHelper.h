//
//  WBFeedHelper.h
//  YYKitExample
//
//  Created by ibireme on 15/9/5.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

//#import "YYKit.h"
//#import "WBModel.h"
/**
 很多都写死单例了，毕竟只是 Demo。。
 */
@interface WBStatusHelper : NSObject

/// 将 date 格式化成微博的友好显示
+ (NSString *)stringWithTimelineDate:(NSDate *)date;


@end
