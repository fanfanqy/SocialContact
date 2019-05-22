//
//  GFLCell.h
//  SocialContact
//
//  Created by EDZ on 2019/4/2.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GFLCellDelegate <NSObject>

@optional

- (void)kanguoWoBtnClicked;

- (void)guanzhuWoBtnClicked;

- (void)woguanzhuBtnClicked;

- (void)huxiangGuanZhuBtnClicked;

@end

/*
 关注，粉丝，拉黑
 */
@interface GFLCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *verifyStatusL;

@property (weak, nonatomic) IBOutlet UIButton *lookMeBtn;
@property (weak, nonatomic) IBOutlet UILabel *lookMeCountLB;

@property (weak, nonatomic) IBOutlet UIButton *woGuanzhuBtn;
@property (weak, nonatomic) IBOutlet UILabel *woGuanzhuCountLB;

@property (weak, nonatomic) IBOutlet UIButton *guanzhuWodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *guanzhuWodeCountLB;

@property (weak, nonatomic) IBOutlet UIButton *huxiangGuanZhuBtn;
@property (weak, nonatomic) IBOutlet UILabel *huxiangGuanZhuCountLB;

@property (weak, nonatomic) id<GFLCellDelegate> delegate;

@property(nonatomic,strong)SCUserInfo          *userModel;

@property(nonatomic,assign)NSInteger          lookMeCount;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *introduceL;
@property (weak, nonatomic) IBOutlet YYLabel *nickL;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;

@end

NS_ASSUME_NONNULL_END
