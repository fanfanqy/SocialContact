//
//  NSDate+SCDate.m
//  SocialContact
//
//  Created by EDZ on 2019/3/31.
//  Copyright © 2019 ha. All rights reserved.
//

#import "NSDate+SCDate.h"

@implementation NSDate (SCDate)

- (NSString *)timeAgo
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    
#pragma mark TODO 本项目返回的是北京时间8个小时
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self]+8*60*60;
    if (delta < 1 * MINUTE)
    {
        return @"刚刚";
    }
    else if (delta < 2 * MINUTE)
    {
        return @"1分钟前";
    }
    else if (delta < 45 * MINUTE)
    {
        int minutes = floor((double)delta/MINUTE);
        return [NSString stringWithFormat:@"%d分钟前", minutes];
    }
    else if (delta < 90 * MINUTE)
    {
        return @"1小时前";
    }
    else if (delta < 24 * HOUR)
    {
        int hours = floor((double)delta/HOUR);
        return [NSString stringWithFormat:@"%d小时前", hours];
    }else if ([self isToday]) {
        
        [formatter setDateFormat:@"HH:mm"];
        NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:self]];
        return [NSString stringWithFormat:@"今天%@",date];
        
    }else if ([self isYesterday])
    {
        [formatter setDateFormat:@"HH:mm"];
        NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:self]];
        return [NSString stringWithFormat:@"昨天%@",date];
        
    }else if ([self isYear])
    {
        //        int months = floor((double)delta/MONTH);
        //        return months <= 1 ? @"1个月前" : [NSString stringWithFormat:@"%d个月前", months];
        [formatter setDateFormat:@"M-d HH:mm"];
        NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:self]];
        return [NSString stringWithFormat:@"%@",date];
    }
    
    [formatter setDateFormat:@"yyyy-M-d HH:mm"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:self]];
    return [NSString stringWithFormat:@"%@",date];
    
}

@end
