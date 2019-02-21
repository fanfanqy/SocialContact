//
//  NearByUserCell.m
//  SocialContact
//
//  Created by EDZ on 2019/1/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import "NearByUserCell.h"

@implementation NearByUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 点击头像进入主页
    WEAKSELF;
    [self.avatarImg jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(clickAvatarImg:)]) {
            [weakSelf.delegate clickAvatarImg:weakSelf.userId];
        }
    }];
    
    self.avatarImg.layer.cornerRadius = 30;
    self.avatarImg.layer.masksToBounds = YES;
    
    self.address.layer.borderColor = YD_ColorBlack_1F2124.CGColor;
    self.address.layer.borderWidth = 1.f;
    self.address.layer.cornerRadius = 10.f;
}

- (void)setNotice:(Notice *)notice{
    _notice = notice;
    
    self.userId = notice.from_customer.iD;
    
//    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:notice.from_customer.avatar_url]];
    if ([NSString ins_String:notice.from_customer.avatar_url]) {
        [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:notice.from_customer.avatar_url]];
    }else{
        self.avatarImg.image = [UIImage imageNamed:@"icon_default_person"];
    }
    
    self.nickName.text = notice.from_customer.name;
    
    NSDate *date = [NSDate dateWithISOFormatString:notice.create_at];
    NSString *formatedTimeString = [WBStatusHelper stringWithTimelineDate:date];
    self.last_RequestTime.text = formatedTimeString;
    
    self.personalSignature.text = notice.text;
    
    self.address.layer.borderWidth = 0.f;
    self.address.text = @"";
    self.distance.text = @"";
}

- (void)setUserInfo:(SCUserInfo *)userInfo{
    _userInfo = userInfo;
    
    self.userId = userInfo.iD;
    
//    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar_url]];
    if ([NSString ins_String:userInfo.avatar_url]) {
        [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar_url]];
    }else{
        self.avatarImg.image = [UIImage imageNamed:@"icon_default_person"];
    }
    
    self.nickName.text = userInfo.name;
    
    NSDate *date = [NSDate dateWithISOFormatString:userInfo.last_request_at];
    NSString *formatedTimeString = [WBStatusHelper stringWithTimelineDate:date];
    self.last_RequestTime.text = formatedTimeString;
    
    self.personalSignature.text = userInfo.intro;
    
    
    if ([NSString ins_String:userInfo.address_home]) {
        self.address.layer.borderWidth = 1.f;
        self.address.text =  [NSString stringWithFormat:@"  %@  ",userInfo.address_home];
        [self.address sizeToFit];
    }else{
        self.address.layer.borderWidth = 0.f;
        self.address.text =  nil;
    }
    
    self.distance.text = @"_";
    
}

- (void)setLookMeModel:(WhoLookMeModel *)lookMeModel{
    
    _lookMeModel = lookMeModel;
    
    self.userId = lookMeModel.customer.iD;
    
    if ([NSString ins_String:lookMeModel.customer.avatar_url]) {
        [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:lookMeModel.customer.avatar_url]];
    }else{
        self.avatarImg.image = [UIImage imageNamed:@"icon_default_person"];
    }
    
    
    self.nickName.text = lookMeModel.customer.name;
    
    NSDate *date = [NSDate dateWithISOFormatString:lookMeModel.create_at];
    NSString *formatedTimeString = [WBStatusHelper stringWithTimelineDate:date];
    self.last_RequestTime.text = formatedTimeString;
    
    self.personalSignature.text = lookMeModel.customer.intro;
    
    if ([NSString ins_String:lookMeModel.customer.address_home]) {
        self.address.layer.borderWidth = 1.f;
        self.address.text =  [NSString stringWithFormat:@"  %@  ",lookMeModel.customer.address_home];
        [self.address sizeToFit];
    }else{
        self.address.layer.borderWidth = 0.f;
        self.address.text =  nil;
    }
    
    self.distance.text = @"_";
}

- (void)setUserPointsModel:(UserPointsModel *)userPointsModel{
    
    _userPointsModel = userPointsModel;
    
    self.avatarImg.hidden = YES;
    
//    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:userPointsModel.customer.avatar_url]];
    
    self.nickName.text = userPointsModel.desc;
    
    self.last_RequestTime.text = [NSString stringWithFormat:@"%ld",userPointsModel.amount];
    
    self.personalSignature.text = @"";
    
    self.address.layer.borderWidth = 0.f;
    self.address.text = @"";
    
    NSDate *date = [NSDate dateWithISOFormatString:userPointsModel.create_at];
    NSString *formatedTimeString = [WBStatusHelper stringWithTimelineDate:date];
    self.distance.text = formatedTimeString;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
