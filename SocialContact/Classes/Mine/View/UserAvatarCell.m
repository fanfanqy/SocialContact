//
//  UserAvatarCell.m
//  SocialContact
//
//  Created by EDZ on 2019/2/16.
//  Copyright © 2019 ha. All rights reserved.
//

#import "UserAvatarCell.h"

@implementation UserAvatarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImg.layer.cornerRadius = 40.f;
    self.avatarImg.layer.masksToBounds = YES;
    self.titleL.font = [UIFont systemFontOfSize:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
