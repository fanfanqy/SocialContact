//
//  VipView.m
//  SocialContact
//
//  Created by EDZ on 2019/3/28.
//  Copyright © 2019 ha. All rights reserved.
//

#import "VipView.h"

@interface VipView ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *introduce;

@property (weak, nonatomic) IBOutlet UIButton *vip1;
@property (weak, nonatomic) IBOutlet UIButton *vip2;
@property (weak, nonatomic) IBOutlet UIButton *vip3;
@property (weak, nonatomic) IBOutlet UIButton *vip4;
@property (weak, nonatomic) IBOutlet UIButton *vip5;
@property (weak, nonatomic) IBOutlet UIButton *vip6;

@property (weak, nonatomic) IBOutlet UILabel *vip1_title;
@property (weak, nonatomic) IBOutlet UILabel *vip1_amount;

@property (weak, nonatomic) IBOutlet UILabel *vip2_title;
@property (weak, nonatomic) IBOutlet UILabel *vip2_amount;

@property (weak, nonatomic) IBOutlet UILabel *vip3_title;
@property (weak, nonatomic) IBOutlet UILabel *vip3_amount;

@property (weak, nonatomic) IBOutlet UILabel *vip4_title;
@property (weak, nonatomic) IBOutlet UILabel *vip4_amount;

@property (weak, nonatomic) IBOutlet UILabel *vip5_title;
@property (weak, nonatomic) IBOutlet UILabel *vip5_amount;

@property (weak, nonatomic) IBOutlet UILabel *vip6_title;
@property (weak, nonatomic) IBOutlet UILabel *vip6_amount;

@property (weak, nonatomic) IBOutlet UIButton *dredgeBtn;

@end

@implementation VipView


- (void)setServiceModel:(ServiceModel *)serviceModel{
    
    _serviceModel = serviceModel;
    
    self.avatar.layer.cornerRadius = 40.f;
    self.avatar.layer.masksToBounds = YES;
    
    self.vip1.hidden = YES;
    self.vip2.hidden = YES;
    self.vip3.hidden = YES;
    self.vip4.hidden = YES;
    self.vip5.hidden = YES;
    self.vip6.hidden = YES;
    
    
    [self.vip1 setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
    self.vip1_title.textColor = [UIColor whiteColor];
    self.vip1_amount.textColor = [UIColor whiteColor];
    
    self.vip1.layer.borderWidth = .7;
    self.vip2.layer.borderWidth = .7;
    self.vip3.layer.borderWidth = .7;
    self.vip4.layer.borderWidth = .7;
    self.vip5.layer.borderWidth = .7;
    self.vip6.layer.borderWidth = .7;
    
    self.vip1.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    self.vip2.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    self.vip3.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    self.vip4.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    self.vip5.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    self.vip6.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC"].CGColor;
    
    self.vip1.layer.cornerRadius = 6;
    self.vip2.layer.cornerRadius = 6;
    self.vip3.layer.cornerRadius = 6;
    self.vip4.layer.cornerRadius = 6;
    self.vip5.layer.cornerRadius = 6;
    self.vip6.layer.cornerRadius = 6;
    
    self.vip1.layer.masksToBounds = YES;
    self.vip2.layer.masksToBounds = YES;
    self.vip3.layer.masksToBounds = YES;
    self.vip4.layer.masksToBounds = YES;
    self.vip5.layer.masksToBounds = YES;
    self.vip6.layer.masksToBounds = YES;
    
    [self.dredgeBtn setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
    
    for (NSInteger i=0; i<serviceModel.pricelist.count; i++) {
        ProductInfoModel *model = serviceModel.pricelist[i];
        if (i == 0) {
            self.vip1.hidden = NO;
            self.vip1_title.text = model.name;
            self.vip1_amount.text = [NSString stringWithFormat:@"¥ %.2lf",model.price];
        }else if (i == 1) {
            self.vip2.hidden = NO;
            self.vip2_title.text = model.name;
            self.vip2_amount.text = [NSString stringWithFormat:@"¥ %.2lf",model.price];
        }else if (i == 2) {
            self.vip3.hidden = NO;
            self.vip3_title.text = model.name;
            self.vip3_amount.text = [NSString stringWithFormat:@"¥ %.2lf",model.price];
        }else if (i == 3) {
            self.vip4.hidden = NO;
            self.vip4_title.text = model.name;
            self.vip4_amount.text = [NSString stringWithFormat:@"¥ %.2lf",model.price];
        }else if (i == 4) {
            self.vip5.hidden = NO;
            self.vip5_title.text = model.name;
            self.vip5_amount.text = [NSString stringWithFormat:@"¥ %.2lf",model.price];
        }else if (i == 5) {
            self.vip6.hidden = NO;
            self.vip6_title.text = model.name;
            self.vip6_amount.text = [NSString stringWithFormat:@"¥ %.2lf",model.price];
        }
    }
    
}

- (void)setUserModel:(SCUserInfo *)userModel{
    
    _userModel = userModel;
    
    [self.avatar sc_setImgWithUrl:userModel.avatar_url placeholderImg:@""];
    self.nick.text = userModel.name;
    
    if (userModel.service_vip_expired_at) {
        
        NSDate *date = [self.userModel.service_vip_expired_at sc_dateWithUTCString];
        if (date) {
            NSTimeInterval interval = [date timeIntervalSinceNow];
            if (interval < 0) {
                self.introduce.text = @"未开通会员服务";
            }else{
                self.introduce.text = [NSString stringWithFormat:@"%@到期",[self.userModel.service_vip_expired_at componentsSeparatedByString:@"T"][0]];
            }
        }else{
             self.introduce.text = [NSString stringWithFormat:@"%@到期",[self.userModel.service_vip_expired_at componentsSeparatedByString:@"T"][0]];
        }
        
    }else{
        self.introduce.text = @"未开通会员服务";
    }
    
}

- (void)defaultUI{
    
    [self.vip1 setBackgroundImage:nil forState:UIControlStateNormal];
    self.vip1_title.textColor = Font_color333;
    self.vip1_amount.textColor = ORANGE;
    
    [self.vip2 setBackgroundImage:nil forState:UIControlStateNormal];
    self.vip2_title.textColor = Font_color333;
    self.vip2_amount.textColor = ORANGE;
    
    [self.vip3 setBackgroundImage:nil forState:UIControlStateNormal];
    self.vip3_title.textColor = Font_color333;
    self.vip3_amount.textColor = ORANGE;
    
    [self.vip4 setBackgroundImage:nil forState:UIControlStateNormal];
    self.vip4_title.textColor = Font_color333;
    self.vip4_amount.textColor = ORANGE;
    
    [self.vip5 setBackgroundImage:nil forState:UIControlStateNormal];
    self.vip5_title.textColor = Font_color333;
    self.vip5_amount.textColor = ORANGE;
    
    [self.vip6 setBackgroundImage:nil forState:UIControlStateNormal];
    self.vip6_title.textColor = Font_color333;
    self.vip6_amount.textColor = ORANGE;
    
    self.vip1.layer.borderWidth = .7;
    self.vip2.layer.borderWidth = .7;
    self.vip3.layer.borderWidth = .7;
    self.vip4.layer.borderWidth = .7;
    self.vip5.layer.borderWidth = .7;
    self.vip6.layer.borderWidth = .7;
}

- (IBAction)vip1Clicked:(id)sender {
    
    [self defaultUI];
    
    [self.vip1 setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
    self.vip1.layer.borderWidth = 0;
    
    self.vip1_title.textColor = [UIColor whiteColor];
    self.vip1_amount.textColor = [UIColor whiteColor];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedIndex:)]) {
        [_delegate selectedIndex:0];
    }
    
}

- (IBAction)vip2Clicked:(id)sender {
    
    [self defaultUI];
    
    [self.vip2 setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
    self.vip2.layer.borderWidth = 0;
    
    self.vip2_title.textColor = [UIColor whiteColor];
    self.vip2_amount.textColor = [UIColor whiteColor];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedIndex:)]) {
        [_delegate selectedIndex:1];
    }
}


- (IBAction)vip3Clicked:(id)sender {
    
    [self defaultUI];
    
    [self.vip3 setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
    self.vip3.layer.borderWidth = 0;
    
    self.vip3_title.textColor = [UIColor whiteColor];
    self.vip3_amount.textColor = [UIColor whiteColor];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedIndex:)]) {
        [_delegate selectedIndex:2];
    }
}

- (IBAction)vip4Clicked:(id)sender {
    
    [self defaultUI];
    
    [self.vip4 setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
    self.vip4.layer.borderWidth = 0;
    
    self.vip4_title.textColor = [UIColor whiteColor];
    self.vip4_amount.textColor = [UIColor whiteColor];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedIndex:)]) {
        [_delegate selectedIndex:3];
    }
}

- (IBAction)vip5Clicked:(id)sender {
    
    [self defaultUI];
    
    [self.vip5 setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
    self.vip5.layer.borderWidth = 0;
    
    self.vip5_title.textColor = [UIColor whiteColor];
    self.vip5_amount.textColor = [UIColor whiteColor];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedIndex:)]) {
        [_delegate selectedIndex:4];
    }
}

- (IBAction)vip6Clicked:(id)sender {
    
    [self defaultUI];
    
    [self.vip6 setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
    self.vip6.layer.borderWidth = 0;
    
    self.vip6_title.textColor = [UIColor whiteColor];
    self.vip6_amount.textColor = [UIColor whiteColor];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedIndex:)]) {
        [_delegate selectedIndex:5];
    }
}

- (IBAction)dredgeBtnClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(vipDredgeBtnClicked)]) {
        [_delegate vipDredgeBtnClicked];
    }
}
@end
