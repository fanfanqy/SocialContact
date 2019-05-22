//
//  UserInfoHomePageCell.h
//  SocialContact
//
//  Created by EDZ on 2019/2/13.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoHomePageCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *nick;
//@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (weak, nonatomic) IBOutlet UIView *tagView;
//@property (weak, nonatomic) IBOutlet UIImageView *huiYuan;
@property (weak, nonatomic) IBOutlet UILabel *selfIntroduce;

@property (assign, nonatomic) CGFloat tagHeight;

@property (nonatomic,strong) SCUserInfo *userInfo;

+ (CGFloat)calculateTagHeight:(SCUserInfo *)userInfo;

@end

NS_ASSUME_NONNULL_END
