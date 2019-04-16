//
//  SelectConditionCell.h
//  SocialContact
//
//  Created by EDZ on 2019/2/13.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectConditionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *conditionT;

@property (nonatomic,strong) SCUserInfo *userInfo;
@property (weak, nonatomic) IBOutlet UILabel *heightT;

@property (weak, nonatomic) IBOutlet UILabel *height;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *ageT;

/**
 职业
 */
@property (weak, nonatomic) IBOutlet UILabel *profession;
@property (weak, nonatomic) IBOutlet UILabel *professionT;

/**
 收入
 */
@property (weak, nonatomic) IBOutlet UILabel *income;
@property (weak, nonatomic) IBOutlet UILabel *incomeT;

/**
 婚姻状况
 */
@property (weak, nonatomic) IBOutlet UILabel *marital_status;
@property (weak, nonatomic) IBOutlet UILabel *marital_statusT;

/**
 有无子女
 */
@property (weak, nonatomic) IBOutlet UILabel *child_status;
@property (weak, nonatomic) IBOutlet UILabel *child_statusT;


/**
 几年内结婚
 */
@property (weak, nonatomic) IBOutlet UILabel *years_to_marry;
@property (weak, nonatomic) IBOutlet UILabel *years_to_marryT;

@end

NS_ASSUME_NONNULL_END
