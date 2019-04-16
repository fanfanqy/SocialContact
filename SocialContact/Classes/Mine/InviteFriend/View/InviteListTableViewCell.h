//
//  InviteListTableViewCell.h
//  SocialContact
//
//  Created by EDZ on 2019/2/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteFriendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InviteListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *num;

@property (weak, nonatomic)  InviteFriendModel *model;

@end

NS_ASSUME_NONNULL_END
