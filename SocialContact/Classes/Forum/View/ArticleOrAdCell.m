//
//  ArticleOrAdCell.m
//  SocialContact
//
//  Created by EDZ on 2019/2/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import "ArticleOrAdCell.h"

@implementation ArticleOrAdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 10, kScreenWidth-20, 200) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    
    maskLayer.frame = CGRectMake(0, 0, kScreenWidth-20, 200);
    maskLayer.path = maskPath.CGPath;
    self.img.layer.mask = maskLayer;
    
}

- (void)setModel:(ArticleOrAdModel *)model{
    
    _model = model;
    [self.img sc_setImgWithUrl:_model.bgimage_url placeholderImg:@""];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
