//
//  AuthenticationConfirmVC.m
//  SocialContact
//
//  Created by EDZ on 2019/2/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "AuthenticationConfirmVC.h"

@interface AuthenticationConfirmVC ()

@end

@implementation AuthenticationConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = Black;

//    WEAKSELF;
//    [self.view jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
//        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(backBtnClicked)]) {
//            [weakSelf.delegate backBtnClicked];
//        }
//    }];
}

- (IBAction)goAuthentication:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(dismiss)]) {
        [_delegate dismiss];
    }
}

- (IBAction)back:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(backBtnClicked)]) {
        [_delegate backBtnClicked];
    }
    
//    [self dismissViewControllerAnimated:NO completion:^{
//
//    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
