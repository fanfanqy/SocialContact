//
//  UserInfoTableViewCell.m
//  ChildEnd
//
//  Created by EDZ on 2018/12/12.
//  Copyright © 2018 readyidu. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        [self setViewAtuoLayout];
    }
    return self;
}

- (void)setUserModel:(SCUserInfo *)userModel{
    _userModel = userModel;
    
    UIImage *placeholdImage = nil;
    if (userModel.gender == 1) {
        placeholdImage = [UIImage imageNamed:@"icon_default_person"];
    }else if (userModel.gender == 2){
        placeholdImage = [UIImage imageNamed:@"icon_default_person"];
    }else if (userModel.gender == 0){
        placeholdImage = [UIImage imageNamed:@"icon_default_person"];
    }
    
    
    if ([NSString ins_String:userModel.avatar_url]) {
        
        BOOL containsImage = [[YYWebImageManager sharedManager].cache containsImageForKey:userModel.avatar_url];
        
        if (containsImage) {
            placeholdImage = [[YYWebImageManager sharedManager].cache getImageForKey:userModel.avatar_url];
        }
    
    }else{
        self.avatarImg.image = placeholdImage;
        
    }
    
    NSString *avatarUrlStr = userModel.avatar_url;
    if ([NSString ins_String:avatarUrlStr]) {
        [self.avatarImg setImageWithURL:[NSURL URLWithString:avatarUrlStr] placeholder:placeholdImage options:YYWebImageOptionRefreshImageCache completion:nil];
    }

    self.nickNameLB.text =  userModel.name;
    self.follow.text = [NSString stringWithFormat:@"关注：%ld",userModel.following_count];
    self.followers.text = [NSString stringWithFormat:@"粉丝：%ld",userModel.followers_count];
//    self.genderImg.image = [UIImage imageNamed:[NSString getImageStrWithSex:userModel.sex] inBundle:Bundle compatibleWithTraitCollection:nil];
}

- (void)setUpUI
{
    _avatarBgImg = [UIImageView new];

    _avatarBgImg.layer.masksToBounds = YES;
    
    
    _avatarImg = [UIImageView new];
    _avatarImg.backgroundColor = [UIColor clearColor];
    _avatarImg.layer.cornerRadius = 32;
    _avatarImg.contentMode = UIViewContentModeScaleAspectFill;
//    _avatarImg.layer.borderWidth = 1;
//    _avatarImg.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    _avatarImg.layer.masksToBounds = YES;
    
    _nickNameLB = [UILabel new];
    _nickNameLB.font = [UIFont systemFontOfSize:18];
    _nickNameLB.textColor = [UIColor colorWithHexString:@"333333"];
    
    
    _genderImg = [UIImageView new];
    
    _follow = [UILabel new];
    _follow.font =  [UIFont systemFontOfSize:13];
    _follow.textColor = [UIColor colorWithHexString:@"999999"];
    
    
    _followers = [UILabel new];
    _followers.font = [UIFont systemFontOfSize:13];
    _followers.textColor = [UIColor colorWithHexString:@"999999"];
    
    _rightArrowImg = [UIButton new];
    _rightArrowImg.userInteractionEnabled = NO;
    _rightArrowImg.contentMode = UIViewContentModeScaleAspectFit;
    [_rightArrowImg setImage:[UIImage imageNamed:@"arrow-r"] forState:UIControlStateNormal];
    
    
    _setupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setupBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_setupBtn setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
    [_setupBtn addTarget:self action:@selector(setupBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_avatarBgImg];
    [self.contentView addSubview:_avatarImg];
    [self.contentView addSubview:_nickNameLB];
    [self.contentView addSubview:_genderImg];
    [self.contentView addSubview:_follow];
    [self.contentView addSubview:_followers];
    [self.contentView addSubview:_rightArrowImg];
    [self.contentView addSubview:_setupBtn];
}


-(void)setViewAtuoLayout
{
    
    
    [_avatarBgImg mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(self).mas_offset(15);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(64);

    }];
    
    [_avatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.avatarBgImg);
        make.right.mas_equalTo(self.avatarBgImg);
        make.top.mas_equalTo(self.avatarBgImg);
        make.bottom.mas_equalTo(self.avatarBgImg);
        
    }];
    
    [_nickNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.avatarBgImg.mas_right).mas_offset(10);
        make.width.mas_greaterThanOrEqualTo(35);
        make.bottom.mas_equalTo(self.avatarBgImg.mas_centerY).mas_offset(-4);
        make.height.mas_equalTo(20);
    }];
    
    [_genderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.nickNameLB.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.nickNameLB.mas_centerY);
        make.width.height.mas_equalTo(22);
    }];
    
    [_follow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.avatarBgImg.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.avatarBgImg.mas_centerY).mas_offset(4);
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [_followers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.follow.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.follow);
        make.width.mas_greaterThanOrEqualTo(1);
        make.height.mas_equalTo(20);
    }];
    
    [_rightArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self).mas_offset(-15);
        make.centerY.mas_equalTo(self.avatarBgImg);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
    }];
    
    [_setupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self).mas_offset(-15);
        make.top.mas_equalTo(self).mas_offset(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    
}


- (void)rightBtnClick{
    
}

- (void)setupBtnClick{
    if (_delegate && [_delegate respondsToSelector:@selector(setupBtnClick)]) {
        [_delegate setupBtnClick];
    }
}


@end
