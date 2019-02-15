//
//  NearByUserCell.h
//  SocialContact
//
//  Created by EDZ on 2019/1/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NearByUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *last_RequestTime;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *personalSignature;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@property (strong, nonatomic) SCUserInfo *userInfo;

@end

NS_ASSUME_NONNULL_END
