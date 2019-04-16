//
//  CashingVC.m
//  SocialContact
//
//  Created by EDZ on 2019/3/29.
//  Copyright © 2019 ha. All rights reserved.
//

#import "CashingVC.h"

@interface CashingVC ()
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *amount;

@end

@implementation CashingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cashBtn.layer.cornerRadius = 22.5;
    [self.cashBtn setBackgroundImage:[UIImage imageWithColor:BLUE] forState:UIControlStateNormal];
    
    self.title = @"申请提现";
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
}

- (IBAction)cashBtnClick:(id)sender {
    
    if (![NSString ins_String:self.account.text]) {
        
        [self.view makeToast:@"请输入支付宝账号" duration:2 position:CSToastPositionCenter];
        return;
    }
    
    if (![NSString ins_String:self.account.text]) {
        
        [self.view makeToast:@"请输入提现金额" duration:2 position:CSToastPositionCenter];
        return;
    }
    
    [self goCash];
    
}

- (void)goCash{
    
    NSDictionary *dic = @{
                          @"alipay_account":self.account.text,
                          @"amount":[NSNumber numberWithInteger:[self.account.text integerValue]],
                          };
    WEAKSELF;
    [self.view makeToastActivity:CSToastPositionCenter];
    
    POSTRequest *request = [POSTRequest requestWithPath:@"/api/withdraw/" parameters:dic completionHandler:^(InsRequest *request) {
        
        [weakSelf.view hideToastActivity];
        if (request.error) {
            
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
            
        }else{
            
            weakSelf.amount.text = @"";
            
            [SVProgressHUD showImage:AlertSuccessImage status:@"提现请求已发送"];
            [SVProgressHUD dismissWithDelay:1.5];
            
        }
        
    }];
    [InsNetwork addRequest:request];
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
