//
//  UserInfoHomePageV2Cell.m
//  SocialContact
//
//  Created by EDZ on 2019/5/8.
//  Copyright © 2019 ha. All rights reserved.
//

#import "UserInfoHomePageV2Cell.h"

@implementation UserInfoHomePageV2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUserInfo:(SCUserInfo *)userInfo{
    
    _userInfo = userInfo;
    
    self.nick.text = userInfo.name;
    
    UIImage *genderImage;// --
    if (userInfo.gender == 0) {
        genderImage = [UIImage imageNamed:@""];
    }else if (userInfo.gender == 1) {
        genderImage = [UIImage imageNamed:@"ic_male"];
    }else if (userInfo.gender == 2) {
        genderImage = [UIImage imageNamed:@"ic_women"];
    }
    self.gender.image = genderImage;
    
    if (userInfo.service_vip_expired_at) {
        NSDate *date = [self.userInfo.service_vip_expired_at sc_dateWithUTCString];
        
        NSTimeInterval interval = [date timeIntervalSinceNow];
        if (interval <= 0) {
            self.huiYuan.hidden = YES;
        }else{
            self.huiYuan.hidden = NO;
        }
    }else{
        self.huiYuan.hidden = YES;
    }
    
    if (userInfo.is_idcard_verified) {
        self.renZheng.hidden = NO;
    }else{
        self.renZheng.hidden = YES;
    }
    
    self.address.text = self.userInfo.address_home;
    
    self.years_to_marry.text = [NSString stringWithFormat:@"%@",[Help yearsToMarial:userInfo.years_to_marry]];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
