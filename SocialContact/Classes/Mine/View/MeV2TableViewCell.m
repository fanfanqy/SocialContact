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
    
    self.ziliaoT.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.zeouT.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.renzhengT.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.lookMeT.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.fenxiangT.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.jifenT.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.receiveWechatT.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.openVipT.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.yueT.font = [UIFont fontWithName:@"Heiti SC" size:15];
    
    if (![SCUserCenter sharedCenter].currentUser.userInfo.isOnlineSwitch) {
        self.openVipT.text = @"建议反馈";
        self.jifenT.text = @"当前";
    }
    
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
- (IBAction)yueClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(yueClicked)]) {
        [_delegate yueClicked];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
