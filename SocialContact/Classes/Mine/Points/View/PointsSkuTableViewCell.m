//
//  PointsSkuTableViewCell.m
//  SocialContact
//
//  Created by EDZ on 2019/3/7.
//  Copyright © 2019 ha. All rights reserved.
//

#import "PointsSkuTableViewCell.h"

@implementation PointsSkuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.title.font = [UIFont systemFontOfSize:16];
    self.price.font = [[UIFont systemFontOfSize:20]fontWithBold];
    self.des.font =  [UIFont systemFontOfSize:16];
    self.exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.exchangeBtn.layer.cornerRadius = 5;
    self.exchangeBtn.layer.masksToBounds = YES;
    [self.exchangeBtn setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
}

- (void)setPointsSkuModel:(PointsSkuModel *)pointsSkuModel{
    
    /*
     UIImageView *img;
     UILabel *title;
     UILabel *price;
     UILabel *des;
     UIButton *exchangeBtn;
     */
    _pointsSkuModel = pointsSkuModel;
    [self.img sc_setImgWithUrl:pointsSkuModel.cover_image placeholderImg:@""];
    self.title.text = pointsSkuModel.name;
    self.des.text = pointsSkuModel.des;
    self.price.text = [NSString stringWithFormat:@"%ld",pointsSkuModel.point];
}

- (void)setPointsSkuExchangeModel:(PointsSkuExchange *)pointsSkuExchangeModel{
    
    _pointsSkuExchangeModel = pointsSkuExchangeModel;
    
    [self.exchangeBtn setTitleColor:Black forState:UIControlStateNormal];
    self.exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.exchangeBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    PointsSkuModel *pointsSkuModel = pointsSkuExchangeModel.sku;
    [self.img sc_setImgWithUrl:pointsSkuModel.cover_image placeholderImg:@""];
    self.title.text = pointsSkuModel.name;
    self.des.text = pointsSkuModel.des;

    self.price.text = [NSString stringWithFormat:@"%ld",pointsSkuModel.point];
    
//     0: 提交申请， 1：申请成功， 2： 申请被拒绝
    NSString *statusTitle;
    if (pointsSkuExchangeModel.status == 0) {
        statusTitle = @"申请处理中";
    }else if (pointsSkuExchangeModel.status == 1) {
        statusTitle = @"申请成功";
    }else if (pointsSkuExchangeModel.status == 2) {
        statusTitle = @"申请被拒绝";
    }
    [self.exchangeBtn setTitle:statusTitle forState:UIControlStateNormal];
    
}

- (IBAction)exchangeBtnClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeBtnClicked:)]) {
        if (_pointsSkuModel) {
            [_delegate exchangeBtnClicked:_indexPath];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
