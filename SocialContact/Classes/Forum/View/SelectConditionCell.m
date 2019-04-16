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
    
    self.conditionT.font = [UIFont fontWithName:@"Heiti SC" size:16];
    self.height.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.heightT.font =  [UIFont fontWithName:@"Heiti SC" size:15];
    self.age.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.ageT.font =  [UIFont fontWithName:@"Heiti SC" size:15];
    self.profession.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.professionT.font =  [UIFont fontWithName:@"Heiti SC" size:15];
    self.marital_status.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.marital_statusT.font =  [UIFont fontWithName:@"Heiti SC" size:15];
    self.income.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.incomeT.font =  [UIFont fontWithName:@"Heiti SC" size:15];
    
    self.child_status.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.child_statusT.font =  [UIFont fontWithName:@"Heiti SC" size:15];
    self.years_to_marry.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.years_to_marryT.font =  [UIFont fontWithName:@"Heiti SC" size:15];
}

- (void)setUserInfo:(SCUserInfo *)userInfo{
    
#pragma mark TODO 择偶标准
    _userInfo = userInfo;
    
    self.height.text = [Help height:userInfo.height];
    self.age.text = [Help age:userInfo.age];
    
    self.profession.text = [Help profession:userInfo.profession];
    self.income.text = [Help income:userInfo.income];
    
    self.marital_status.text = [Help marital_status:userInfo.marital_status];
    self.child_status.text = [Help child_status:userInfo.child_status];
    self.years_to_marry.text = [Help yearsToMarial:userInfo.years_to_marry];
 
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfo.condition];
  
    NSArray *ageRange = dic[@"age_range"];
    if (ageRange.count == 2) {
        self.age.text = [NSString stringWithFormat:@"%ld岁—%ld岁",[ageRange[0] integerValue],[ageRange[1] integerValue]];
    }else{
        self.age.text = @"不限";
        
    }
    
    NSArray *heightRange = dic[@"height_range"];
    if (heightRange.count == 2) {
        if ([heightRange[0] integerValue]== 0 || [heightRange[1] integerValue]) {
            self.height.text  = @"不限";
        }else{
            self.height.text = [NSString stringWithFormat:@"%ldcm—%ldcm",[heightRange[0] integerValue],[heightRange[1] integerValue]];
        }
    }else{
        self.height.text  = @"不限";
    }
    
    NSInteger profession = [dic[@"profession"] integerValue];
    if (profession == 0) {
        self.profession.text = @"不限";
        
    }else{
        self.profession.text = [Help profession:profession];
    }
    
    
    NSInteger income = [dic[@"income"] integerValue];
    if (income == 0) {
        self.income.text = @"不限";
        
    }else{
        self.income.text = [Help income:income];
    }
    
    NSInteger marital_status = [dic[@"marital_status"] integerValue];
    if (marital_status == 0) {
        self.marital_status.text  = @"不限";
       
    }else{
        self.marital_status.text  = [Help marital_status:marital_status];
    }
    
    
    NSInteger child_status = [dic[@"child_status"] integerValue];
    if (child_status == 0) {
        self.child_status.text = @"不限";
        
    }else{
        self.child_status.text = [Help child_status:child_status];
    }
    
    NSInteger years_to_marry = [dic[@"years_to_marry"] integerValue];
    if (years_to_marry == 0) {
        self.years_to_marry.text= @"不限";
    }else{
        self.years_to_marry.text = [Help yearsToMarial:years_to_marry];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
