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
    
//    self.address.layer.borderColor = YD_Color999.CGColor;
//    self.address.layer.borderWidth = .3;
//    self.address.layer.cornerRadius = 8.f;
    
    self.nickName.font = [UIFont systemFontOfSize:14];
    self.last_RequestTime.font = [UIFont systemFontOfSize:14];
    self.personalSignature.font = [UIFont systemFontOfSize:13];
    self.address.font = [UIFont systemFontOfSize:12];
    self.distance.font = [UIFont systemFontOfSize:14];
}

- (void)setNotice:(Notice *)notice{
    _notice = notice;
    
    self.userId = notice.from_customer.iD;
    
//    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:notice.from_customer.avatar_url]];
    if ([NSString ins_String:notice.from_customer.avatar_url]) {
        
        NSString *avatarUrl = notice.from_customer.avatar_url;
        if (![avatarUrl containsString:@"http"]) {
            avatarUrl = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,avatarUrl];
        }
        [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:avatarUrl]];
    }else{
        self.avatarImg.image = [UIImage imageNamed:@"icon_default_person"];
    }
    

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:notice.from_customer.name?:@""];
    attString.font = [UIFont systemFontOfSize:16];
    attString.color = [UIColor colorWithHexString:@"3B3B3B"];
    attString.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString * attKongString = [[NSMutableAttributedString alloc] initWithString:@" "];
    
    UIImage *image;
    if (notice.from_customer.gender == 1) {
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
    if (notice.from_customer.service_vip_expired_at) {
        NSDate *date = [notice.from_customer.service_vip_expired_at sc_dateWithUTCString];
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
    
    
    if (notice.from_customer.is_idcard_verified) {
        UIImage *renzhenImage = [UIImage imageNamed:@"icon_shen_renzhen"];
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:renzhenImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(44, 14) alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
        [attString appendAttributedString:attKongString];
        [attString appendAttributedString:attachText];
        
    }
    
    self.nickName.attributedText = attString;
    
    
    
    
    self.last_RequestTime.text = [notice.create_at sc_timeAgoWithUTCString];
    
    self.personalSignature.text = notice.text;
    
//    self.address.layer.borderWidth = 0.f;
    self.address.text = @"";
    self.distance.text = @"";
}

- (void)setUserInfo:(SCUserInfo *)userInfo{
    _userInfo = userInfo;
    
    self.userId = userInfo.iD;
    
    if ([NSString ins_String:userInfo.avatar_url]) {
        
        NSString *avatarUrl = userInfo.avatar_url;
        if (![avatarUrl containsString:@"http"]) {
            avatarUrl = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,avatarUrl];
        }
        [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:avatarUrl]];
        
//        [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar_url]];
    }else{
        self.avatarImg.image = [UIImage imageNamed:@"icon_default_person"];
    }
    
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:userInfo.name?:@""];
    attString.font = [UIFont systemFontOfSize:16];
    attString.color = [UIColor colorWithHexString:@"3B3B3B"];
    attString.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString * attKongString = [[NSMutableAttributedString alloc] initWithString:@" "];
    
    UIImage *image;
    if (userInfo.gender == 1) {
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
    if (userInfo.service_vip_expired_at) {
        NSDate *date = [userInfo.service_vip_expired_at sc_dateWithUTCString];
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
    
    
    if (userInfo.is_idcard_verified) {
        UIImage *renzhenImage = [UIImage imageNamed:@"icon_shen_renzhen"];
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:renzhenImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(44, 14) alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
        [attString appendAttributedString:attKongString];
        [attString appendAttributedString:attachText];
        
    }
    
    self.nickName.attributedText = attString;
    
    self.last_RequestTime.text = [userInfo.last_request_at sc_timeAgoWithUTCString];
    
    self.personalSignature.text = [NSString stringWithFormat:@"%ld岁，%@",userInfo.age,[Help height:userInfo.height]];
    
    if ([NSString ins_String:userInfo.address_home]) {
//        self.address.layer.borderWidth = 1.f;
        self.address.text =  [NSString stringWithFormat:@"  %@  ",userInfo.address_home];
        
    }else{
//        self.address.layer.borderWidth = 0.f;
        self.address.text =  nil;
    }
    [self.address sizeToFit];
    
    CGFloat distance = [userInfo.distance floatValue];
    if (distance >=1000) {
        distance = distance/1000.0;
        self.distance.text = [NSString stringWithFormat:@"%.1lfkm",distance];
    }else{
        self.distance.text = [NSString stringWithFormat:@"%.0lfm",distance];
    }
    
}

- (void)setLookMeModel:(WhoLookMeModel *)lookMeModel{
    
    _lookMeModel = lookMeModel;
    
    self.userId = lookMeModel.customer.iD;
    
    if ([NSString ins_String:lookMeModel.customer.avatar_url]) {
        
        NSString *avatarUrl = lookMeModel.customer.avatar_url;
        if (![avatarUrl containsString:@"http"]) {
            avatarUrl = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,avatarUrl];
        }
        [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:avatarUrl]];
        
//        [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:lookMeModel.customer.avatar_url]];
    }else{
        self.avatarImg.image = [UIImage imageNamed:@"icon_default_person"];
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:lookMeModel.customer.name?:@""];
    attString.font = [UIFont systemFontOfSize:16];
    attString.color = [UIColor colorWithHexString:@"3B3B3B"];
    attString.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString * attKongString = [[NSMutableAttributedString alloc] initWithString:@" "];
    
    UIImage *image;
    if (lookMeModel.customer.gender == 1) {
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
    if (lookMeModel.customer.service_vip_expired_at) {
        NSDate *date = [lookMeModel.customer.service_vip_expired_at sc_dateWithUTCString];
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
    
    
    if (lookMeModel.customer.is_idcard_verified) {
        UIImage *renzhenImage = [UIImage imageNamed:@"icon_shen_renzhen"];
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:renzhenImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(44, 14) alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
        [attString appendAttributedString:attKongString];
        [attString appendAttributedString:attachText];
        
    }
    
    self.nickName.attributedText = attString;
    
    self.last_RequestTime.text = [lookMeModel.create_at sc_timeAgoWithUTCString];
    
    self.personalSignature.text = lookMeModel.customer.intro;
    
    if ([NSString ins_String:lookMeModel.customer.address_home]) {
//        self.address.layer.borderWidth = 1.f;
        self.address.text =  [NSString stringWithFormat:@"  %@  ",lookMeModel.customer.address_home];
        
    }else{
//        self.address.layer.borderWidth = 0.f;
        self.address.text =  nil;
    }
    [self.address sizeToFit];
    
    self.distance.text =  @"";
//    [NSString stringWithFormat:@"%@米",lookMeModel.customer.distance?:@"-"];
    
}

- (void)setUserPointsModel:(UserPointsModel *)userPointsModel{
    
    _userPointsModel = userPointsModel;
    
    self.avatarImg.hidden = YES;
    
    self.nickName.text = userPointsModel.desc;
    
    self.last_RequestTime.text = [NSString stringWithFormat:@"%ld",userPointsModel.amount];
    
    self.personalSignature.text = @"";
    
//    self.address.layer.borderWidth = 0.f;
    self.address.text = @"";
    
    self.distance.text = [userPointsModel.create_at sc_timeAgoWithUTCString];
}

- (void)setFollowsModel:(FollowsModel *)followsModel{
    
    _followsModel = followsModel;
    self.userId = followsModel.customer.iD;
    
    if ([NSString ins_String:followsModel.customer.avatar_url]) {
        
        NSString *avatarUrl = followsModel.customer.avatar_url;
        if (![avatarUrl containsString:@"http"]) {
            avatarUrl = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,avatarUrl];
        }
        [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:avatarUrl]];
        
    }else{
        self.avatarImg.image = [UIImage imageNamed:@"icon_default_person"];
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:followsModel.customer.name?:@""];
    attString.font = [UIFont systemFontOfSize:16];
    attString.color = [UIColor colorWithHexString:@"3B3B3B"];
    attString.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString * attKongString = [[NSMutableAttributedString alloc] initWithString:@" "];
    
    UIImage *image;
    if (followsModel.customer.gender == 1) {
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
    if (followsModel.customer.service_vip_expired_at) {
        NSDate *date = [followsModel.customer.service_vip_expired_at sc_dateWithUTCString];
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
    
    
    if (followsModel.customer.is_idcard_verified) {
        UIImage *renzhenImage = [UIImage imageNamed:@"icon_shen_renzhen"];
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:renzhenImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(44, 14) alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];
        [attString appendAttributedString:attKongString];
        [attString appendAttributedString:attachText];
        
    }
    
    self.nickName.attributedText = attString;

    self.last_RequestTime.text = [followsModel.create_at sc_timeAgoWithUTCString];
    
    self.personalSignature.text = followsModel.customer.intro;
    
    if ([NSString ins_String:followsModel.customer.address_home]) {
//        self.address.layer.borderWidth = 1.f;
        self.address.text =  [NSString stringWithFormat:@"  %@  ",followsModel.customer.address_home];
        
    }else{
//        self.address.layer.borderWidth = 0.f;
        self.address.text =  nil;
    }
    [self.address sizeToFit];
    
    self.distance.text = @"";
//    self.distance.text = [NSString stringWithFormat:@"%@米",followsModel.customer.distance?:@"-"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
