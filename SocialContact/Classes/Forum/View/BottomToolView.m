//
//  BottomToolView.m
//  SocialContact
//
//  Created by EDZ on 2019/1/20.
//  Copyright © 2019 ha. All rights reserved.
//

#import "BottomToolView.h"

@interface BottomToolView ()

@end

@implementation BottomToolView


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.partiBtn.layer.cornerRadius = self.partiBtn.height/2.0;
    self.joinBtn.layer.cornerRadius = self.partiBtn.height/2.0;
    self.partiBtn.layer.masksToBounds = YES;
    self.joinBtn.layer.masksToBounds = YES;
    [self.partiBtn setBackgroundImage:[UIImage imageWithColor:BLUE] forState:UIControlStateNormal];
    [self.joinBtn setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
    
    if (self.type == 1) {
        [self.partiBtn setTitle:@"  对话" forState:UIControlStateNormal];
        [self.joinBtn setTitle:@"  加关注" forState:UIControlStateNormal];
        [self.partiBtn setImage:[UIImage imageNamed:@"ic_chat_white"] forState:UIControlStateNormal];
        [self.joinBtn setImage:[UIImage imageNamed:@"ic_guanzhu_white"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)partiClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(partiClick)]) {
        [_delegate partiClick];
    }
    
}

- (IBAction)joinClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(joinClick)]) {
        [_delegate joinClick];
    }
}

#pragma mark ------------------LifeCycle------------------

#pragma mark ------------------Network------------------

#pragma mark ------------------Event------------------

#pragma mark ------------------Lazy------------------

@end
