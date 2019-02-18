//
//  ViewTopView.h
//  SocialContact
//
//  Created by EDZ on 2019/2/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ViewTopViewDelegate <NSObject>

@optional

- (void)btn1Clicked;

- (void)btn2Clicked;

- (void)btn3Clicked;

- (void)dredgeBtnClicked;

@end

/**
 
 */
@interface ViewTopView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *price2;
@property (weak, nonatomic) IBOutlet UILabel *price3;



@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;



@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (weak, nonatomic) IBOutlet UIButton *dredgeBtn;

@property(nonatomic,weak)id<ViewTopViewDelegate> delegate;

@property(nonatomic,strong)ServiceModel *serviceModel;

@end

NS_ASSUME_NONNULL_END
