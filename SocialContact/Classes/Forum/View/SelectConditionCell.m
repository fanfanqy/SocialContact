//
//  SelectConditionCell.m
//  SocialContact
//
//  Created by EDZ on 2019/2/13.
//  Copyright © 2019 ha. All rights reserved.
//

#import "SelectConditionCell.h"

@implementation SelectConditionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUserInfo:(SCUserInfo *)userInfo{
    
    self.height.text = [NSString stringWithFormat:@"%.1lfcm",userInfo.height];
    self.age.text = [NSString stringWithFormat:@"%ld岁",userInfo.age];
    
    self.profession.text = [Help profession:userInfo.profession];
    self.income.text = [Help income:userInfo.income];
    
    self.marital_status.text = [Help marital_status:userInfo.marital_status];
    self.child_status.text = [Help child_status:userInfo.child_status];
    self.years_to_marry.text = [Help yearsToMarial:userInfo.years_to_marry];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
