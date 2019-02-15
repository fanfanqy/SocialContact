//
//  Ins_NodataView.h
//  ChildEnd
//
//  Created by 陈康 on 2017/8/25.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NodataAction)();

@interface Ins_NodataView : UIView


+ (instancetype)ins_nodataViewWithIcon:(UIImage *)icon detail:(NSString *)detail;
+ (instancetype)ins_nodataViewWithIcon:(UIImage *)icon detail:(NSString *)detail actionTitle:(NSString *)title action:(NodataAction) noDataAction;

/** button */
@property (strong, nonatomic) UIButton *action;

/** block */
@property (copy, nonatomic) NodataAction noDataAction;

@end
