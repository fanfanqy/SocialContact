//
//  UserImagesCell.m
//  SocialContact
//
//  Created by EDZ on 2019/1/19.
//  Copyright © 2019 ha. All rights reserved.
//

#import "UserImagesCell.h"

@implementation UserImagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUserInfo:(SCUserInfo *)userInfo{
    _userInfo = userInfo;
    if (userInfo) {
        NSArray *images = userInfo.images;
        if (images.count >= 3) {
            [self.img3 sd_setImageWithURL:[NSURL URLWithString:images[2]]];
            
        }else if (images.count >= 2) {
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:images[1]]];
            
        }else if (images.count >= 1) {
            [self.img1 sd_setImageWithURL:[NSURL URLWithString:images[0]]];
            
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
