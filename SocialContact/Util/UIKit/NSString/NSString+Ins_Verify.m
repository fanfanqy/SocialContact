//
//  NSString+Ins_Verify.m
//  AVInsurance
//
//  Created by Dylan on 2016/7/28.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "NSString+Ins_Verify.h"

@implementation NSString (InsVerify)

+ (BOOL) ins_String:(NSString *)string {

    if ( string == nil || string == NULL ) {
        return NO;
    }

    if ( [string isEqual:[NSNull null]] ) {
        return NO;
    }

    if ( string.length == 0 ) {
        return NO;
    }

    if ( ![string isKindOfClass:[NSString class]] ) {
        return NO;
    }

    return YES;
}

- (NSString *) ins_2zero {
    return [NSString stringWithFormat:@"%02zd", self.integerValue];
}

@end
