//
//  InviteListTableViewCell.m
//  SocialContact
//
//  Created by EDZ on 2019/2/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "InviteListTableViewCell.h"

@implementation InviteListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(InviteFriendModel *)model{
    
    _model = model;
    
    // 邀请人
    self.title.text = model.invited.name;
    
//    self.num.text = @"¥2";
    
//    NSDate *date = [NSDate dateWithISOFormatString:_model.create_at];
//    self.date.text =  [WBStatusHelper stringWithTimelineDate:date];
    
    self.date.text = [_model.create_at sc_timeAgoWithUTCString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
