//
//  AuthenticationVC.m
//  SocialContact
//
//  Created by EDZ on 2019/2/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "AuthenticationVC.h"
#import "AuthenticationConfirmVC.h"
@interface AuthenticationVC ()<AuthenticationConfirmVCDelegate>
@property (weak, nonatomic) IBOutlet UIView *caijiBgView;

@property (strong, nonatomic) AuthenticationConfirmVC *authenticationConfirmVC;
@end

@implementation AuthenticationVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self createCustomTitleView:@"人证对比" backgroundColor:nil rightItem:nil backContainAlpha:NO];
    
    _authenticationConfirmVC =  [[AuthenticationConfirmVC alloc]initWithNibName:@"AuthenticationConfirmVC" bundle:nil];
    _authenticationConfirmVC.delegate = self;
//    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//    [self presentViewController:vc animated:NO completion:nil];
    [self.view addSubview:_authenticationConfirmVC.view];
}

- (void)backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismiss{
    
    WEAKSELF;
    self.authenticationConfirmVC.view.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:.3 animations:^{
        
      weakSelf.authenticationConfirmVC.view.top += kScreenHeight;
    } completion:^(BOOL finished) {
        
        [weakSelf.authenticationConfirmVC.view removeFromSuperview];
    }];
    
}

- (void)viewDidLayoutSubviews{
    
    CAShapeLayer *border = [CAShapeLayer layer];
    
    //虚线的颜色
    border.strokeColor = [UIColor redColor].CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    //设置路径
    border.path = [UIBezierPath bezierPathWithRect:self.caijiBgView.bounds].CGPath;
    
    border.frame = self.caijiBgView.bounds;
    //虚线的宽度
    border.lineWidth = 1.f;
    
    
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    
    [self.caijiBgView.layer addSublayer:border];
    
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
