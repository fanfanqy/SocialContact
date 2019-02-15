

//
//  NewPasswordViewController.m
//  ChildEnd
//
//  Created by liekkas on 2017/11/15.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "NewPasswordViewController.h"

@interface NewPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation NewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.title = @"新登录密码";
    
    self.confirmBtn.layer.cornerRadius = 7.5;
    self.confirmBtn.layer.masksToBounds = YES;
    
    self.pwdTF.tintColor = MAIN_COLOR;
    
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:self.pwdTF.placeholder?:@""];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0] range:NSMakeRange(0,self.pwdTF.placeholder.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:14]
                        range:NSMakeRange(0, self.pwdTF.placeholder.length)];
    self.pwdTF.attributedPlaceholder = placeholder;
}

- (IBAction)textFieldDidChanged:(UITextField *)sender {
    if (sender.text.length > 20) {
        sender.text = [sender.text substringToIndex:20];
    }
    
    if (sender.text.length <= 20 && sender.text.length >= 6) {
        self.confirmBtn.enabled = YES;
        self.confirmBtn.backgroundColor = MAIN_COLOR;
    } else {
        self.confirmBtn.enabled = NO;
        self.confirmBtn.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0];
    }
}
- (IBAction)clickEye:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        self.pwdTF.secureTextEntry = NO;
    }else{
        self.pwdTF.secureTextEntry = YES;
    }
}

- (IBAction)confirmAction:(UIButton *)sender {
    
    NSDictionary *params = @{
                             @"mobile": _mobile ?: @"",
                             @"password": self.pwdTF.text ? self.pwdTF.text.md5String : @"",
                             @"verificationCode":_code
                             };
    /*
    [DDUserCenter findUserPassword:params complationBlock:^(BOOL succeed, NSError *error) {
        if ( succeed ) {
            [SVProgressHUD showInfoWithStatus:@"您的密码已经重置, 请重新登录。"];
            [SVProgressHUD dismissWithDelay:2];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[AppDelegate app] setRootViewController:INS_NAV([LoginViewController new])];
            });
        } else {
            [SVProgressHUD showImage:ErrorImage status:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:2];
        }
    }];
     */
}

@end
