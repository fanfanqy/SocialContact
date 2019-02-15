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
}

- (void)setModel:(MomentModel *)model{
    
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
    self.address.text = model.address;
    NSDate *date = [NSDate dateWithISOFormatString:_model.last_request_at];
    self.lastLoginTime.text =  [WBStatusHelper stringWithTimelineDate:date];
}

@end
