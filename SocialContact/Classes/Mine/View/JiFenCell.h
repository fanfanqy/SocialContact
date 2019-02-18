//
//  JiFenCell.h
//  SocialContact
//
//  Created by EDZ on 2019/2/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JiFenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *jifen;

@end

NS_ASSUME_NONNULL_END
