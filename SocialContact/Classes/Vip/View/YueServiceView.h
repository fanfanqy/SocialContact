//
//  YueServiceView.h
//  SocialContact
//
//  Created by EDZ on 2019/2/28.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YueServiceViewDelegate <NSObject>

@optional

- (void)xianShangBtnClicked;

- (void)xianXiaBtnClicked;

- (void)payClicked;

@end
/**
 <#Description#>
 */
@interface YueServiceView : UIView
@property (weak, nonatomic) IBOutlet UILabel *fuwuKa;
@property (weak, nonatomic) IBOutlet UILabel *xianShangYue;
@property (weak, nonatomic) IBOutlet UILabel *xianXiaYue;
@property (weak, nonatomic) IBOutlet UILabel *xianShangPrice;
@property (weak, nonatomic) IBOutlet UILabel *xianXiaPrice;
@property (weak, nonatomic) IBOutlet UIButton *selectXianShang;
@property (weak, nonatomic) IBOutlet UIButton *selectXianXia;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) id<YueServiceViewDelegate> delegate;


/**
 线上约
 */
@property(nonatomic,strong)ServiceModel *serviceXianShangYueModel;

/**
 线下约
 */
@property(nonatomic,strong)ServiceModel *serviceXianXiaYueModel;

@end

NS_ASSUME_NONNULL_END
