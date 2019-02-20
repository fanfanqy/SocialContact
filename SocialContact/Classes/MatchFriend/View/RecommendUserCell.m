//
//  RecommendUserCell.m
//  SocialContact
//
//  Created by EDZ on 2019/1/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import "RecommendUserCell.h"

@implementation RecommendUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
    self.address.layer.borderColor = [UIColor blackColor].CGColor;
    self.address.layer.borderWidth = 1.f;
    self.address.layer.cornerRadius = 9.f;
    
}

- (void)setModel:(SCUserInfo *)model{
    
    _model = model;
    NSString *avatarUrl = @"";
    UIImage *placeholdImage = [UIImage imageNamed:@"icon_default_person"];
    if ([NSString ins_String:model.avatar_url]) {
        avatarUrl = model.avatar_url;
        [self.img sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:placeholdImage];
    }else{
       self.img.image = placeholdImage;
    }
    
    self.nick.text = model.name;
    self.address.text = [NSString stringWithFormat:@" %@ ",model.address_home];
    
//    NSDate *date = [NSDate dateWithISOFormatString:_model.last_request_at];
//    self.lastLoginTime.text =  [WBStatusHelper stringWithTimelineDate:date];
}

@end
