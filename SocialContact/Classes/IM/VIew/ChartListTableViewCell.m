//
//  ChartListTableViewCell.m
//  ChildEnd
//
//  Created by 陈康 on 2018/1/23.
//  Copyright © 2018年 readyidu. All rights reserved.
//

#import "ChartListTableViewCell.h"

@implementation ChartListTableViewCell

- (void)setDataModel:(RCConversationModel *)model {
    [super setDataModel:model];
    self.model = model;
    [self.contentView.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.constant == 11.0 && (obj.firstAttribute == NSLayoutAttributeTop || obj.firstAttribute == NSLayoutAttributeBottom)) {
            obj.constant = 16;
        }
        
    }];

}

- (UIImageView *)genderImg{
    if (!_genderImg) {
        _genderImg = [UIImageView new];
        _genderImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _genderImg;
}

- (UIImageView *)renzhengImg{
    if (!_renzhengImg) {
        _renzhengImg = [UIImageView new];
        _renzhengImg.contentMode = UIViewContentModeScaleAspectFit;
        _renzhengImg.image = [UIImage imageNamed:@"icon_shen_renzhen"];
    }
    return _renzhengImg;
}

- (UIImageView *)huiYuan{
    if (!_huiYuan) {
        _huiYuan = [UIImageView new];
        _huiYuan.contentMode = UIViewContentModeScaleAspectFit;
        _huiYuan.image = [UIImage imageNamed:@"ic_huiyuan"];
    }
    return _huiYuan;
}

@end
