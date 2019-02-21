//
//  TopicCell.m
//  SocialContact
//
//  Created by EDZ on 2019/1/12.
//  Copyright © 2019 ha. All rights reserved.
//

#import "TopicCell.h"

@implementation TopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgV.layer.cornerRadius = 4.f;
    self.imgV.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
