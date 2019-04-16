//
//  VerifyCodeButton.m
//  ChildEnd
//
//  Created by 孟庆伟 on 2017/7/11.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "VerifyCodeButton.h"

@interface VerifyCodeButton ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@end

@implementation VerifyCodeButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    [self addSubview:self.label];
    _label.text = @"发送验证码";
    [self setTitle:@"" forState:UIControlStateNormal];
    self.backgroundColor = MAIN_COLOR_NEW;
    self.layer.cornerRadius = 5.0;
    self.clipsToBounds = YES;
    [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        if (self.isGray) {
            _label.textColor = [UIColor colorWithRed:58/255.0 green:64/255.0 blue:78/255.0 alpha:1.0];
        }else{
            _label.textColor = [UIColor whiteColor];
        }
        _label.font = [UIFont systemFontOfSize:14];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (void)timeFailBeginFrom:(NSInteger)timeCount {
    
    self.count = timeCount;
    self.enabled = NO;
    // 加1个计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)timerFired {
    if (self.count != 1) {
        self.count -= 1;
        self.enabled = NO;
        self.label.text = [NSString stringWithFormat:@"重新发送(%lds)", self.count];
        if (self.isGray) {
            self.label.textColor = [UIColor colorWithRed:58/255.0 green:64/255.0 blue:78/255.0 alpha:1.0];
            self.backgroundColor = [UIColor colorWithRed:116/255.0 green:123/255.0 blue:140/255.0 alpha:1.0];
            
        }else{
            self.label.textColor = [UIColor whiteColor];
            self.backgroundColor = [UIColor colorWithHexString:@"979797"];
        }
    } else {
        
        self.enabled = YES;
        self.label.text = @"发送验证码";
        self.label.textColor = [UIColor whiteColor];
        self.backgroundColor = MAIN_COLOR_NEW;
        [self.timer invalidate];
    }
}

@end
