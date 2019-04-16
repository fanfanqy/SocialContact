//
//  UserFeedBackViewController.h
//  wyh
//
//  Created by bobo on 16/1/5.
//  Copyright © 2016年 HW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserFeedBackViewController : UIViewController

/*
 0: 举报
 1: 反馈
 2:
 */
INS_P_ASSIGN(NSInteger, type);

// 被举报用户id
INS_P_ASSIGN(NSInteger,to_customer_id);
@end
