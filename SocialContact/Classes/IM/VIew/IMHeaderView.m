//
//  IMHeaderView.m
//  SocialContact
//
//  Created by EDZ on 2019/1/19.
//  Copyright © 2019 ha. All rights reserved.
//

#import "IMHeaderView.h"

@interface IMHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *nearbyBtn;
@property (weak, nonatomic) IBOutlet UIButton *driftingBottleBtn;
@property (weak, nonatomic) IBOutlet UIButton *loveSkillBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteFriendBtn;

@end

@implementation IMHeaderView

- (void)layoutSubviews{
    
    self.nearbyBtn.layer.cornerRadius = self.nearbyBtn.width/2.0;
    self.nearbyBtn.layer.masksToBounds = YES;
    
    self.driftingBottleBtn.layer.cornerRadius = self.nearbyBtn.width/2.0;
    self.driftingBottleBtn.layer.masksToBounds = YES;
    
    self.loveSkillBtn.layer.cornerRadius = self.nearbyBtn.width/2.0;
    self.loveSkillBtn.layer.masksToBounds = YES;
    
    self.inviteFriendBtn.layer.cornerRadius = self.nearbyBtn.width/2.0;
    self.inviteFriendBtn.layer.masksToBounds = YES;
    
    
    [self.nearbyBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:kIMNearByBtnBackgroundColor]] forState:UIControlStateNormal];
    
    [self.driftingBottleBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:kIMDriftingBottleBtnBackgroundColor]] forState:UIControlStateNormal];
    
    [self.loveSkillBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:kIMLoveSkillBtnBackgroundColor]] forState:UIControlStateNormal];
    
    [self.inviteFriendBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:kIMInviteFriendBtnBackgroundColor]] forState:UIControlStateNormal];
}


- (IBAction)nearbyUser:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(nearbyUserCLick)]) {
        [_delegate nearbyUserCLick];
    }
}

- (IBAction)driftingBottle:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(driftingBottleCLick)]) {
        [_delegate driftingBottleCLick];
    }
}

- (IBAction)loveSkill:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loveSkillCLick)]) {
        [_delegate loveSkillCLick];
    }
}

- (IBAction)inviteFriend:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(inviteFriendCLick)]) {
        [_delegate inviteFriendCLick];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark ------------------LifeCycle------------------

#pragma mark ------------------Network------------------

#pragma mark ------------------Event------------------

#pragma mark ------------------Lazy------------------

@end
