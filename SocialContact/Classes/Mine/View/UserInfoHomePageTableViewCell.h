//
//  UserInfoTableViewCell.h
//  ChildEnd
//
//  Created by EDZ on 2018/12/12.
//  Copyright © 2018 readyidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUserInfo.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UserInfoTableViewCellDelegate <NSObject>

@optional

- (void)rightBtnClick;

- (void)setupBtnClick;

- (void)myGuanZhuClicked;

- (void)myFenSiClicked;

@end

@interface UserInfoHomePageTableViewCell : UITableViewCell

@property(nonatomic,weak)id<UserInfoTableViewCellDelegate> delegate;

@property(nonatomic,strong)UIImageView       *avatarBgImg;

@property(nonatomic,strong)UIImageView       *avatarImg;

@property(nonatomic,strong)UILabel           *nickNameLB;

@property(nonatomic,strong)UIImageView       *genderImg;

@property (strong, nonatomic) UIImageView *huiYuan;

@property(nonatomic,strong)UIImageView       *renzhengImg;

@property(nonatomic,strong)TTTAttributedLabel *introduce;

// 关注
@property(nonatomic,strong)UILabel           *follow;

// 粉丝
@property(nonatomic,strong)UILabel           *followers;

@property(nonatomic,strong)UIButton       *rightArrowImg;

@property(nonatomic,strong)UIButton          *setupBtn;



@property(nonatomic,strong)SCUserInfo          *userModel;

@end

NS_ASSUME_NONNULL_END
