
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
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;

@end

@implementation RetrieveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)setup {
    self.title = @"重置密码";
    
    self.nextBtn.layer.cornerRadius = 7.5;
    self.nextBtn.layer.masksToBounds = YES;
    
    self.phoneTF.tintColor = MAIN_COLOR;
    self.codeTF.tintColor = MAIN_COLOR;
    self.passWordTF.tintColor = MAIN_COLOR;
    
//    self.codeBtn.enabled = NO;
//    self.codeBtn.backgroundColor = ORANGE;
    
    self.nextBtn.backgroundColor = ORANGE;
    
    self.phoneTF.placeholder = self.phoneTF.placeholder?:@"";
    

    self.codeTF.placeholder = self.codeTF.placeholder?:@"";
}

- (IBAction)textFieldDidChanged:(UITextField *)sender {
    if (sender == self.phoneTF) {
        if (sender.text.length > 11) {
            sender.text = [sender.text substringToIndex:11];
        }else if (sender.text.length < 11){
            self.codeBtn.enabled = NO;
            self.codeBtn.backgroundColor = ORANGE;
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
    if (sender == self.passWordTF) {
        
    }
    
//    if (self.phoneTF.text.length == 11 && self.codeTF.text.length == 6 && self.passWordTF.text.length >= 6) {
//        self.nextBtn.enabled = YES;
//        self.nextBtn.backgroundColor = MAIN_COLOR;
//    } else {
//        self.nextBtn.enabled = NO;
//        self.nextBtn.backgroundColor =MAIN_COLOR;
//    }
    
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
                             @"account": self.phoneTF.text,
                             };
    
    WEAKSELF;
    POSTRequest *request = [POSTRequest requestWithPath:@"/sms/" parameters:params?:nil completionHandler:^(InsRequest *request) {
        
        [SVProgressHUD dismiss];
        
        if (!request.error) {
            [SVProgressHUD showImage:AlertSuccessImage status:@"验证码发送成功"];
            [SVProgressHUD dismissWithDelay:2];
            [weakSelf.codeBtn timeFailBeginFrom:60];
        }else{
            
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:2];
        }
        
        
    }];
    [InsNetwork addRequest:request];
}
- (IBAction)nextAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![NSString ins_String:self.phoneTF.text]) {
        [self.view makeToast:@"请输入手机号"];
        return;
    }else if (self.phoneTF.text.length != 11){
        [self.view makeToast:@"请检查手机号格式"];
        return;
    }
    if (![NSString ins_String:self.codeTF.text]) {
        [self.view makeToast:@"请输入验证码"];
        return;
    }
    if (![NSString ins_String:self.passWordTF.text]) {
        [self.view makeToast:@"请输入密码"];
        return;
    }
    
//    NSString *content = self.codeTF.text;
    NSDictionary *params = @{
                             @"account":self.phoneTF.text ?: @"",
                             @"code":self.codeTF.text ?: @"",
                             @"password": self.passWordTF.text ?: @"",
                             };
    [SVProgressHUD show];
    WEAKSELF;
    POSTRequest *request = [POSTRequest requestWithPath:@"/customer/password/" parameters:params completionHandler:^(InsRequest *request) {
        
        [SVProgressHUD dismiss];
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            [weakSelf.view makeToast:@"重置成功"];
        }
        
    }];
    [InsNetwork addRequest:request];
}

@end

