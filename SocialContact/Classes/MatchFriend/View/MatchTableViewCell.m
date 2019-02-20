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
    self.bgView.layer.cornerRadius = 6.0;
    self.bgView.exclusiveTouch = YES;
    
    self.img.layer.cornerRadius = 6.0;
    self.img.layer.masksToBounds = YES;
    
    self.address.layer.borderColor = [UIColor blackColor].CGColor;
    self.address.layer.borderWidth = 1.f;
    self.address.layer.cornerRadius = 10.f;
}

- (void)setModel:(SCUserInfo *)model{
    
    _model = model;

    NSString *avatarUrl = @"";
    if ([NSString ins_String:model.avatar_url]) {
        avatarUrl = model.avatar_url;
    }
    [self.img sd_setImageWithURL:[NSURL URLWithString:avatarUrl]];
    self.nick.text = model.name;
//    self.loveDeclaration.text = model.intro;
    self.ageGender.text = [NSString stringWithFormat:@"%@ %ld",model.gender == 1 ?@"男":@"女",model.age];
    self.address.text = [NSString stringWithFormat:@" %@ ",model.address_home];
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
