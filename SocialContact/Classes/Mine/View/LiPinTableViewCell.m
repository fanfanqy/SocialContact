//
//  LiPinTableViewCell.m
//  SocialContact
//
//  Created by EDZ on 2019/2/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import "LiPinTableViewCell.h"

@implementation LiPinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.title.font = [UIFont fontWithName:@"Heiti SC" size:16];
    self.desc.font =  [UIFont fontWithName:@"Heiti SC" size:20];
    self.amount.font = [[UIFont fontWithName:@"Heiti SC" size:20]fontWithBold];
    self.date.font =  [UIFont fontWithName:@"Heiti SC" size:15];
    
}

- (void)setModel:(UserPointsModel *)model{
    
    
    _model = model;
    self.title.text = model.desc;
//    self.amount.text = [NSString stringWithFormat:@"%ld",model.amount];
    self.desc.text = [NSString stringWithFormat:@"%ld",model.in_or_out];
    
    self.date.text = [_model.create_at sc_timeAgoWithUTCString];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
