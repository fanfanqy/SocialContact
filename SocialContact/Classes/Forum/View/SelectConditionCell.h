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

@property (nonatomic,strong) SCUserInfo *userInfo;

@property (weak, nonatomic) IBOutlet UILabel *height;
@property (weak, nonatomic) IBOutlet UILabel *age;

/**
 职业
 */
@property (weak, nonatomic) IBOutlet UILabel *profession;

/**
 收入
 */
@property (weak, nonatomic) IBOutlet UILabel *income;

/**
 婚姻状况
 */
@property (weak, nonatomic) IBOutlet UILabel *marital_status;

/**
 有无子女
 */
@property (weak, nonatomic) IBOutlet UILabel *child_status;


/**
 几年内结婚
 */
@property (weak, nonatomic) IBOutlet UILabel *years_to_marry;

@end

NS_ASSUME_NONNULL_END
