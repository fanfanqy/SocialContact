//
//  NSString+Ins_Verify.h
//  AVInsurance
//
//  Created by Dylan on 2016/7/28.
//  Copyright © 2016年 Dylan. All rights reserved.
//



@interface NSString (InsVerify)

/**
 是非空的String
 */
+ (BOOL) ins_String:(NSString *)string;

/**
 补零
 */
- (NSString *) ins_2zero;

@end
