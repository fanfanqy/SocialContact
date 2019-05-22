//
//  MeV2TableViewCell.m
//  SocialContact
//
//  Created by EDZ on 2019/3/4.
//  Copyright © 2019 ha. All rights reserved.
//

#import "MeV2TableViewCell.h"

@implementation MeV2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.ziliaoT.font = [UIFont systemFontOfSize:15];
    self.zeouT.font = [UIFont systemFontOfSize:15];
    self.renzhengT.font = [UIFont systemFontOfSize:15];
//    self.lookMeT.font = [UIFont systemFontOf size:15];
    self.fenxiangT.font = [UIFont systemFontOfSize:15];
    self.jifenT.font = [UIFont systemFontOfSize:15];
    self.receiveWechatT.font = [UIFont systemFontOfSize:15];
    self.openVipT.font = [UIFont systemFontOfSize:15];
    
//    self.bgView.layer.cornerRadius  = 10.f;
    self.bgView.layer.shadowColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:0.28].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0,1);
    self.bgView.layer.shadowOpacity = 1;
    self.bgView.layer.shadowRadius = 3;
    self.bgView.layer.cornerRadius = 3.3;
    
}
- (IBAction)gerenziliaoClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(gerenziliaoClicked)]) {
        [_delegate gerenziliaoClicked];
    }
}
- (IBAction)zeoubiaozhunClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(zeoubiaozhunClicked)]) {
        [_delegate zeoubiaozhunClicked];
    }
}
- (IBAction)woyaorenzheng:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(woyaorenzhenged)]) {
        [_delegate woyaorenzhenged];
    }
}
//- (IBAction)shuikanguowoClick:(id)sender {
//    
//    if (_delegate && [_delegate respondsToSelector:@selector(shuikanguowoClicked)]) {
//        [_delegate shuikanguowoClicked];
//    }
//}
- (IBAction)fenxiangRuanjianClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(fenxiangRuanjianClicked)]) {
        [_delegate fenxiangRuanjianClicked];
    }
}
- (IBAction)dangqianJifenClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(dangqianJifenClicked)]) {
        [_delegate dangqianJifenClicked];
    }
}
- (IBAction)shoudaoWeixinClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(shoudaoWeixinClicked)]) {
        [_delegate shoudaoWeixinClicked];
    }
}

- (IBAction)openVipBtnClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(openVipBtnClicked)]) {
        [_delegate openVipBtnClicked];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
