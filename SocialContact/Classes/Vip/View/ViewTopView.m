//
//  ViewTopView.m
//  SocialContact
//
//  Created by EDZ on 2019/2/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import "ViewTopView.h"

static  CGFloat borderWidth = 2.f;

static  CGFloat btnCornerRadius = 8.f;

@interface ViewTopView ()



@end

@implementation ViewTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 1.15*kScreenHeight);
    }
    return self;
}

- (void)setServiceModel:(ServiceModel *)serviceModel{
    _serviceModel = serviceModel;
    
    for (NSInteger i=0; i<serviceModel.pricelist.count; i++) {
        ProductInfoModel *model = serviceModel.pricelist[i];
        if (i == 0) {
            self.title1.text = model.name;
            self.price1.text = [NSString stringWithFormat:@"¥ %.2lf",model.price];
        }else if (i == 1) {
            self.title2.text = model.name;
            self.price2.text = [NSString stringWithFormat:@"¥ %.2lf",model.price];
        }else if (i == 2) {
            self.title3.text = model.name;
            self.price3.text = [NSString stringWithFormat:@"¥ %.2lf",model.price];
        }
    }
    
    self.desLB.text = @"";
    
    [self.dredgeBtn setBackgroundImage:[UIImage imageWithColor:RED] forState:UIControlStateNormal];
    self.dredgeBtn.layer.cornerRadius = kScreenWidth/20-1;
    self.dredgeBtn.layer.masksToBounds = YES;
    

    self.btn1.layer.cornerRadius = btnCornerRadius;
    self.btn1.layer.borderColor = RED.CGColor;
    [self.btn1 setBackgroundImage:[UIImage imageWithColor:RED] forState:UIControlStateNormal];
    self.btn1.layer.borderWidth = borderWidth;
    self.btn1.layer.masksToBounds = YES;
    
    self.btn2.layer.cornerRadius = btnCornerRadius;
    self.btn2.layer.borderColor = RED.CGColor;
    [self.btn2 setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    self.btn2.layer.borderWidth = borderWidth;
    self.btn2.layer.masksToBounds = YES;
    
    self.btn3.layer.cornerRadius = btnCornerRadius;
    self.btn3.layer.borderColor = RED.CGColor;
    [self.btn3 setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    self.btn3.layer.borderWidth = borderWidth;
    self.btn3.layer.masksToBounds = YES;
    
    self.title1.textColor = [UIColor whiteColor];
    self.title2.textColor = RED;
    self.title3.textColor = RED;
    
    self.price1.textColor = [UIColor whiteColor];
    self.price2.textColor = RED;
    self.price3.textColor = RED;
    
//    self.btn2.layer.cornerRadius = 8.f;
//    self.btn2.layer.borderColor = RED.CGColor;
//    self.btn2.backgroundColor = RED;
//    self.btn2.layer.borderWidth = 2.f;
//
//    self.btn3.layer.cornerRadius = 8.f;
//    self.btn3.layer.borderColor = RED.CGColor;
//    self.btn3.backgroundColor = RED;
//    self.btn3.layer.borderWidth = 2.f;
    
    self.bgView.layer.cornerRadius = btnCornerRadius;
    self.bgView.layer.borderColor = RED.CGColor;
    self.bgView.layer.borderWidth = 4.f;
}

- (IBAction)btn1Click:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(btn1Clicked)]) {
        [_delegate btn1Clicked];
    }
   
    [self.btn1 setBackgroundImage:[UIImage imageWithColor:RED] forState:UIControlStateNormal];
 
    [self.btn2 setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];

    [self.btn3 setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];

    self.title1.textColor = [UIColor whiteColor];
    self.title2.textColor = RED;
    self.title3.textColor = RED;
    
    self.price1.textColor = [UIColor whiteColor];
    self.price2.textColor = RED;
    self.price3.textColor = RED;
}

- (IBAction)btn2Click:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(btn2Clicked)]) {
        [_delegate btn2Clicked];
    }
 
    [self.btn1 setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];

    [self.btn2 setBackgroundImage:[UIImage imageWithColor:RED] forState:UIControlStateNormal];

    [self.btn3 setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];

    self.title1.textColor = RED;
    self.title2.textColor = [UIColor whiteColor];
    self.title3.textColor = RED;
    
    self.price1.textColor = RED;
    self.price2.textColor = [UIColor whiteColor];
    self.price3.textColor = RED;
}

- (IBAction)btn3Click:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(btn3Clicked)]) {
        [_delegate btn3Clicked];
    }

    [self.btn1 setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];

    [self.btn2 setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];

    [self.btn3 setBackgroundImage:[UIImage imageWithColor:RED] forState:UIControlStateNormal];

    self.title1.textColor = RED;
    self.title2.textColor = RED;
    self.title3.textColor = [UIColor whiteColor];
    
    self.price1.textColor = RED;
    self.price2.textColor = RED;
    self.price3.textColor = [UIColor whiteColor];
    
}

- (IBAction)dredgeBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(dredgeBtnClicked)]) {
        [_delegate dredgeBtnClicked];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark ------------------LifeCycle------------------

#pragma mark ------------------Network------------------

#pragma mark ------------------Event------------------

#pragma mark ------------------Lazy------------------

@end
