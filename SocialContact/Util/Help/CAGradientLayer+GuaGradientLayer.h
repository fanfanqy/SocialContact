//
//  CAGradientLayer+GuaGradientLayer.h
//  GuaGua
//
//  Created by fqy on 2018/5/16.
//  Copyright © 2018年 HuangDeng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAGradientLayer (GuaGradientLayer)

+ (CAGradientLayer *)createGradientLayerOnView:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
