//
//  LoginViewController.m
//  ChildEnd
//
//  Created by dylan on 2017/2/16.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "LoginViewController.h"

#import "AppDelegate.h"

#import "VerifyCodeButton.h"
#import "RetrieveViewController.h"

#import "CommonWebViewController.h"
//#import "YDShareView.h"
#import "FillUserInfoVC.h"

#import "GeRenZiLiaoVC.h"

@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate>

//@property ( nonatomic, strong ) UIImageView *avatarImageView;

@property ( nonatomic, strong ) UILabel *titleLB;

@property ( nonatomic, strong ) UITextField *username;
@property ( nonatomic, strong ) UITextField *password;
@property ( nonatomic, strong ) UIButton *loginButton;
@property ( nonatomic, strong ) UIButton *registe;
@property ( nonatomic, strong ) UIButton *forget;

/** url按钮 */
@property (strong, nonatomic) UILabel *usageGovButton;

/** 下拉按钮 */
@property (strong, nonatomic) UIButton *checkUser;

/** 遥控器 */
@property (strong, nonatomic) UIView *remoteControl;

/** 账号列表 */
@property (strong, nonatomic) UITableView *userListTableView;

/** 账号数据 */
@property (strong, nonatomic) NSMutableArray *userList;

@property ( nonatomic, strong ) UIScrollView *scrollView;
@property ( nonatomic, strong ) UIView *vcRegistView;
@property ( nonatomic, strong ) UIView *pwdLoginView;
@property ( nonatomic, strong ) UITextField *phoneTF;
@property ( nonatomic, strong ) UITextField *vcPWTF;
@property ( nonatomic, strong ) UITextField *vcInviteCodeTF;
@property ( nonatomic, strong ) UITextField *vcTF;
@property (strong, nonatomic) VerifyCodeButton *sendVcBtn;

@end

@implementation LoginViewController

+ (void)mineLogin:(NSDictionary *)params {
    
}

+ (void)loginSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SVProgressHUD showImage:AlertSuccessImage status:@"登录成功"];
        [SVProgressHUD dismissWithDelay:2];
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self setup];
    [self checkHideUserAction];
    
    WEAKSELF;
    [self.view jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weakSelf.view endEditing:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    
    if (self.phoneTF.text.length == 11) {
        self.sendVcBtn.enabled = YES;
        self.sendVcBtn.backgroundColor = MAIN_COLOR;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    if (self.checkUser.selected) {
        [self checkUserList:self.checkUser];
    }
}

#pragma mark - 登录功能
- (void) loginAction {
    [self.view endEditing:YES];
    
    // 手机号注册
    if (self.scrollView.contentOffsetX == 0) {
        if (_phoneTF.text.length != 11) {
            [SVProgressHUD showInfoWithStatus:@"手机号码格式错误"];
            [SVProgressHUD dismissWithDelay:2];
            return;
        }
        
        if (_vcPWTF.text.length == 0 || _vcPWTF.text.length < 6) {
            [SVProgressHUD showInfoWithStatus:@"密码格式错误"];
            [SVProgressHUD dismissWithDelay:2];
            return;
        }
        
        if (_vcTF.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
            [SVProgressHUD dismissWithDelay:2];
            return;
        }
        
        
        [SVProgressHUD show];
        
        NSDictionary *params = @{@"account":self.phoneTF.text?:@"",@"password":_vcPWTF.text?:@"",@"code":self.vcTF.text?:@"",@"invitecode":self.vcInviteCodeTF.text?:@""
                                 };
        WEAKSELF;
        POSTRequest *request = [POSTRequest requestWithPath:@"customer/enroll/" parameters:params?:nil completionHandler:^(InsRequest *request) {
           
            [SVProgressHUD dismiss];
            
            if (!request.error) {
                
                [SVProgressHUD showImage:AlertSuccessImage status:@"注册成功，请登录"];
                [SVProgressHUD dismissWithDelay:2];
                
                UIButton *tempBtn = [UIButton new];
                tempBtn.tag = 5;
                [weakSelf switchLogin:tempBtn];
                
            }else {
                
                [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
                [SVProgressHUD dismissWithDelay:2];
                
                
            }
        }];
        [InsNetwork addRequest:request];
        
        return;
    }
    
    // 密码登录
    if (_username.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"账号不能为空"];
        [SVProgressHUD dismissWithDelay:2];
        return;
    }
    
    if (_password.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"密码不能为空"];
        [SVProgressHUD dismissWithDelay:2];
        return;
    }
    
    [SVProgressHUD show];
    NSDictionary *params = @{@"account":self.username.text,@"password":self.password.text,
                           };
    WEAKSELF;
    POSTRequest *request = [POSTRequest requestWithPath:@"/customer/login/" parameters:params?:nil completionHandler:^(InsRequest *request) {
        
        [SVProgressHUD dismiss];
        if (!request.error) {
            
            [[SCUserCenter sharedCenter] saveUser:weakSelf.username.text];
            [weakSelf loginSucced:request.responseObject];
            [LoginViewController loginSuccess];
            
        }else {
            
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
        
        }
    }];
    [InsNetwork addRequest:request];
}

// 登录成功
- (void)loginSucced:(id)responseObject {
   
    NSString *account = self.username.text;
    
    if ([NSString ins_String:account]) {
        
        [[SCUserCenter sharedCenter] saveUser:account];
        
        /*
         "data": {
         "user_id": 2,
         "name": "",
         "im_token": ""
         }
         */
        SCUser *user = [SCUser modelWithDictionary:responseObject[@"data"]];
        [SCUserCenter sharedCenter].currentUser = user;
        [[SCUserCenter sharedCenter].currentUser updateToDB];
        
        WEAKSELF;
        [SCUserCenter getSelfInformationAndUpdateDBWithUserId:[responseObject[@"data"][@"id"] integerValue] completion:^(id  _Nonnull responseObj, BOOL succeed, NSError * _Nonnull error) {
            
            if ([SCUserCenter sharedCenter].currentUser.userInfo.name.length == 0 || [SCUserCenter sharedCenter].currentUser.userInfo.avatar_url.length == 0 || [SCUserCenter sharedCenter].currentUser.userInfo.gender == 0) {
                
                [weakSelf GoFillUserInfoVC];
                
            }else{
                
                [[AppDelegate sharedDelegate]configRootVC];
            }
            
            
        }];
        
    }

}

- (void)GoFillUserInfoVC{
    
//    FillUserInfoVC *vc = [[FillUserInfoVC alloc]initWithNibName:@"FillUserInfoVC" bundle:nil];
//    vc.title = @"完善信息";
//    [self.navigationController pushViewController:vc animated:YES];
//
    GeRenZiLiaoVC *vc = [GeRenZiLiaoVC new];
    vc.title = @"完善个人信息";
    vc.vcType = 1;
    vc.userModel = [SCUserCenter sharedCenter].currentUser.userInfo;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark -

- (void) registAction {
    [self.view endEditing:YES];
//    BindMobileViewController *vc = [BindMobileViewController bindMobileViewController];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void) forgetAction {
    [self.view endEditing:YES];
    
    RetrieveViewController *vc = [[RetrieveViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITabelView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    cell.textLabel.text = self.userList[indexPath.row];
    UIButton *clear = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [clear setImage:[UIImage imageNamed:@"guanbi_icon"] forState:UIControlStateNormal];
    WEAKSELF;
    [clear jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            WEAKSELF;
            NSString *title = [NSString stringWithFormat:@"确定删除账号：%@ 吗？",self.userList[indexPath.row]];
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:title cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
//                    [[DDUserCenter sharedCenter] removeUser:self.userList[indexPath.row]];
                    [weakSelf.userList removeObjectAtIndex:indexPath.row];
                    [weakSelf.userListTableView reloadData];
                    [weakSelf checkHideUserAction];
                }
            } otherButtonTitles:@"确认删除", nil];
            sheet.destructiveButtonIndexSet = [NSIndexSet indexSetWithIndex:1];
            [sheet show];
        });
    }];
    cell.accessoryView = clear;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.username.text = self.userList[indexPath.row];
    [self checkUserList:self.checkUser];
}

#pragma mark -


- (void)checkUserList:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self.view endEditing:YES];
    [self.userListTableView reloadData];
    self.userListTableView.hidden = !btn.selected;
}

- (void)checkHideUserAction {
    if (self.userList.count == 0) {
        self.checkUser.hidden = YES;
        self.userListTableView.hidden = YES;
    }
}

- (void)checkEye:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.password.secureTextEntry = NO;
    } else {
        self.password.secureTextEntry = YES;
    }
}

#pragma mark -

- (void) setup {
    self.fd_prefersNavigationBarHidden = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName :[UIColor colorWithHexString:@"555"],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Heiti SC" size:18]
                                                                      }];
    self.view.backgroundColor = BackGroundColor;
    
    _titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    _titleLB.text = @"手机注册";
    _titleLB.font = [[UIFont fontWithName:@"Heiti SC" size:30]fontWithBold];
    _titleLB.textColor = [UIColor colorWithHexString:@"1f2124"];
    [self.view addSubview:_titleLB];
    
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).offset(45);
        make.top.equalTo(self.view).offset(GuaTopHeight);
        make.width.mas_equalTo(310);
        make.height.mas_equalTo(50);
    }];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(320);
        make.top.mas_equalTo(_titleLB.mas_bottom);
    }];

    //验证码登录view
    UIView *vcRegistView = [[UIView alloc] init];
    [scrollView addSubview:vcRegistView];
    
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.font = [UIFont fontWithName:@"Heiti SC" size:17];
    _phoneTF = phoneTF;
    
    NSString *holderText2 = @"手机号";
    phoneTF.placeholder = holderText2;
    phoneTF.textColor = [UIColor colorWithHexString:@"1f2124"];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.leftViewMode = UITextFieldViewModeAlways;
    phoneTF.rightViewMode = UITextFieldViewModeAlways;
    phoneTF.tintColor = MAIN_COLOR;
    [phoneTF addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [vcRegistView addSubview:phoneTF];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = YD_Color999;
    [vcRegistView addSubview:lineView1];
    
    UITextField *vcPWTF = [[UITextField alloc] init];
    vcPWTF.font = [UIFont fontWithName:@"Heiti SC" size:17];
    _vcPWTF = vcPWTF;
    
    NSString *holderRegistPWText3 = @"密码";
    vcPWTF.placeholder = holderRegistPWText3;
    vcPWTF.textColor = [UIColor colorWithHexString:@"1f2124"];
    vcPWTF.keyboardType = UIKeyboardTypeASCIICapable;
    vcPWTF.leftViewMode = UITextFieldViewModeAlways;
    vcPWTF.rightViewMode = UITextFieldViewModeAlways;
    vcPWTF.tintColor = MAIN_COLOR;
    [vcPWTF addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [vcRegistView addSubview:vcPWTF];
    
    UIView *lineRegistPWView = [[UIView alloc] init];
    lineRegistPWView.backgroundColor = YD_Color999;
    [vcRegistView addSubview:lineRegistPWView];
    
    
    UITextField *vcTF = [[UITextField alloc] init];
    vcTF.font = [UIFont fontWithName:@"Heiti SC" size:17];
    _vcTF = vcTF;
    NSString *holderText3 = @"请输入验证码";
    vcTF.placeholder = holderText3;
    vcTF.textColor = [UIColor colorWithHexString:@"1f2124"];
    vcTF.keyboardType = UIKeyboardTypeNumberPad;
    vcTF.tintColor = MAIN_COLOR;
    [vcTF addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [vcRegistView addSubview:vcTF];
    
    VerifyCodeButton *sendVcBtn = [[VerifyCodeButton alloc] init];
//    sendVcBtn.enabled = NO;
    sendVcBtn.isGray = YES;
    
    sendVcBtn.label.textColor = [UIColor whiteColor];
    sendVcBtn.backgroundColor = ORANGE;
    sendVcBtn.layer.cornerRadius = 7.5;
    sendVcBtn.layer.masksToBounds = YES;
    sendVcBtn.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:17];
    [sendVcBtn addTarget:self action:@selector(codeBtnVerification) forControlEvents:UIControlEventTouchUpInside];
    [vcRegistView addSubview:sendVcBtn];
    _sendVcBtn = sendVcBtn;
    
    UIView *lineView_register = [[UIView alloc] init];
    lineView_register.backgroundColor = YD_Color999;
    [vcRegistView addSubview:lineView_register];
    
    
    UITextField *vcInviteCodeTF = [[UITextField alloc] init];
    vcInviteCodeTF.font = [UIFont fontWithName:@"Heiti SC" size:17];
    _vcInviteCodeTF = vcInviteCodeTF;
    NSString *holderInviteCodePWText3 = @"请输入邀请码（可选项）";
    vcInviteCodeTF.placeholder = holderInviteCodePWText3;
    vcInviteCodeTF.textColor = [UIColor colorWithHexString:@"1f2124"];
    vcInviteCodeTF.keyboardType = UIKeyboardTypeDefault;
    vcInviteCodeTF.leftViewMode = UITextFieldViewModeAlways;
    vcInviteCodeTF.rightViewMode = UITextFieldViewModeAlways;
    vcInviteCodeTF.tintColor = MAIN_COLOR;
    [vcInviteCodeTF addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [vcRegistView addSubview:vcInviteCodeTF];
    
    UIView *lineRegistInviteCodeView = [[UIView alloc] init];
    lineRegistInviteCodeView.backgroundColor = YD_Color999;
    [vcRegistView addSubview:lineRegistInviteCodeView];
    
    
    UIButton *pwdLoginBtn = [[UIButton alloc] init];
    [pwdLoginBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
    [pwdLoginBtn setTitleColor:Font_color333 forState:UIControlStateNormal];
    pwdLoginBtn.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:16];
    pwdLoginBtn.tag = 5;
    [pwdLoginBtn addTarget:self action:@selector(switchLogin:) forControlEvents:UIControlEventTouchUpInside];
    [vcRegistView addSubview:pwdLoginBtn];
    
    UIView *line_pwdLoginBtn = [[UIView alloc] init];
    line_pwdLoginBtn.backgroundColor = YD_Color999;
    [vcRegistView addSubview:line_pwdLoginBtn];
    
    //账号密码登录view
    UIView *pwdLoginView = [[UIView alloc] init];
    [scrollView addSubview:pwdLoginView];
    _pwdLoginView = pwdLoginView;
    
    [vcRegistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView);
        make.top.equalTo(scrollView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(scrollView.mas_height);
    }];
    
    
    [pwdLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vcRegistView.mas_right);
        make.top.equalTo(scrollView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(scrollView.mas_height);
    }];
    
    scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"xia_img_home"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"shang_img_home"] forState:UIControlStateSelected];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 23, 0, 0);
    [button addTarget:self action:@selector(checkUserList:) forControlEvents:UIControlEventTouchUpInside];
    _checkUser = button;
    
    _username = [[UITextField alloc] init];
    _username.font = [UIFont fontWithName:@"Heiti SC" size:17];
    NSString *holderText = @"请输入账号/手机号";
//    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
//    [placeholder addAttribute:NSForegroundColorAttributeName
//                        value:[UIColor colorWithHexString:@"1f2124"]
//                        range:NSMakeRange(0, holderText.length)];
//    [placeholder addAttribute:NSFontAttributeName
//                        value:[UIFont systemFontOfSize:14]
//                        range:NSMakeRange(0, holderText.length)];
//    _username.attributedPlaceholder = placeholder;
    _username.placeholder = holderText;
    _username.textColor = [UIColor colorWithHexString:@"1f2124"];
    _username.keyboardType = UIKeyboardTypeNamePhonePad;
    _username.leftViewMode = UITextFieldViewModeAlways;
    _username.rightView = button;
    _username.rightViewMode = UITextFieldViewModeAlways;
    _username.tintColor = MAIN_COLOR;
    [_username addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [pwdLoginView addSubview:_username];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = YD_Color999;
    [pwdLoginView addSubview:lineView];
    
    UILabel *leftView_pass = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 45)];
    leftView_pass.text = @"密码";
    leftView_pass.font = [UIFont fontWithName:@"Heiti SC" size:14];
    leftView_pass.textAlignment = NSTextAlignmentLeft;
    leftView_pass.textColor = [UIColor colorWithHexString:@"ffffff"];
    
    _password = [[UITextField alloc] init];
    _password.font = [UIFont fontWithName:@"Heiti SC" size:17];
    _password.secureTextEntry = YES;
    
    UIButton *eyes = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    eyes.imageEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [eyes setImage:[UIImage imageNamed:@"biyan_icon_home"] forState:UIControlStateNormal];
    [eyes setImage:[UIImage imageNamed:@"yanjing_icon_home"] forState:UIControlStateSelected];
    [eyes addTarget:self action:@selector(checkEye:) forControlEvents:UIControlEventTouchUpInside];
    NSString *holderText1 = @"请输入密码";

    _password.placeholder = holderText1;
    _password.textColor = [UIColor colorWithHexString:@"1f2124"];
//    _password.leftView = leftView_pass;
//    _password.leftViewMode = UITextFieldViewModeAlways;
    _password.tintColor = MAIN_COLOR;
    _password.rightView = eyes;
    _password.rightViewMode = UITextFieldViewModeAlways;
    [_password addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [pwdLoginView addSubview:_password];
    
    UIView *lineView_password = [[UIView alloc] init];
    lineView_password.backgroundColor = YD_Color999;
    [pwdLoginView addSubview:lineView_password];
    
    UIButton *vcLoginBtn = [[UIButton alloc] init];
    [vcLoginBtn setTitle:@"手机注册" forState:UIControlStateNormal];
    [vcLoginBtn setTitleColor:Font_color333 forState:UIControlStateNormal];
    vcLoginBtn.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:16];
    vcLoginBtn.tag = 6;
    [vcLoginBtn addTarget:self action:@selector(switchLogin:) forControlEvents:UIControlEventTouchUpInside];
    [pwdLoginView addSubview:vcLoginBtn];
    
    UIView *line_vcLoginBtn = [[UIView alloc] init];
    line_vcLoginBtn.backgroundColor = YD_Color999;
    [pwdLoginView addSubview:line_vcLoginBtn];
    
    _forget = [[UIButton alloc] init];
    [_forget setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forget setTitleColor:Font_color333 forState:UIControlStateNormal];
    _forget.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:16];
    [_forget addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
    [pwdLoginView addSubview:_forget];
    
    UIView *line_forget = [[UIView alloc] init];
    line_forget.backgroundColor = YD_Color999;
    [pwdLoginView addSubview:line_forget];
    
    _loginButton = [[UIButton alloc] init];
    _loginButton.enabled = NO;
    [_loginButton setTitle:@"注册" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    _loginButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:17];
    [_loginButton setBackgroundColor:ORANGE];
    _loginButton.layer.cornerRadius = 22;
    _loginButton.layer.masksToBounds = YES;
    [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    [_username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.width.mas_equalTo(kScreenWidth - 90);
        make.height.mas_equalTo(45);
        make.top.equalTo(pwdLoginView).with.offset(15);
    }];
    
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.width.mas_equalTo(kScreenWidth - 90);
        make.height.mas_equalTo(45);
        make.top.equalTo(pwdLoginView).with.offset(15);
    }];
    

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_username);
        make.height.mas_equalTo(.7);
        make.top.equalTo(_username.mas_bottom);
    }];
    
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(phoneTF);
        make.height.mas_equalTo(.7);
        make.top.equalTo(_username.mas_bottom);
    }];
    
    
    
    [vcPWTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneTF);
        make.right.equalTo(phoneTF);
        make.height.equalTo(phoneTF);
        make.top.equalTo(_username.mas_bottom).with.offset(25);
    }];
    
    
    [sendVcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneTF);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(32.5);
        make.top.equalTo(vcPWTF.mas_bottom).with.offset(25);
    }];
    
    [vcInviteCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneTF);
        make.right.equalTo(phoneTF);
        make.height.equalTo(phoneTF);
        make.top.equalTo(sendVcBtn.mas_bottom).with.offset(25);
    }];
    
    [lineRegistInviteCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(vcInviteCodeTF);
        make.height.mas_equalTo(.7);
        make.top.equalTo(vcInviteCodeTF.mas_bottom);
    }];
    
    [vcTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneTF);
        make.right.equalTo(sendVcBtn.mas_left).offset(-10);
        make.height.equalTo(phoneTF);
        make.centerY.equalTo(sendVcBtn);
    }];
    
    
    
    [lineRegistPWView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneTF);
        make.right.equalTo(phoneTF);
        make.height.mas_equalTo(.7);
        make.top.equalTo(vcPWTF.mas_bottom);
    }];
    
    
    
    [lineView_register mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneTF);
        make.right.equalTo(vcTF);
        make.height.mas_equalTo(.7);
        make.top.equalTo(vcTF.mas_bottom);
    }];
    
    [pwdLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vcTF);
        make.top.equalTo(lineRegistInviteCodeView.mas_bottom).offset(15);
    }];
    
    [line_pwdLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(pwdLoginBtn);
        make.top.equalTo(pwdLoginBtn.mas_bottom).offset(-6);
        make.height.mas_equalTo(.7);
    }];
    
    [_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.width.mas_equalTo(kScreenWidth - 90);
        make.height.mas_equalTo(45);
        make.top.equalTo(_username.mas_bottom).with.offset(25);
    }];
    
    [lineView_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_username);
        make.height.mas_equalTo(.7);
        make.top.equalTo(_password.mas_bottom);
    }];
    
    [vcLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_password);
        make.top.equalTo(_password.mas_bottom).offset(15);
    }];
    
    [line_vcLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(vcLoginBtn);
        make.top.equalTo(vcLoginBtn.mas_bottom).offset(-6);
        make.height.mas_equalTo(.7);
    }];
    
    [_forget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView_password);
        make.top.equalTo(_password.mas_bottom).offset(15);
    }];
    
    [line_forget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_forget);
        make.top.equalTo(_forget.mas_bottom).offset(-6);
        make.height.mas_equalTo(.7);
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.width.mas_equalTo(kScreenWidth - 90);
        make.height.mas_equalTo(45);
        make.top.equalTo(pwdLoginBtn.mas_bottom).offset(15);
//        make.top.equalTo(_password.mas_bottom).with.offset(kScreenWidth < 375 ? 60 : 80+100);
        
    }];
    
    [self.usageGovButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(45);
        make.height.mas_offset(45);
        make.right.mas_offset(45);
        make.top.equalTo(_loginButton.mas_bottom).mas_offset(15);
    }];
    

}

- (void)textFieldDidChanged:(UITextField *)tf {
    if (self.scrollView.contentOffsetX == 0) {
        
        if (tf == self.phoneTF) {
            if (tf.text.length > 11) {
                tf.text = [tf.text substringToIndex:11];
            }else if (tf.text.length < 11){
//                self.sendVcBtn.enabled = NO;
                self.sendVcBtn.label.textColor = [UIColor whiteColor];
                self.sendVcBtn.backgroundColor = ORANGE;
            }else{
                if ([self.sendVcBtn.label.text isEqualToString:@"发送验证码"]) {
//                    self.sendVcBtn.enabled = YES;
                    self.sendVcBtn.label.textColor = [UIColor whiteColor];
                    self.sendVcBtn.backgroundColor = MAIN_COLOR;
                }
            }
        }
        
        if (tf == self.vcTF) {
            if (tf.text.length > 6) {
                tf.text = [tf.text substringToIndex:6];
            }
        }
        
        if (self.phoneTF.text.length == 11 && self.vcTF.text.length != 0) {
            [_loginButton setBackgroundColor:MAIN_COLOR];
            _loginButton.enabled = YES;
        } else{
            [_loginButton setBackgroundColor:ORANGE];
            _loginButton.enabled = NO;
        }
    }else if (self.scrollView.contentOffsetX == kScreenWidth) {
        
        if (tf == self.username) {
            if (tf.text.length > 20) {
                tf.text = [tf.text substringToIndex:20];
            }
        }
        
        if (tf == self.password) {
            if (tf.text.length > 20) {
                tf.text = [tf.text substringToIndex:20];
            }
        }
        if (self.username.text.length >= 6 && self.username.text.length <= 20 && self.password.text.length >= 6 && self.password.text.length <= 20) {
            [_loginButton setBackgroundColor:MAIN_COLOR];
            _loginButton.enabled = YES;
        } else {
            [_loginButton setBackgroundColor:ORANGE];
            _loginButton.enabled = NO;
        }
    }
}


#pragma mark 获取验证码点击事件

- (void)codeBtnVerification {
    
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
            [self.sendVcBtn timeFailBeginFrom:60];
        }else{
            
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:2];
        }
        
        
    }];
    [InsNetwork addRequest:request];
}

- (void)switchLogin:(UIButton *)btn{
    [self.view endEditing:YES];
    if (btn.tag == 5) {
        self.usageGovButton.hidden = NO;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        if (self.username.text.length >= 6  && self.username.text.length <= 20 && self.password.text.length >= 6  && self.password.text.length <= 20) {
            [_loginButton setBackgroundColor:MAIN_COLOR];
            _loginButton.enabled = YES;
        } else {
            [_loginButton setBackgroundColor:ORANGE];
            _loginButton.enabled = NO;
        }
        
        self.title = @"账号密码登录";
        _titleLB.text = @"账号密码登录";
        
        self.scrollView.contentOffsetX = kScreenWidth;
        
        [_loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(45);
            make.width.mas_equalTo(kScreenWidth - 90);
            make.height.mas_equalTo(45);
//            make.top.equalTo(_scrollView.mas_bottom).with.offset(kScreenWidth < 375 ? 60 : 80);
            make.top.equalTo(_scrollView.mas_bottom).mas_offset(-135);
        }];
        
    } else if (btn.tag == 6) {
        
        self.title = @"手机注册";
        _titleLB.text = @"手机注册";
        
        self.usageGovButton.hidden = NO;
        [_loginButton setTitle:@"注册" forState:UIControlStateNormal];
        if (self.phoneTF.text.length == 11 && self.vcTF.text.length == 6) {
            [_loginButton setBackgroundColor:MAIN_COLOR];
            _loginButton.enabled = YES;
        } else {
            [_loginButton setBackgroundColor:ORANGE];
            _loginButton.enabled = NO;
        }
        self.scrollView.contentOffsetX = 0;
        
        [_loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(45);
            make.width.mas_equalTo(kScreenWidth - 90);
            make.height.mas_equalTo(45);
//            make.top.equalTo(_password.mas_bottom).with.offset(kScreenWidth < 375 ? 60 : 80+60);
            make.top.equalTo(_scrollView.mas_bottom);
        }];
    }
}

- (UITableView *)userListTableView {
    if (!_userListTableView) {
        _userListTableView = [[UITableView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.pwdLoginView.frame) + 50, kScreenWidth - 60, 220) style:UITableViewStylePlain];
        _userListTableView.dataSource = self;
        _userListTableView.delegate = self;
        _userListTableView.layer.cornerRadius = 5;
        _userListTableView.layer.masksToBounds = YES;
        _userListTableView.rowHeight = 55;
        _userListTableView.separatorColor = [UIColor colorWithHexString:@"e9e9ea"];
        _userListTableView.hidden = YES;
        [self.view addSubview:_userListTableView];
    }
    return _userListTableView;
}

- (NSMutableArray *)userList {
    if (!_userList) {
        _userList = [NSMutableArray array];
    }
    return _userList;
}

- (UILabel *)usageGovButton {
    if (!_usageGovButton) {
        _usageGovButton = [[UILabel alloc] initWithFrame:CGRectZero];
        _usageGovButton.font = [UIFont fontWithName:@"Heiti SC" size:13];
        NSString *text = @"注册或登录即同意《用户注册与隐私保护服务协议》";
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:text];
        [content addAttributes:@{NSForegroundColorAttributeName:MAIN_COLOR} range:NSMakeRange(8, text.length - 8)];
        [content addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"1f2124"]} range:NSMakeRange(0, 8)];
        _usageGovButton.attributedText = content;
        _usageGovButton.userInteractionEnabled = YES;
        WEAKSELF;
        [_usageGovButton jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weakSelf checkProtocol];
        }];
        _usageGovButton.hidden = NO;
        [self.view addSubview:_usageGovButton];
    }
    return _usageGovButton;
}

#pragma mark TODO
- (void)checkProtocol {

    NSString *url = [NSString stringWithFormat:@"%@protocol/",APP_HOST];
    AXWebViewController *webVC = [[AXWebViewController alloc]initWithAddress:url];
    webVC.title = @"《用户注册与隐私保护服务协议》";
     webVC.showsToolBar = YES;
    webVC.reviewsAppInAppStore = YES;
    webVC.navigationType = AXWebViewControllerNavigationToolItem;
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
