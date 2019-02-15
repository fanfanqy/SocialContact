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
}

- (void)setNotice:(Notice *)notice{
    _notice = notice;
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
    
    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar_url]];
    self.nickName.text = userInfo.name;
    
    NSDate *date = [NSDate dateWithISOFormatString:userInfo.last_request_at];
    NSString *formatedTimeString = [WBStatusHelper stringWithTimelineDate:date];
    self.last_RequestTime.text = formatedTimeString;
    
    self.personalSignature.text = userInfo.intro;
    
    self.address.text = userInfo.address_home;
    self.distance.text = @"__";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
