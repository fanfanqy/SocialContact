//
//  VipVC.h
//  SocialContact
//
//  Created by EDZ on 2019/2/13.
//  Copyright © 2019 ha. All rights reserved.
//

#import "Ins_ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VipVC : InsViewController

//service_type    int    服务类型, 1: VIP服务; 2: 置顶服务

/*
 * 0:置顶
 1: 会员
 */
INS_P_ASSIGN(NSInteger, type);

@end

NS_ASSUME_NONNULL_END
