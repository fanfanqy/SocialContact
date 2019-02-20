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
    
    
}

- (void)setNotice:(Notice *)notice{
    _notice = notice;
    
    self.userId = notice.from_customer.iD;
    
    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:notice.from_customer.avatar_url]];
    self.nickName.text = notice.from_customer.name;
    
    NSDate *date = [NSDate dateWithISOFormatString:notice.create_at];
    NSString *formatedTimeString = [WBStatusHelper stringWithTimelineDate:date];
    self.last_RequestTime.text = formatedTimeString;
    
    self.personalSignature.text = notice.text;
    
    self.address.text = @"";
    self.distance.text = @"";
}

- (void)setUserInfo:(SCUserInfo *)userInfo{
    _userInfo = userInfo;
    
    self.userId = userInfo.iD;
    
    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar_url]];
    self.nickName.text = userInfo.name;
    
    NSDate *date = [NSDate dateWithISOFormatString:userInfo.last_request_at];
    NSString *formatedTimeString = [WBStatusHelper stringWithTimelineDate:date];
    self.last_RequestTime.text = formatedTimeString;
    
    self.personalSignature.text = userInfo.intro;
    
    self.address.text = userInfo.address_home;
    self.distance.text = @"__";
    
}

- (void)setLookMeModel:(WhoLookMeModel *)lookMeModel{
    
    _lookMeModel = lookMeModel;
    
    self.userId = lookMeModel.customer.iD;
    
    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:lookMeModel.customer.avatar_url]];
    
    self.nickName.text = lookMeModel.customer.name;
    
    NSDate *date = [NSDate dateWithISOFormatString:lookMeModel.create_at];
    NSString *formatedTimeString = [WBStatusHelper stringWithTimelineDate:date];
    self.last_RequestTime.text = formatedTimeString;
    
    self.personalSignature.text = lookMeModel.customer.intro;
    
    self.address.text = lookMeModel.customer.address_home;
    self.distance.text = @"__";
}

- (void)setUserPointsModel:(UserPointsModel *)userPointsModel{
    
    _userPointsModel = userPointsModel;
    
    self.avatarImg.hidden = YES;
    
//    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:userPointsModel.customer.avatar_url]];
    
    self.nickName.text = userPointsModel.desc;
    
    self.last_RequestTime.text = [NSString stringWithFormat:@"%ld",userPointsModel.amount];
    
    self.personalSignature.text = @"";
    
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
