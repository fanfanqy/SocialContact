//
//  HorzonItemCell.m
//  ShiQi
//
//  Created by fqy on 2017/12/1.
//  Copyright © 2017年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "HorzonItemCell.h"


@implementation HorzonItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    UIView *superView = self.contentView;
    _mCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, superView.width, superView.height)];
    _mCoverView.layer.masksToBounds = YES;
    _mCoverView.contentMode = UIViewContentModeScaleAspectFill;
    _mCoverView.opaque = YES;
    [superView addSubview:_mCoverView];
    
}

- (void)setUrl:(NSString *)url{
    
    if ([url containsString:@"http"]) {
        [_mCoverView sc_setImgWithUrl:url placeholderImg:@""];
    }else{
        [_mCoverView sc_setImgWithUrl:nil placeholderImg:url];
    }
    
}


@end
