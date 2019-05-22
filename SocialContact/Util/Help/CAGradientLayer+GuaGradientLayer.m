//
//  CAGradientLayer+GuaGradientLayer.m
//  GuaGua
//
//  Created by fqy on 2018/5/16.
//  Copyright © 2018年 HuangDeng. All rights reserved.
//

#import "CAGradientLayer+GuaGradientLayer.h"

@implementation CAGradientLayer (GuaGradientLayer)

+ (CAGradientLayer *)createGradientLayerOnView:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
	
		//	CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
	CAGradientLayer *gradientLayer = [CAGradientLayer layer];
	gradientLayer.frame = view.bounds;
	
		//	创建渐变色数组，需要转换为CGColor颜色
	
	gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:fromHexColorStr].CGColor,(__bridge id)[UIColor colorWithHexString:toHexColorStr].CGColor];
	
		//	设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
	gradientLayer.startPoint = startPoint;
	
	gradientLayer.endPoint = endPoint;
	
		//	设置颜色变化点，取值范围 0.0~1.0
	gradientLayer.locations = @[@0,@1];
	
	return gradientLayer;
}
@end
