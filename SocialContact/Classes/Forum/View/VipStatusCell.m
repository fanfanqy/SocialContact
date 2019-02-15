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
