//
//  BottlesVC.h
//  
//
//  Created by EDZ on 2019/2/25.
//

#import "Ins_ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BottlesVC : InsViewController

/**
 1.我捡到的瓶子列表
 2.我扔出的瓶子列表
 */
INS_P_ASSIGN(NSInteger, type);

INS_P_ASSIGN(CGFloat, height);

INS_P_STRONG(UIViewController *, fatherVC);

@end

NS_ASSUME_NONNULL_END
