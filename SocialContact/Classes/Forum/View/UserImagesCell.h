//
//  UserImagesCell.h
//  SocialContact
//
//  Created by EDZ on 2019/1/19.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserImagesCell : UITableViewCell

@property (nonatomic,strong) SCUserInfo *userInfo;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;

@end

NS_ASSUME_NONNULL_END
