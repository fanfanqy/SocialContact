//
//  NearByUserCell.h
//  SocialContact
//
//  Created by EDZ on 2019/1/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUserInfo.h"
#import "Notice.h"
#import "WhoLookMeModel.h"
#import "UserPointsModel.h"
#import "FollowsModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol NearByUserCellDelegate <NSObject>

@optional

- (void)clickAvatarImg:(NSInteger)userID;

@end

@interface NearByUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet YYLabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *last_RequestTime;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *personalSignature;
@property (weak, nonatomic) IBOutlet UILabel *distance;



/**
 通知
 */
@property (strong, nonatomic) Notice *notice;

/**
 附近的人
 */
@property (strong, nonatomic) SCUserInfo *userInfo;

@property (strong, nonatomic) WhoLookMeModel *lookMeModel;

@property (strong, nonatomic) UserPointsModel *userPointsModel;

@property (strong, nonatomic) FollowsModel *followsModel;

@property (assign, nonatomic) NSInteger userId;

@property (weak, nonatomic) id<NearByUserCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
