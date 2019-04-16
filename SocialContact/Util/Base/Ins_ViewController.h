//
//  Ins_ViewController.h
//  AVInsurance
//
//  Created by Dylan on 2016/7/28.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ins_NodataView.h"
#import "InsLoadDataTablView.h"
#import "UIScrollView+LoadData.h"
@interface InsViewController : UIViewController

/**
 内容视图的大小, 去掉导航以及TabBar的Frame
 */
@property (readonly,assign) CGRect fixedFrame;

/**
 滑动视图的Frame, 去掉导航以及TabBar
 */
@property (readonly,assign) CGRect fixedScrollFrame;

/**
 滑动视图的Inset
 */
@property (readonly,assign) UIEdgeInsets fixedScrollInsets;

@property (readonly,strong) NSString *ins_vc_identifier;

/**
 转动小菊花
 */
- (void) enableViewLoading;

/**
 停止转动小菊花, 此时应当加载界面内容
 */
- (void) disableViewLoading;

/**
 Hybrid Route action
 */
- (instancetype)initWithHybridParams: (NSDictionary *)params;


/**
 加载状态
 */
- (void)showLoading;
- (void)hideLoading;

/**
 加载失败时显示
 */
- (void)showNetworkWeakView:(NSString *)title isNetWeak:(BOOL)isNetWeak;
- (void)showError:(NSError *)error reload:(void(^)())reload;
- (void)hideNetworkWeakView;
- (void)fetchData;


- (void)createCustomTitleView:(NSString *)title backgroundColor:(UIColor *)backgroundColor rightItem:(UIButton *)rightBtn backContainAlpha:(BOOL)contain;

@end
