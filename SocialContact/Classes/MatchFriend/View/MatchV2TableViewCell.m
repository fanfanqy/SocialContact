//
//  MatchV2TableViewCell.m
//  SocialContact
//
//  Created by EDZ on 2019/5/7.
//  Copyright © 2019 ha. All rights reserved.
//

#import "MatchV2TableViewCell.h"

@implementation MatchV2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    // Shadow
//    self.bgView.layer.shadowColor = [UIColor colorWithRed:139.0/255.0 green:139/255.0 blue:139/255.0 alpha:0.28].CGColor;
//    self.bgView.layer.shadowOpacity = 1;
//    self.bgView.layer.shadowOffset = CGSizeMake(0, 4);
//    self.bgView.layer.shadowRadius = 5.0;
//    // Corner Radius
//    self.bgView.layer.cornerRadius = 5.0;
//    self.bgView.exclusiveTouch = YES;
    
    self.bgView.layer.shadowColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:0.28].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0,1);
    self.bgView.layer.shadowOpacity = 1;
    self.bgView.layer.shadowRadius = 3;
    self.bgView.layer.cornerRadius = 3.3;
    
}

- (void)setModel:(SCUserInfo *)model{
    
    _model = model;
    
    [self.avatarImg sc_setImgWithUrl: model.avatar_url placeholderImg:@""];
    
    if (model.service_vip_expired_at) {
        NSDate *date = [model.service_vip_expired_at sc_dateWithUTCString];
        NSTimeInterval interval = [date timeIntervalSinceNow];
        if (interval <= 0) {
            self.huiyuanImg.hidden = YES;
        }else{
            self.huiyuanImg.hidden = NO;
        }
    }else{
        self.huiyuanImg.hidden = YES;
    }
    
    if (model.is_idcard_verified) {
        self.renzhengImg.hidden = NO;
    }else{
        self.renzhengImg.hidden = YES;
    }
    
    
    if ([NSString ins_String:model.name]) {
        self.nickL.text = model.name;
    }else{
        self.nickL.text = [NSString stringWithFormat:@"%@",@"--"];
    }
    
    self.genderL.text = [NSString stringWithFormat:@"%@ %ld岁",model.gender == 1 ?@"男":@"女",model.age];
    
    self.heightL.text =  [NSString stringWithFormat:@"身高：%@",[Help height:model.height]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    [(_bgView) performSelector:@selector(setBackgroundColor:) withObject:kGuaCellHightColor afterDelay:0.0];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self touchesRestoreBackgroundColor];
//    if ([self.delegate respondsToSelector:@selector(cellDidClick:)]) {
//        [self.delegate cellDidClick:_indexPath];
//    }
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self touchesRestoreBackgroundColor];
//}
//
//- (void)touchesRestoreBackgroundColor {
//    [NSObject cancelPreviousPerformRequestsWithTarget:_bgView selector:@selector(setBackgroundColor:) object:kGuaCellHightColor];
//    _bgView.backgroundColor = [UIColor whiteColor];
//}

- (IBAction)likeBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(heartBeat:)]) {
        [_delegate heartBeat:_indexPath];
    }
}

- (IBAction)chatBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(chatClick:)]) {
        [_delegate chatClick:_indexPath];
    }
}

@end
