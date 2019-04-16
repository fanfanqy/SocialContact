//
//  MeListTableViewCell.m
//  ChildEnd
//
//  Created by EDZ on 2018/12/12.
//  Copyright © 2018 readyidu. All rights reserved.
//

#import "MeListTableViewCell.h"

@implementation MeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLB.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.subTitleLB.font =  [UIFont fontWithName:@"Heiti SC" size:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
