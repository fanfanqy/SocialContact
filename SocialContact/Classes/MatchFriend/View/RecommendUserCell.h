//
//  RecommendUserCell.h
//  SocialContact
//
//  Created by EDZ on 2019/1/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface RecommendUserCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *address;
//@property (weak, nonatomic) IBOutlet UILabel *lastLoginTime;

@property (strong, nonatomic) SCUserInfo *model;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
