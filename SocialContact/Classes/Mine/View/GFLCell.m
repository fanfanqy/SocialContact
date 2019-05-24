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
    
//    self.bgView.layer.cornerRadius  = 10.f;
    self.bgView.layer.shadowColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:0.28].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0,1);
    self.bgView.layer.shadowOpacity = 1;
    self.bgView.layer.shadowRadius = 3;
    self.bgView.layer.cornerRadius = 3.3;
    self.bgView.layer.borderColor = [UIColor colorWithHexString:@"666666"].CGColor;
    self.bgView.layer.borderWidth = .1;
    
    self.avatarImg.layer.cornerRadius = 50.f;
    self.avatarImg.layer.masksToBounds = YES;
    
    self.avatarImg.layer.borderWidth = 2.f;
    self.avatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.verifyStatusL.layer.cornerRadius = 30.f;
    self.verifyStatusL.layer.masksToBounds = YES;
    
    
    self.lookMeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.woGuanzhuBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.guanzhuWodeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.huxiangGuanZhuBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    self.lookMeCountLB.font = [UIFont systemFontOfSize:15];
    self.woGuanzhuCountLB.font = [UIFont systemFontOfSize:15];
    self.guanzhuWodeCountLB.font = [UIFont systemFontOfSize:15];
    self.huxiangGuanZhuCountLB.font = [UIFont systemFontOfSize:15];
    
    self.nickL.textAlignment = NSTextAlignmentCenter;
    
    WEAKSELF;
    [self.lookMeCountLB jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(kanguoWoBtnClicked)]) {
            [weakSelf.delegate kanguoWoBtnClicked];
        }
    }];
    
    [self.woGuanzhuCountLB jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(woguanzhuBtnClicked)]) {
            [weakSelf.delegate woguanzhuBtnClicked];
        }
    }];
    [self.guanzhuWodeCountLB jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(guanzhuWoBtnClicked)]) {
            [weakSelf.delegate guanzhuWoBtnClicked];
        }
    }];
    [self.huxiangGuanZhuCountLB jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(huxiangGuanZhuBtnClicked)]) {
            [weakSelf.delegate huxiangGuanZhuBtnClicked];
        }
    }];
    
}

- (void)setLookMeCount:(NSInteger)lookMeCount{
    
    _lookMeCount = lookMeCount;
    if (lookMeCount > 0) {
        [self.lookMeBtn setTitle:[NSString stringWithFormat:@"%ld",lookMeCount] forState:UIControlStateNormal];
    }else{
        [self.lookMeBtn setTitle:@"0" forState:UIControlStateNormal];
    }
    
}

- (void)setUserModel:(SCUserInfo *)userModel{
    _userModel = userModel;
    
    [self.lookMeBtn setTitle:[NSString stringWithFormat:@"%ld",userModel.count_view_me] forState:UIControlStateNormal];
    [self.woGuanzhuBtn setTitle:[NSString stringWithFormat:@"%ld",userModel.following_count] forState:UIControlStateNormal];
    [self.guanzhuWodeBtn setTitle:[NSString stringWithFormat:@"%ld",userModel.followers_count] forState:UIControlStateNormal];
    [self.huxiangGuanZhuBtn setTitle:[NSString stringWithFormat:@"%ld",userModel.following_both_count] forState:UIControlStateNormal];

    NSString *avatarUrlStr = userModel.avatar_url;
    
    self.verifyStatusL.backgroundColor = [UIColor clearColor];
    
    if (userModel.avatar_status == 0) {
        self.verifyStatusL.image = [UIImage imageNamed:@"verifing"];
        self.verifyStatusL.backgroundColor = [UIColor whiteColor];
    }else if (userModel.avatar_status == 2) {
        self.verifyStatusL.image = [UIImage imageNamed:@"verifyFailed"];
        self.verifyStatusL.backgroundColor = [UIColor whiteColor];
    }
    
    [self.avatarImg sc_setImgWithUrl:avatarUrlStr placeholderImg:@"icon_default_person"];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:userModel.name?:@""];
    attString.font = [[UIFont systemFontOfSize:17]fontWithBold];
    attString.color = [UIColor colorWithHexString:@"333333"];
    attString.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString * attKongString = [[NSMutableAttributedString alloc] initWithString:@" "];
    
    UIImage *image;
    if (userModel.gender == 1) {
        image = [UIImage imageNamed:@"ic_male"];
    }else{
        image = [UIImage imageNamed:@"ic_women"];
    }
    if (image) {
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(14, 14) alignToFont:[UIFont systemFontOfSize:14] alignment:YYTextVerticalAlignmentCenter];
        [attString appendAttributedString:attKongString];
        [attString appendAttributedString:attachText];
    }
    
    UIImage *vipImage;
    if (userModel.service_vip_expired_at) {
        NSDate *date = [userModel.service_vip_expired_at sc_dateWithUTCString];
        NSTimeInterval interval = [date timeIntervalSinceNow];
        if (interval > 0) {
            vipImage = [UIImage imageNamed:@"ic_huiyuan"];
        }
    }
    if (vipImage) {
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:vipImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(14, 14) alignToFont:[UIFont systemFontOfSize:14] alignment:YYTextVerticalAlignmentCenter];
        [attString appendAttributedString:attKongString];
        [attString appendAttributedString:attachText];
    }
    
    
    if (userModel.is_idcard_verified) {
        UIImage *renzhenImage = [UIImage imageNamed:@"icon_shen_renzhen"];
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:renzhenImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(44, 14) alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
        [attString appendAttributedString:attKongString];
        [attString appendAttributedString:attachText];
        
    }
    
    self.nickL.attributedText = attString;
    
    self.introduceL.text = userModel.intro.length>0 ? [NSString stringWithFormat:@"自我介绍：%@",userModel.intro] :@"暂无自我介绍";
    
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
