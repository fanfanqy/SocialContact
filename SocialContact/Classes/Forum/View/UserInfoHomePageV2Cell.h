//
//  UserInfoHomePageV2Cell.h
//  SocialContact
//
//  Created by EDZ on 2019/5/8.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoHomePageV2Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (weak, nonatomic) IBOutlet UIImageView *huiYuan;
@property (weak, nonatomic) IBOutlet UIImageView *renZheng;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *years_to_marry;


@property (nonatomic,strong) SCUserInfo *userInfo;

@end

NS_ASSUME_NONNULL_END
