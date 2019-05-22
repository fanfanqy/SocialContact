//
//  VipVC.h
//  SocialContact
//
//  Created by EDZ on 2019/2/13.
//  Copyright © 2019 ha. All rights reserved.
//

#import "Ins_ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VipVCDelegate <NSObject>

@optional

- (void)fillVipsuccess;

@end

@interface VipVC : InsViewController

//service_type    int    服务类型, 1: VIP服务; 2: 置顶服务； 3    红娘线上服务卡；4    红娘线下服务卡

/*
 1    会员
 2    首页置顶显示
 3    红娘服务卡
 */
INS_P_ASSIGN(NSInteger, type);

INS_P_ASSIGN(NSInteger, userId);

@property(nonatomic,weak) id<VipVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
