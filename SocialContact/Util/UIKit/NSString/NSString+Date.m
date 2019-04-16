//
//  NSString+Date.m
//  ChildEnd
//
//  Created by zhoushaowen on 2017/2/28.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "NSString+Date.h"

#define aYeay  (3600 * 24 * 365)
#define aMonth (3600 * 24 * 30)
#define aDay   (3600 * 24)
#define anHour  3600
#define aMinute 60


@implementation NSString (Date)

+ (instancetype)createStringWithDate:(NSDate *)date dateForma:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

+ (instancetype)createStringWithMiliSecond:(NSString *)unknownSecond dateFormat:(NSString *)format {
    if([unknownSecond isKindOfClass:[NSNumber class]]){
        unknownSecond = [NSString stringWithFormat:@"%@",unknownSecond];
    }
    if(unknownSecond.length < 1) return @"";
    NSTimeInterval second = [unknownSecond doubleValue];
    if(unknownSecond.length == 13){//毫秒
        second /= 1000;
    }else if (unknownSecond.length == 10){//秒
        //不处理
    }else if(unknownSecond.length > 13){
        second /= pow(10, unknownSecond.length - 13)*1000;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    return [self createStringWithDate:date dateForma:format];
}


+ (NSString *)stringWithTimeStamp:(NSNumber *)timeStamp {
    
    if (timeStamp.integerValue == 0) {
        return @"未测量";
    }
    
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    //将当前时间转化为时间戳
    NSTimeInterval currentDateStamp = [currentDate timeIntervalSince1970];
    //将传入的参数转化为时间戳
    double dateStamp = [timeStamp doubleValue] / 1000;
    //计算时间间隔，即当前时间减去传入的时间
    double interval = currentDateStamp - dateStamp;
    
    if (interval < 1 * aMinute) {
        //在1分钟之前
        return @"刚刚";
    } else if (interval > aDay) {
        //已经超过一天（昨天）
        if (interval > aYeay) {
            return [NSString stringWithFormat:@"%.0f年前",(currentDateStamp - dateStamp) / aYeay];
        }
        if (interval > aMonth) {
            return [NSString stringWithFormat:@"%.0f个月前",(currentDateStamp - dateStamp) / aMonth];
        }
        return [NSString stringWithFormat:@"%.0f天前",(currentDateStamp - dateStamp) / aDay];
    } else if (interval < anHour) {
        //一个小时之内
        return [NSString stringWithFormat:@"%.0f分钟前", (currentDateStamp - dateStamp) / aMinute];
    } else {
        //今天之内
        return [NSString stringWithFormat:@"%.0f小时前", (currentDateStamp - dateStamp) / anHour];
    }
}

+ (NSString *)timeStringWithTimeStamp:(NSNumber *)timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp unsignedLongLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    return [formatter stringFromDate:date];
}

+ (NSString *)dateStringWithTimeStamp:(NSNumber *)timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp unsignedLongLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    return [formatter stringFromDate:date];
}

+ (NSString *)dateStringWithTimeStamp:(NSNumber *)timeStamp dateFormat:(NSString *)dateFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp unsignedLongLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:date];
}

+ (NSString *)ageStringWithDate:(NSDate *)date {
  
    //计算时间搓
    NSTimeInterval currentDateStamp = [[NSDate date] timeIntervalSinceDate:date];
    return [NSString stringWithFormat:@"%d",(int)(currentDateStamp / aYeay) + 1];
}

- (NSDate *)sc_dateWithUTCString{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [formatter setTimeZone:timeZone];
    });
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]; //输入格式
    NSDate *date = [formatter dateFromString:self];
    //有2种Format，在测试接口中
    if (date) {
        return date;
        
    }else{
        //输入格式
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *date1 = [formatter dateFromString:self];
        if (date1) {
            return date1;
        }else{
            
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS"];
            NSDate *date2 = [formatter dateFromString:self];
            return date2;
        }
    }
    return nil;
}

- (NSString *)sc_timeAgoWithUTCString{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [formatter setTimeZone:timeZone];
    });
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]; //输入格式
    NSDate *date = [formatter dateFromString:self];
    //有2种Format，在测试接口中
    if (date) {
        //NSLog(@"date:%@",date);
        return [date timeAgo];
       
    }else{
        //输入格式
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *date1 = [formatter dateFromString:self];
        if (date1) {
           return [date1 timeAgo];
        }else{
            
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS"];
            NSDate *date2 = [formatter dateFromString:self];
            return [date2 timeAgo];
        }
    }
    return self;
}
@end
