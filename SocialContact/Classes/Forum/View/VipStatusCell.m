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
    self.vip.layer.borderColor = [UIColor blackColor].CGColor;
    self.vip.layer.borderWidth = 1.f;
    self.vip.layer.cornerRadius = 30;
    
    self.exchangeWechat.layer.borderColor = [UIColor blackColor].CGColor;
    self.exchangeWechat.layer.borderWidth = 1.f;
    self.exchangeWechat.layer.cornerRadius = 30;
    
    self.yueTa.layer.borderColor = [UIColor blackColor].CGColor;
    self.yueTa.layer.borderWidth = 1.f;
    self.yueTa.layer.cornerRadius = 30;
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
