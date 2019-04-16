//
//  MatchTableViewCell.h
//  SocialContact
//
//  Created by EDZ on 2019/1/16.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MatchTableViewCellDelegate <NSObject>

@optional

- (void)heartBeat:(NSIndexPath *)indexPath;

- (void)chatClick:(NSIndexPath *)indexPath;

@end

@interface MatchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *loveDeclaration;
@property (weak, nonatomic) IBOutlet UILabel *ageGender;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *otherInfo;
@property (weak, nonatomic) IBOutlet UILabel *years_to_marry;
@property (weak, nonatomic) IBOutlet UIButton *heartBeatBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIImageView *vipImg;

@property (strong, nonatomic) SCUserInfo *model;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic)  id <MatchTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
