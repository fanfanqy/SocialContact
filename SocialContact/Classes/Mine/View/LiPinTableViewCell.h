//
//  LiPinTableViewCell.h
//  SocialContact
//
//  Created by EDZ on 2019/2/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPointsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LiPinTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *date;

@property (nonatomic, strong) UserPointsModel *model;

@end

NS_ASSUME_NONNULL_END
