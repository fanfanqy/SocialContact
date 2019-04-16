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
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    
    self.address.layer.borderColor = Font_color333.CGColor;
    self.address.layer.borderWidth = .5;
    self.address.layer.cornerRadius = 10.f;
    
    self.nick.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.address.font = [UIFont fontWithName:@"Heiti SC" size:12];
    
}

- (void)setModel:(SCUserInfo *)model{
    
    _model = model;
    NSString *avatarUrl = @"";
    UIImage *placeholdImage = [UIImage imageNamed:@"icon_default_person"];
    if ([NSString ins_String:model.avatar_url]) {
        avatarUrl = model.avatar_url;
        if (![avatarUrl containsString:@"http"]) {
            avatarUrl = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,avatarUrl];
        }
        [self.img sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:placeholdImage];
    }else{
       self.img.image = placeholdImage;
    }
   
    if ([NSString ins_String:model.name]) {
        self.nick.text = model.name;
    }else{
        self.nick.text = [NSString stringWithFormat:@" %@ ",@"--"];
    }
    
    if ([NSString ins_String:model.address_home]) {
        self.address.text = [NSString stringWithFormat:@"  %@  ",model.address_home];
    }else{
        self.address.text = [NSString stringWithFormat:@"  %@  ",@"--"];
    }
    
//    NSDate *date = [NSDate dateWithISOFormatString:_model.last_request_at];
//    self.lastLoginTime.text =  [WBStatusHelper stringWithTimelineDate:date];
}

@end
