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
}

- (void)setModel:(MomentModel *)model{
    
    _model = model;
    
//    @property (weak, nonatomic) IBOutlet UIImageView *img;
//    @property (weak, nonatomic) IBOutlet UILabel *nickName;
//    @property (weak, nonatomic) IBOutlet UILabel *loveDeclaration;
//    @property (weak, nonatomic) IBOutlet UILabel *ageGender;
//    @property (weak, nonatomic) IBOutlet UILabel *address;
//    @property (weak, nonatomic) IBOutlet UILabel *otherInfo;
//    @property (weak, nonatomic) IBOutlet UILabel *loveGoal;
    NSString *avatarUrl = @"";
    if ([NSString ins_String:model.avatar_url]) {
        avatarUrl = model.avatar_url;
    }
    [self.img sd_setImageWithURL:[NSURL URLWithString:avatarUrl]];
    self.nick.text = model.name;
    self.loveDeclaration.text = model.intro;
    self.ageGender.text = [NSString stringWithFormat:@"%@ %ld",model.gender == 1 ?@"男":@"女",model.age];
    self.address.text = model.address;
    self.otherInfo.text = [NSString stringWithFormat:@"%.0lf·%ld·%@",model.height,model.income,@"双子座"];
//    NSDate *date = [NSDate dateWithISOFormatString:_model.last_request_at];
//    self.lastLoginTime.text =  [WBStatusHelper stringWithTimelineDate:date];
    
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
