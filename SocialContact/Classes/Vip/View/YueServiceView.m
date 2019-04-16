//
//  YueServiceView.m
//  SocialContact
//
//  Created by EDZ on 2019/2/28.
//  Copyright © 2019 ha. All rights reserved.
//

#import "YueServiceView.h"

@interface YueServiceView ()

@end

@implementation YueServiceView


- (void)setServiceXianShangYueModel:(ServiceModel *)serviceXianShangYueModel{
    
    _serviceXianShangYueModel = serviceXianShangYueModel;
    
    for (NSInteger i=0; i<serviceXianShangYueModel.pricelist.count; i++) {
        ProductInfoModel *model = serviceXianShangYueModel.pricelist[i];
        if (i == 0) {
            self.xianShangYue.text = model.name;
            self.xianShangPrice.text = [NSString stringWithFormat:@"¥ %.2lf",model.price];
        }
    }
}

- (void)setServiceXianXiaYueModel:(ServiceModel *)serviceXianXiaYueModel{
    
    _serviceXianXiaYueModel = serviceXianXiaYueModel;
    
    for (NSInteger i=0; i<serviceXianXiaYueModel.pricelist.count; i++) {
        ProductInfoModel *model = serviceXianXiaYueModel.pricelist[i];
        if (i == 0) {
            self.xianXiaYue.text = model.name;
            self.xianXiaPrice.text = [NSString stringWithFormat:@"¥ %.2lf",model.price];
        }
    }
}

- (IBAction)xianShangBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(xianShangBtnClicked)]) {
        [_delegate xianShangBtnClicked];
    }
    
    [self.selectXianShang setImage:[UIImage imageNamed:@"yuehui_left_select"] forState:UIControlStateNormal];
    [self.selectXianXia setImage:[UIImage imageNamed:@"yuehui_right_unselect"] forState:UIControlStateNormal];
    
    self.xianShangYue.textColor = YueHuiRed;
    self.xianShangPrice.textColor = YueHuiRed;
    
    self.xianXiaYue.textColor = YD_Color999;
    self.xianXiaPrice.textColor = YD_Color999;
}

- (IBAction)xianXiaBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(xianXiaBtnClicked)]) {
        [_delegate xianXiaBtnClicked];
    }
    
    [self.selectXianShang setImage:[UIImage imageNamed:@"yuehui_left_unselect"] forState:UIControlStateNormal];
    [self.selectXianXia setImage:[UIImage imageNamed:@"yuehui_right_select"] forState:UIControlStateNormal];
    
    self.xianShangYue.textColor = YD_Color999;
    self.xianShangPrice.textColor = YD_Color999;
    
    self.xianXiaYue.textColor = YueHuiRed;
    self.xianXiaPrice.textColor = YueHuiRed;
    
}


- (IBAction)payClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(payClicked)]) {
        [_delegate payClicked];
    }
    
    
}
@end
