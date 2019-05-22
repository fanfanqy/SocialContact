//
//  UserInfoTableViewCell.m
//  ChildEnd
//
//  Created by EDZ on 2018/12/12.
//  Copyright © 2018 readyidu. All rights reserved.
//

#import "UserInfoHomePageTableViewCell.h"

@implementation UserInfoHomePageTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        [self setViewAtuoLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUserModel:(SCUserInfo *)userModel{
    _userModel = userModel;
    
    UIImage *placeholdImage = nil;
    if (userModel.gender == 0) {
        placeholdImage = [UIImage imageNamed:@""];
    }else if (userModel.gender == 1){
        placeholdImage = [UIImage imageNamed:@"ic_male"];
    }else if (userModel.gender == 2){
        placeholdImage = [UIImage imageNamed:@"ic_women"];
    }
    self.genderImg.image = placeholdImage;
    
    if (self.userModel.service_vip_expired_at) {
        NSDate *date = [self.userModel.service_vip_expired_at sc_dateWithUTCString];
        NSTimeInterval interval = [date timeIntervalSinceNow];
        if (interval < 0) {
            self.huiYuan.hidden = YES;
        }else{
            self.huiYuan.hidden = NO;
        }
    }else{
        self.huiYuan.hidden = YES;
    }
    
    NSString *avatarUrlStr = userModel.avatar_url;
    
    if (userModel.avatar_status == 0) {
        self.avatarImg.image = [UIImage imageNamed:@"verifing"];
    }else if (userModel.avatar_status == 2) {
        self.avatarImg.image = [UIImage imageNamed:@"verifyFailed"];
    }else {
        [self.avatarImg sc_setImgWithUrl:avatarUrlStr placeholderImg:@"icon_default_person"];
    }
    
    self.nickNameLB.text =  userModel.name ?:@"";
    
    self.introduce.text = userModel.intro.length>0 ? [NSString stringWithFormat:@"自我介绍：%@",userModel.intro] :@"暂无自我介绍";

}

- (void)setUpUI
{
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    _avatarBgImg = [UIImageView new];

    _avatarBgImg.layer.masksToBounds = YES;
    
    
    _avatarImg = [UIImageView new];
    _avatarImg.backgroundColor = [UIColor clearColor];
    _avatarImg.layer.cornerRadius = 40;
    _avatarImg.contentMode = UIViewContentModeScaleAspectFit;
//    _avatarImg.layer.borderWidth = 1;
//    _avatarImg.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    _avatarImg.layer.masksToBounds = YES;
    
    _nickNameLB = [UILabel new];
    _nickNameLB.font = [[UIFont fontWithName:@"PingFang SC" size:20]fontWithBold];
    _nickNameLB.textColor = [UIColor colorWithHexString:@"1f2124"];
    
    
    _genderImg = [UIImageView new];
    _genderImg.contentMode = UIViewContentModeScaleAspectFit;
    
    _renzhengImg = [UIImageView new];
    _renzhengImg.contentMode = UIViewContentModeScaleAspectFit;
    _renzhengImg.image = [UIImage imageNamed:@"icon_shen_renzhen"];
    
    _huiYuan = [UIImageView new];
    _huiYuan.image = [UIImage imageNamed:@"ic_huiyuan"];
    _huiYuan.contentMode = UIViewContentModeScaleAspectFit;
    
    
    _introduce = [TTTAttributedLabel new];
    _introduce.lineSpacing = 5.f;
    _introduce.font =  [UIFont fontWithName:@"PingFang SC" size:14];
    _introduce.textColor = Black;
    _introduce.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    _introduce.textAlignment = NSTextAlignmentLeft;
    _introduce.numberOfLines = 0;
    
//    _follow = [UILabel new];
//    _follow.font =  [UIFont fontWithName:@"PingFang SC" size:15];
//    _follow.textColor = RED;
//    _follow.userInteractionEnabled = YES;
//    WEAKSELF;
//    [_follow jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
//        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(myGuanZhuClicked)]) {
//            [weakSelf.delegate myGuanZhuClicked];
//        }
//    }];
//
//    _followers = [UILabel new];
//    _followers.font = [UIFont fontWithName:@"PingFang SC" size:15];
//    _followers.textColor = RED;
//    _followers.userInteractionEnabled = YES;
//    [_followers jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
//        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(myFenSiClicked)]) {
//            [weakSelf.delegate myFenSiClicked];
//        }
//    }];
    
    
    _rightArrowImg = [UIButton new];
    _rightArrowImg.userInteractionEnabled = NO;
    _rightArrowImg.contentMode = UIViewContentModeScaleAspectFit;
    [_rightArrowImg setImage:[UIImage imageNamed:@"arrow-r"] forState:UIControlStateNormal];
    
    
    _setupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setupBtn.contentMode = UIViewContentModeScaleAspectFit;
    _setupBtn.showsTouchWhenHighlighted = YES;
    [_setupBtn setImage:[UIImage imageNamed:@"ic_setting"] forState:UIControlStateNormal];
    [_setupBtn addTarget:self action:@selector(setupBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_avatarBgImg];
    [self.contentView addSubview:_avatarImg];
    [self.contentView addSubview:_nickNameLB];
    [self.contentView addSubview:_genderImg];
    [self.contentView addSubview:_huiYuan];
    [self.contentView addSubview:_renzhengImg];
    [self.contentView addSubview:_introduce];
//    [self.contentView addSubview:_follow];
//    [self.contentView addSubview:_followers];
    [self.contentView addSubview:_rightArrowImg];
    [self.contentView addSubview:_setupBtn];
}


-(void)setViewAtuoLayout
{
    
    
    [_avatarBgImg mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(self).mas_offset(15);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);

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
        
        make.left.mas_equalTo(self.nickNameLB.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.nickNameLB.mas_centerY);
        make.width.height.mas_equalTo(22);
    }];
    
    [_huiYuan mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.genderImg.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.nickNameLB.mas_centerY);
        make.width.height.mas_equalTo(22);
    }];
    
    [_renzhengImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.huiYuan.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.nickNameLB.mas_centerY);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(13);
    }];
    
    [_introduce mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.avatarImg.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.nickNameLB.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self).mas_offset(-15);
        make.bottom.mas_equalTo(self).mas_offset(-10);
    }];
    
//    [_follow mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_equalTo(self.avatarBgImg.mas_right).mas_offset(10);
//        make.top.mas_equalTo(self.avatarBgImg.mas_centerY).mas_offset(10);
//        make.width.mas_greaterThanOrEqualTo(1);
//        make.height.mas_equalTo(20);
//    }];
//
//    [_followers mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.follow.mas_right).mas_offset(15);
//        make.centerY.mas_equalTo(self.follow);
//        make.width.mas_greaterThanOrEqualTo(1);
//        make.height.mas_equalTo(20);
//    }];
    
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
