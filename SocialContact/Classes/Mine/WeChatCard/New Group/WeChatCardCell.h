//
//  WeChatCardCell.h
//  SocialContact
//
//  Created by EDZ on 2019/2/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeChatCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UILabel *account;

@property (strong, nonatomic) ApplyModel *model;

@end

NS_ASSUME_NONNULL_END
