//
//  NSObject+HhtCategory.h
//  ChildEnd
//
//  Created by EDZ on 2018/8/1.
//  Copyright © 2018年 readyidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HhtCategory)
-(BOOL) runningInBackground;
-(void)addLocalNotification;
-(void)addLocalNotificationWithTitle:(NSString *)title body:(NSString *)body;
@end
