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
//    self.layer.cornerRadius = 10;
//    self.layer.masksToBounds = YES;
//    self.clipsToBounds = YES;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
//    self.contentView.layer.cornerRadius = 10;
//    self.contentView.layer.masksToBounds = YES;
//    self.contentView.clipsToBounds = YES;
//
//    self.img.layer.cornerRadius = 8.0;
//    self.img.layer.masksToBounds = YES;
//
    
//    self.address.layer.borderColor = Font_color333.CGColor;
//    self.address.layer.borderWidth = .3;
//    self.address.layer.cornerRadius = 8.f;
//    
    self.nick.font = [UIFont systemFontOfSize:15];
    self.address.font = [UIFont systemFontOfSize:10];
    
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
    
    self.address.text = [NSString stringWithFormat:@"%@ %@",model.gender?@"男":@"女", model.address_home];
    
//    if ([NSString ins_String:model.address_home]) {
//        self.address.text = [NSString stringWithFormat:@"  %@  ",model.address_home];
//    }else{
//        self.address.text = [NSString stringWithFormat:@"  %@  ",@"--"];
//    }
    
//    NSDate *date = [NSDate dateWithISOFormatString:_model.last_request_at];
//    self.lastLoginTime.text =  [WBStatusHelper stringWithTimelineDate:date];
}

@end
