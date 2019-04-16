//
//  SayHiCell.m
//  SocialContact
//
//  Created by EDZ on 2019/3/28.
//  Copyright © 2019 ha. All rights reserved.
//

#import "SayHiCell.h"

@implementation SayHiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectBtn.selected = YES;
    [self.selectBtn setImage:[UIImage imageNamed:@"ic_btn_selected"] forState:UIControlStateSelected];
    [self.selectBtn setImage:[UIImage imageNamed:@"ic_btn_unselected"] forState:UIControlStateNormal];
    
    self.avatar.layer.cornerRadius = 28.f;
    self.avatar.layer.masksToBounds = YES;
    
}

- (void)setUserModel:(SCUserInfo *)userModel{
    
    _userModel = userModel;
    [self.avatar sc_setImgWithUrl:userModel.avatar_url placeholderImg:@""];
    self.nick.text = userModel.name;
    
    self.selectBtn.selected = userModel.isSelectedSayHi;
    
}

- (IBAction)selectBtnClicked:(id)sender {
    
    self.selectBtn.selected = !self.selectBtn.isSelected;
    _userModel.isSelectedSayHi = self.selectBtn.isSelected;
}

@end
