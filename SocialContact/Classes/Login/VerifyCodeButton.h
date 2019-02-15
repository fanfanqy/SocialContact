//
//  VerifyCodeButton.h
//  ChildEnd
//
//  Created by 孟庆伟 on 2017/7/11.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyCodeButton : UIButton

/** label */
@property (strong, nonatomic) UILabel *label;

// 由于有些时间需求不同，特意露出方法，倒计时时间次数
- (void)timeFailBeginFrom:(NSInteger)timeCount;
@property(assign,nonatomic) BOOL isGray;

@end
