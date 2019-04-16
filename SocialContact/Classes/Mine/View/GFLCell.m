//
//  GFLCell.m
//  SocialContact
//
//  Created by EDZ on 2019/4/2.
//  Copyright © 2019 ha. All rights reserved.
//

#import "GFLCell.h"

@implementation GFLCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lookMeBtn.titleLabel.font = [[UIFont fontWithName:@"Heiti SC" size:16]fontWithBold];
    self.woGuanzhuBtn.titleLabel.font = [[UIFont fontWithName:@"Heiti SC" size:16]fontWithBold];
    self.guanzhuWodeBtn.titleLabel.font = [[UIFont fontWithName:@"Heiti SC" size:16]fontWithBold];
    self.huxiangGuanZhuBtn.titleLabel.font = [[UIFont fontWithName:@"Heiti SC" size:16]fontWithBold];
    
    self.lookMeCountLB.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.woGuanzhuCountLB.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.guanzhuWodeCountLB.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.huxiangGuanZhuCountLB.font = [UIFont fontWithName:@"Heiti SC" size:15];
    
}

- (void)setLookMeCount:(NSInteger)lookMeCount{
    
    _lookMeCount = lookMeCount;
    if (lookMeCount > 0) {
        self.lookMeCountLB.text = [NSString stringWithFormat:@"+%ld",lookMeCount];
    }else{
        self.lookMeCountLB.text = @"+0";
    }
    
    
}

- (void)setUserModel:(SCUserInfo *)userModel{
    _userModel = userModel;
    
    self.woGuanzhuCountLB.text = [NSString stringWithFormat:@"%ld",userModel.following_count];
    self.guanzhuWodeCountLB.text = [NSString stringWithFormat:@"%ld",userModel.followers_count];
    
}

- (IBAction)kanguoWoBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(kanguoWoBtnClicked)]) {
        [_delegate kanguoWoBtnClicked];
    }
}
- (IBAction)guanzhuWoBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(guanzhuWoBtnClicked)]) {
        [_delegate guanzhuWoBtnClicked];
    }
}
- (IBAction)woguanzhuBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(woguanzhuBtnClicked)]) {
        [_delegate woguanzhuBtnClicked];
    }
}
- (IBAction)huxiangGuanZhuBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(huxiangGuanZhuBtnClicked)]) {
        [_delegate huxiangGuanZhuBtnClicked];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
