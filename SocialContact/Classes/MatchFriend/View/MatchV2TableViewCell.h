//
//  MatchV2TableViewCell.h
//  SocialContact
//
//  Created by EDZ on 2019/5/7.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MatchV2TableViewCellDelegate <NSObject>

@optional

- (void)heartBeat:(NSIndexPath *)indexPath;

- (void)chatClick:(NSIndexPath *)indexPath;

- (void)cellDidClick:(NSIndexPath *)indexPath;

@end

@interface MatchV2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *huiyuanImg;
@property (weak, nonatomic) IBOutlet UIImageView *renzhengImg;
@property (weak, nonatomic) IBOutlet UILabel *nickL;
@property (weak, nonatomic) IBOutlet UILabel *genderL;
@property (weak, nonatomic) IBOutlet UILabel *heightL;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

@property (strong, nonatomic) SCUserInfo *model;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic)  id <MatchV2TableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
