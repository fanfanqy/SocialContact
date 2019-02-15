//
//  SDWeiXinPhotoContainerView.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 459274049
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDWeiXinPhotoContainerView.h"
#import "YYPhotoGroupView.h"
#import "YYControl.h"

#define EvenNumberPadding 15
#define UnevenNumberPadding 7

@interface SDWeiXinPhotoContainerView ()

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation SDWeiXinPhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
		
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
	
	NSInteger maxCount = 9;
	
    for (int i = 0; i < maxCount; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
		imageView.layer.cornerRadius = 4.0;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
		imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = UIColorHex(FCFCFC);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
	
	for (UIImageView *imgView in self.imageViewsArray) {
		[imgView removeFromSuperview];
	}

    self.imageViewsArray = [temp copy];
}

- (void)setPicsArray:(NSArray *)picsArray
{
    _picsArray = picsArray;
    
	CGFloat margin = UnevenNumberPadding;
	
    for (NSInteger i = 0 ; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (picsArray.count == 0) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0);
        return;
    }
    

    WEAKSELF
    [picsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		
        long columnIndex = idx % weakSelf.perRowItemCount;
        long rowIndex = idx / weakSelf.perRowItemCount;
		
        UIImageView *imageView = [weakSelf.imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
		
		NSString *str = picsArray[idx];
		NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",str]];
        [imageView sd_setImageWithURL:url placeholderImage:nil];
		imageView.frame = CGRectMake(columnIndex * (weakSelf.itemW + margin), rowIndex * (weakSelf.itemH + margin), weakSelf.itemW, weakSelf.itemH);
		
    }];
    
//    CGFloat w = weakSelf.perRowItemCount * weakSelf.itemW + (weakSelf.perRowItemCount - 1) * margin;
//    int columnCount = ceilf(picsArray.count * 1.0 / weakSelf.perRowItemCount);
//    CGFloat h = columnCount * weakSelf.itemH + (columnCount - 1) * margin;

    //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h);
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *fromView = nil;
    NSMutableArray * items = [NSMutableArray array];
    for (int i = 0; i < _picsArray.count; i++) {
        UIView * imgView = _imageViewsArray[i];
        YYPhotoGroupItem * item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = [NSURL URLWithString:_picsArray[i]];
        [items addObject:item];
        if (i == tap.view.tag) {
            fromView = imgView;
        }
    }
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.window animated:YES completion:nil];
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    CGFloat margin = UnevenNumberPadding;
    NSInteger perRowItemCount = 3;
    if (array.count < 3) {
        perRowItemCount = array.count;
        return (self.width - margin)/2.0;
    }else if(array.count == 4){
        perRowItemCount = 2;
        return (self.width - margin)/2.0;
    }else{
        perRowItemCount = 3;
        return (self.width - 2*margin)/3.0;
    }
    return (self.width - margin)/2.0;
}

+ (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    
    NSInteger perRowItemCount = 3;
    if (array.count < 3) {
        perRowItemCount = array.count;
        
    }else if(array.count == 4){
        perRowItemCount = 2;
        
    }else{
        perRowItemCount = 3;
        
    }
    return perRowItemCount;
}

+ (CGSize)getContainerSize:(NSArray *)picsArray width:(CGFloat)width{
    
    CGFloat margin = UnevenNumberPadding;
    NSInteger perRowItemCount = 2;
    NSInteger columnCount = 1;
    if (picsArray.count > 4) {
        perRowItemCount = 3;
    }
    if (picsArray.count <= 3) {
        columnCount = 1;
    }else if (picsArray.count <= 6) {
        columnCount = 2;
    }else if (picsArray.count){
        columnCount = 3;
    }
    CGFloat itemW = (width - (perRowItemCount-1)*margin) / perRowItemCount;
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    
    CGFloat h = columnCount * itemW + (columnCount - 1) * margin;
    
    return CGSizeMake(w, h);
}

+ (CGFloat)itemWidth:(NSArray *)array width:(CGFloat)width{
    CGFloat margin = UnevenNumberPadding;
    NSInteger perRowItemCount = 3;
    if (array.count < 3) {
        perRowItemCount = array.count;
        return (width - margin)/2.0;
    }else if(array.count == 4){
        perRowItemCount = 2;
        return (width - margin)/2.0;
    }else{
        perRowItemCount = 3;
        return (width - 2*margin)/3.0;
    }
    return (width - margin)/2.0;
}

@end
