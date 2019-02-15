
//
//  RetrieveViewController.m
//  ChildEnd
//
//  Created by liekkas on 2017/11/15.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "RetrieveViewController.h"
#import "VerifyCodeButton.h"
#import "NewPasswordViewController.h"

@interface RetrieveViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet VerifyCodeButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation RetrieveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.phone.length == 11) {
        self.phoneTF.text = self.phone;
        self.codeBtn.enabled = YES;
        self.codeBtn.backgroundColor = MAIN_COLOR;
    }
}
- (void)setup {
    self.title = @"找回登录密码";
    
    self.nextBtn.layer.cornerRadius = 7.5;
    self.nextBtn.layer.masksToBounds = YES;
    
    self.phoneTF.tintColor = MAIN_COLOR;
    self.codeTF.tintColor = MAIN_COLOR;
    
    self.codeBtn.enabled = NO;
    self.codeBtn.backgroundColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0];
    
    self.nextBtn.backgroundColor = [UIColor colorWithHexString:@"979797"];
    
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:self.phoneTF.placeholder?:@""];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0] range:NSMakeRange(0,self.phoneTF.placeholder.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:14]
                        range:NSMakeRange(0, self.phoneTF.placeholder.length)];
    self.phoneTF.attributedPlaceholder = placeholder;
    
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:self.codeTF.placeholder?:@""];
    [placeholder1 addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0] range:NSMakeRange(0,self.codeTF.placeholder.length)];
    [placeholder1 addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:14]
                         range:NSMakeRange(0, self.codeTF.placeholder.length)];
    self.codeTF.attributedPlaceholder = placeholder1;
}

- (IBAction)textFieldDidChanged:(UITextField *)sender {
    if (sender == self.phoneTF) {
        if (sender.text.length > 11) {
            sender.text = [sender.text substringToIndex:11];
        }else if (sender.text.length < 11){
            self.codeBtn.enabled = NO;
            self.codeBtn.backgroundColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0];
        }else{
            if ([self.codeBtn.label.text isEqualToString:@"发送验证码"]) {
                self.codeBtn.enabled = YES;
                self.codeBtn.backgroundColor = MAIN_COLOR;
            }
        }
    }
    if (sender == self.codeTF) {
        if (sender.text.length > 6) {
            sender.text = [sender.text substringToIndex:6];
        }
    }
    
    if (self.phoneTF.text.length == 11 && self.codeTF.text.length == 6) {
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = MAIN_COLOR;
    } else {
        self.nextBtn.enabled = NO;
        self.nextBtn.backgroundColor =[UIColor colorWithHexString:@"979797"];
    }
}
- (IBAction)sendCodeAction:(VerifyCodeButton *)sender {
    
    if ( self.phoneTF.text.length != 11 ) {
        [SVProgressHUD showInfoWithStatus:@"请输入11位的手机号码！"];
        [SVProgressHUD dismissWithDelay:2];
        return ;
    }
    
    // 发送验证码
    [SVProgressHUD show];
    NSDictionary *params = @{
                             @"mobile": self.phoneTF.text,
                             @"verifyType": @"forget"
                             };
    @weakify(self);
    /*
    [DDUserCenter getVerifyCode:params complationBlock:^(BOOL succeed, NSError *error) {
        @normalize(self);
        if (succeed) {
            [SVProgressHUD showImage:SuccessImage status:@"验证码发送成功"];
            [SVProgressHUD dismissWithDelay:2];
            [self.codeBtn timeFailBeginFrom:60];
        } else {
            [SVProgressHUD showImage:ErrorImage status:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:2];
        }
    }];
     */
}
- (IBAction)nextAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (!self.codeTF.text || self.codeTF.text.length == 0) {
        return;
    }
    NSString *content = self.codeTF.text;
    NSDictionary *params = @{
                             @"mobile": self.phoneTF.text ?: @"",
                             @"registerCode": content ?: @""
                             };
    [SVProgressHUD show];
    /*
    [DDUserCenter checkVerifyCode:params complationBlock:^(BOOL succeed, NSError *error) {
        if ( !succeed ) {
            [SVProgressHUD showImage:ErrorImage status:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:2];
        } else {
            [SVProgressHUD dismiss];
            NewPasswordViewController *vc = [[NewPasswordViewController alloc] init];
            vc.mobile = self.phoneTF.text;
            vc.code = content;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
     */
}

@end

