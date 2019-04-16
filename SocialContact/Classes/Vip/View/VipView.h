//
//  VipView.h
//  SocialContact
//
//  Created by EDZ on 2019/3/28.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUserInfo.h"
#import "ServiceModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol VipViewDelegate <NSObject>

@optional

- (void)selectedIndex:(NSInteger)index;

- (void)vipDredgeBtnClicked;

@end
/**
 <#Description#>
 */
@interface VipView : UIView

INS_P_STRONG(SCUserInfo *, userModel);

@property(nonatomic,strong)ServiceModel *serviceModel;

@property(nonatomic,strong) ProductInfoModel *selectedInfoModel;

@property(nonatomic,assign) NSInteger selectedIndex;

@property(nonatomic,weak) id <VipViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
