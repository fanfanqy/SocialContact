//
//  ForgetViewController.m
//  ChildEnd
//
//  Created by dylan on 2017/2/17.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()

@property ( nonatomic, strong ) UILabel *label_tip;
@property ( nonatomic, strong ) UITextField *field_mobile;
@property ( nonatomic, strong ) UIButton *button_nextStep;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setup];
}

#pragma mark -

- (void) sendVerifyCode {
	[self.view endEditing:YES];
    
    if ( _field_mobile.text.length != 11 ) {
        [SVProgressHUD showInfoWithStatus:@"请输入11位的手机号码！"];
        [SVProgressHUD dismissWithDelay:1];
        return ;
    }
    [SVProgressHUD show];
    /*
    [DDUserCenter getVerifyCode:@{
                                  @"mobile": _field_mobile.text,
                                  @"verifyType": @"forget"
                                  }
                complationBlock:^(BOOL succeed, NSError *error) {
                    if (succeed) {
                        [SVProgressHUD dismiss];
                        VerifyCodeViewController *vvc = [[VerifyCodeViewController alloc] init];
                        vvc.isPay = self.isPay;
                        vvc.verifyType = VerifyCode_type_ResetPassword;
                        vvc.phoneNumber = _field_mobile.text;
                        [self.navigationController pushViewController:vvc animated:YES];
                    } else {
                        [SVProgressHUD showImage:ErrorImage status:error.localizedDescription];
                        [SVProgressHUD dismissWithDelay:2];
                    }
    }];
     */
}

#pragma mark -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

#pragma mark -

- (void) setup {
    

    self.title = @"忘记密码";
    
    self.view.backgroundColor = BackGroundColor;
	_label_tip = [[UILabel alloc] init];
	_label_tip.text = @"输入你已绑定的手机号码";
    _label_tip.font = [UIFont systemFontOfSize:15];
	_label_tip.textColor = Font_color3;
    _label_tip.backgroundColor = BackGroundColor;
    _label_tip.frame = CGRectMake(15, 15, kScreenWidth, 40);
	[self.view addSubview:_label_tip];

	UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, _label_tip.bottom + 10, kScreenWidth, 50)];
	leftView.text = @"   中国(86)";
	leftView.font = [UIFont systemFontOfSize:15];
	leftView.textAlignment = NSTextAlignmentLeft;
    leftView.backgroundColor = [UIColor whiteColor];
    leftView.textColor = Font_color2;
    [self.view addSubview:leftView];
    
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, leftView.bottom, kScreenWidth, 50)];
    leftLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftLabel];
    
	_field_mobile = [[UITextField alloc] init];
	_field_mobile.font = [UIFont systemFontOfSize:15];
	_field_mobile.placeholder = @"请输入手机号码";
    _field_mobile.textColor = Font_color2;
    _field_mobile.backgroundColor = [UIColor whiteColor];
	_field_mobile.keyboardType = UIKeyboardTypePhonePad;
	_field_mobile.leftViewMode = UITextFieldViewModeAlways;
    _field_mobile.frame = CGRectMake(16, leftView.bottom, kScreenWidth, 50);
	[self.view addSubview:_field_mobile];

	_button_nextStep = [[UIButton alloc] init];
	[_button_nextStep setTitle:@"下一步" forState:UIControlStateNormal];
	[_button_nextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	_button_nextStep.titleLabel.font = [UIFont systemFontOfSize:17];
	[_button_nextStep setBackgroundColor:MAIN_COLOR_NEW];
    _button_nextStep.frame = CGRectMake(20, _field_mobile.bottom + 55, kScreenWidth - 40, 44);
	_button_nextStep.layer.cornerRadius = 3;
	_button_nextStep.layer.masksToBounds = YES;
	[_button_nextStep addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_button_nextStep];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, leftView.bottom, kScreenWidth - 30, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"e9e9ea"];
    [self.view addSubview:lineView];

}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
