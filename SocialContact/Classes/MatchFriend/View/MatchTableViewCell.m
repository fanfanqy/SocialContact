//
//  MatchTableViewCell.m
//  SocialContact
//
//  Created by EDZ on 2019/1/16.
//  Copyright © 2019 ha. All rights reserved.
//

#import "MatchTableViewCell.h"

@implementation MatchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    // Shadow
    self.bgView.layer.shadowColor = [UIColor colorWithRed:39.0/255.0 green:52/255.0 blue:56/255.0 alpha:0.15].CGColor;
    self.bgView.layer.shadowOpacity = 1;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 6);
    self.bgView.layer.shadowRadius = 6.0;
    // Corner Radius
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.exclusiveTouch = YES;
    
    self.img.layer.cornerRadius = 8.0;
    self.img.layer.masksToBounds = YES;
    
    self.address.layer.borderColor = Font_color333.CGColor;
    self.address.layer.borderWidth = .5;
    self.address.layer.cornerRadius = 10.f;
    
    self.heartBeatBtn.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:15];
    self.chatBtn.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:15];
    
    self.address.font = [UIFont fontWithName:@"Heiti SC" size:13];
    self.loveDeclaration.font = [UIFont fontWithName:@"Heiti SC" size:13];
    self.otherInfo.font = [UIFont fontWithName:@"Heiti SC" size:13];
    
    self.nick.font = [[UIFont fontWithName:@"Heiti SC" size:17] fontWithBold];
}

- (void)setModel:(SCUserInfo *)model{
    
    _model = model;

    
    [self.img sc_setImgWithUrl: model.avatar_url placeholderImg:@""];
    
    
    if ([NSString ins_String:model.name]) {
        self.nick.text = model.name;
    }else{
        self.nick.text = [NSString stringWithFormat:@"%@",@"--"];
    }
    
    self.loveDeclaration.text = model.intro;
    self.ageGender.text = [NSString stringWithFormat:@"%@ %ld",model.gender == 1 ?@"男":@"女",model.age];
    if ([NSString ins_String:model.address_home]) {
        self.address.text = [NSString stringWithFormat:@"  %@  ",model.address_home];
    }else{
        self.address.text = [NSString stringWithFormat:@"  %@  ",@"--"];
    }
    
    if (model.service_vip_expired_at) {
        NSDate *date = [model.service_vip_expired_at sc_dateWithUTCString];
        NSTimeInterval interval = [date timeIntervalSinceNow];
        if (interval <= 0) {
            self.vipImg.hidden = YES;
        }else{
            self.vipImg.hidden = NO;
        }
    }else{
        self.vipImg.hidden = YES;
    }
    
    self.otherInfo.text = [Help height:model.height];
//    [NSString stringWithFormat:@"%.0lf·%ld·%@",model.height,model.income,@"双子座"];

}

- (IBAction)heartBeat:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(heartBeat:)]) {
        [_delegate heartBeat:_indexPath];
    }
    
}

- (IBAction)chatClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(chatClick:)]) {
        [_delegate chatClick:_indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
