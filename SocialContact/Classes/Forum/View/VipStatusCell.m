//
//  VipStatusCell.m
//  SocialContact
//
//  Created by EDZ on 2019/1/19.
//  Copyright © 2019 ha. All rights reserved.
//

#import "VipStatusCell.h"

@implementation VipStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.vip.layer.borderColor = Font_color333.CGColor;
//    self.vip.layer.borderWidth = .7;
//    self.vip.layer.cornerRadius = 30;
//    
//    self.exchangeWechat.layer.borderColor = Font_color333.CGColor;
//    self.exchangeWechat.layer.borderWidth = .7;
//    self.exchangeWechat.layer.cornerRadius = 30;
//    
//    self.yueTa.layer.borderColor = Font_color333.CGColor;
//    self.yueTa.layer.borderWidth = .7;
//    self.yueTa.layer.cornerRadius = 30;
    
    self.vipDayCount.font = [UIFont systemFontOfSize:15];
    self.vipTitle.font =  [UIFont systemFontOfSize:14];
    self.exchangeWechatTitle.font =  [UIFont systemFontOfSize:14];
    self.yueTitle.font =  [UIFont systemFontOfSize:14];
    
    
}

- (IBAction)vipClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(vipClicked)]) {
        [_delegate vipClicked];
    }
    
}

- (IBAction)exchangeWechatClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeWechatClicked)]) {
        [_delegate exchangeWechatClicked];
    }
    
}

- (IBAction)yueTaClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(yueTaClicked)]) {
        [_delegate yueTaClicked];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
