//
//  BottleCell.h
//  SocialContact
//
//  Created by EDZ on 2019/2/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BottleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property(nonatomic,strong)BottleModel *model;

@end

NS_ASSUME_NONNULL_END
