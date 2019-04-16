//
//  NSString+Date.h
//  ChildEnd
//
//  Created by zhoushaowen on 2017/2/28.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

+ (instancetype)createStringWithDate:(NSDate *)date dateForma:(NSString *)format;
+ (instancetype)createStringWithMiliSecond:(NSString *)unknownSecond dateFormat:(NSString *)format;

+ (NSString *)stringWithTimeStamp:(NSNumber *)timeStamp;

+ (NSString *)timeStringWithTimeStamp:(NSNumber *)timeStamp;
+ (NSString *)dateStringWithTimeStamp:(NSNumber *)timeStamp;
+ (NSString *)dateStringWithTimeStamp:(NSNumber *)timeStamp dateFormat:(NSString *)dateFormat;

+ (NSString *)ageStringWithDate:(NSDate *)date;

- (NSDate *)sc_dateWithUTCString;

- (NSString *)sc_timeAgoWithUTCString;

@end
