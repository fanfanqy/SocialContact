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


@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate>

//@property ( nonatomic, strong ) UIImageView *avatarImageView;

@property ( nonatomic, strong ) UILabel *titleLB;

@property ( nonatomic, strong ) UITextField *username;
@property ( nonatomic, strong ) UITextField *password;
@property ( nonatomic, strong ) UIButton *loginButton;
@property ( nonatomic, strong ) UIButton *registe;
@property ( nonatomic, strong ) UIButton *forget;

/** url按钮 */
@property (strong, nonatomic) UIButton *usageGovButton;

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
@property ( nonatomic, strong ) UITextField *vcTF;
@property (strong, nonatomic) VerifyCodeButton *sendVcBtn;

@end

@implementation LoginViewController

+ (void)mineLogin:(NSDictionary *)params {
    [SVProgressHUD show];
    /*
    [DDUserCenter mineAppLogin:params complationBlock:^(BOOL succeed, NSDictionary *datas, NSError *error) {
        [SVProgressHUD dismiss];
        if (succeed) {
            // 用户登录处理
            [DDUserCenter sharedCenter].currentUser = [DDUser modelWithDictionary:datas];
            // 获取更详细的信息
            [DDUserCenter getUserInformation:nil];
            // Launch root viewController
            [[AppDelegate app] setRootViewController:[InsTabBarViewController new]];
            [LoginViewController loginSuccess];
            // 连接融云
            [[DCIM shared] startWithAppKey:[InsHybrid sharedInstance].option.rcKey launchOptions:nil];
        } else {
            [SVProgressHUD showImage:ErrorImage status:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:2];
        }
    }];
     */
    WEAKSELF;
    POSTRequest *request = [POSTRequest requestWithPath:@"customer/login/" parameters:params?:nil completionHandler:^(InsRequest *request) {
        if (!request.error) {
            
        }
    }];
    [InsNetwork addRequest:request];
}

+ (void)loginSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *toast = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        UIView *hub = [[UIView alloc] initWithFrame:toast.bounds];
        hub.backgroundColor = [UIColor blackColor];
        hub.alpha = 0.4;
        [toast addSubview:hub];
        
        UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0.5 * (kScreenWidth - 200), 0.5*(kScreenHeight - 130), 200, 130)];
        content.backgroundColor = [UIColor whiteColor];
        content.layer.cornerRadius = 5;
        content.layer.masksToBounds = YES;
        [toast addSubview:content];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(75, 22, 50, 50)];
        image.image = [UIImage imageNamed:@"success"];
        [content addSubview:image];
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, 200, 20)];
        text.textColor = Font_color2;
        text.text = @"登录成功";
        text.font = [UIFont systemFontOfSize:15];
        text.textAlignment = NSTextAlignmentCenter;
        [content addSubview:text];
        [[UIApplication sharedApplication].keyWindow addSubview:toast];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [toast removeFromSuperview];
        });
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self setup];
    [self checkHideUserAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    
    if (self.phoneTF.text.length == 11) {
        self.sendVcBtn.enabled = YES;
        self.sendVcBtn.backgroundColor = MAIN_COLOR;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
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
        
        NSDictionary *params = @{@"account":self.phoneTF.text?:@"",@"password":_vcPWTF.text?:@"",@"code":self.vcTF.text?:@""
                                 };
        WEAKSELF;
        POSTRequest *request = [POSTRequest requestWithPath:@"customer/enroll/" parameters:params?:nil completionHandler:^(InsRequest *request) {
           
            [SVProgressHUD dismiss];
            
            if (!request.error) {
                
                [SVProgressHUD showImage:AlertSuccessImage status:@"注册成功，请登录"];
                [SVProgressHUD dismissWithDelay:2];
                
//                weakSelf.username.text = weakSelf.phoneTF.text;
                
                UIButton *tempBtn = [UIButton new];
                tempBtn.tag = 5;
                [weakSelf switchLogin:tempBtn];
                
            }else {
                
                [SVProgressHUD showImage:AlertErrorImage status:request.responseObject[kRequestMessageKey]];
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
    POSTRequest *request = [POSTRequest requestWithPath:@"customer/login/" parameters:params?:nil completionHandler:^(InsRequest *request) {
        
        [SVProgressHUD dismiss];
        if (!request.error) {
            
            [[SCUserCenter sharedCenter] saveUser:weakSelf.username.text];
            [weakSelf loginSucced:request.responseObject];
            [LoginViewController loginSuccess];
            
        }else {
            [SVProgressHUD dismiss];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
//            //Using Block
//            [alert addButton:@"忘记密码" actionBlock:^(void) {
//                NSLog(@"Second button tapped");
//            }];
//            //Using Block
//            [alert addButton:@"重新输入" actionBlock:^(void) {
//                NSLog(@"Second button tapped");
//            }];
            
            [alert showError:weakSelf title:@"登录失败，请重试" subTitle:nil closeButtonTitle:nil duration:2];
        
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
        [[AppDelegate sharedDelegate]configRootVC];
        
        [SCUserCenter getOtherUserInformationWithUserId:[[SCUserCenter sharedCenter].currentUser.userInfo.account integerValue] completion:nil];
        
    }

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
    @weakify(self);
    [clear jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @normalize(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @weakify(self);
            NSString *title = [NSString stringWithFormat:@"确定删除账号：%@ 吗？",self.userList[indexPath.row]];
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:title cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                @normalize(self);
                if (buttonIndex == 1) {
//                    [[DDUserCenter sharedCenter] removeUser:self.userList[indexPath.row]];
                    [self.userList removeObjectAtIndex:indexPath.row];
                    [self.userListTableView reloadData];
                    [self checkHideUserAction];
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
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:18]
                                                                      }];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    _titleLB.text = @"手机注册";
    _titleLB.font = [UIFont systemFontOfSize:40 weight:UIFontWeightBold];
    _titleLB.textColor = [UIColor colorWithHexString:@"333333"];
    [self.view addSubview:_titleLB];
    
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).offset(45);
        make.top.equalTo(self.view).offset(GuaTopHeight);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(50);
    }];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(240);
        make.top.mas_equalTo(_titleLB.mas_bottom);
    }];

    //验证码登录view
    UIView *vcRegistView = [[UIView alloc] init];
    [scrollView addSubview:vcRegistView];
    
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.font = [UIFont systemFontOfSize:17];
    _phoneTF = phoneTF;
    
    NSString *holderText2 = @"手机号";
    NSMutableAttributedString *placeholder2 = [[NSMutableAttributedString alloc] initWithString:holderText2];
    [placeholder2 addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"747b8c"]
                         range:NSMakeRange(0, holderText2.length)];
    [placeholder2 addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:16]
                         range:NSMakeRange(0, holderText2.length)];
    phoneTF.attributedPlaceholder = placeholder2;
    phoneTF.textColor = [UIColor colorWithHexString:@"333333"];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.leftViewMode = UITextFieldViewModeAlways;
    phoneTF.rightViewMode = UITextFieldViewModeAlways;
    phoneTF.tintColor = MAIN_COLOR;
    [phoneTF addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [vcRegistView addSubview:phoneTF];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"747b8c"];
    [vcRegistView addSubview:lineView1];
    
    UITextField *vcPWTF = [[UITextField alloc] init];
    vcPWTF.font = [UIFont systemFontOfSize:17];
    _vcPWTF = vcPWTF;
    
    NSString *holderRegistPWText3 = @"密码";
    NSMutableAttributedString *placeholderRegistPW = [[NSMutableAttributedString alloc] initWithString:holderRegistPWText3];
    [placeholderRegistPW addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"747b8c"]
                         range:NSMakeRange(0, holderRegistPWText3.length)];
    [placeholderRegistPW addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:16]
                         range:NSMakeRange(0, holderRegistPWText3.length)];
    vcPWTF.attributedPlaceholder = placeholderRegistPW;
    vcPWTF.textColor = [UIColor colorWithHexString:@"333333"];
    vcPWTF.keyboardType = UIKeyboardTypeASCIICapable;
    vcPWTF.leftViewMode = UITextFieldViewModeAlways;
    vcPWTF.rightViewMode = UITextFieldViewModeAlways;
    vcPWTF.tintColor = MAIN_COLOR;
    [vcPWTF addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [vcRegistView addSubview:vcPWTF];
    
    UIView *lineRegistPWView = [[UIView alloc] init];
    lineRegistPWView.backgroundColor = [UIColor colorWithHexString:@"747b8c"];
    [vcRegistView addSubview:lineRegistPWView];
    
    
    UITextField *vcTF = [[UITextField alloc] init];
    vcTF.font = [UIFont systemFontOfSize:17];
    _vcTF = vcTF;
    NSString *holderText3 = @"请输入验证码";
    NSMutableAttributedString *placeholder3 = [[NSMutableAttributedString alloc] initWithString:holderText3];
    [placeholder3 addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"747b8c"]
                         range:NSMakeRange(0, holderText3.length)];
    [placeholder3 addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:16]
                         range:NSMakeRange(0, holderText3.length)];
    vcTF.attributedPlaceholder = placeholder3;
    vcTF.textColor = [UIColor colorWithHexString:@"333333"];
    vcTF.keyboardType = UIKeyboardTypeNumberPad;
    vcTF.tintColor = MAIN_COLOR;
    [vcTF addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [vcRegistView addSubview:vcTF];
    
    VerifyCodeButton *sendVcBtn = [[VerifyCodeButton alloc] init];
    sendVcBtn.enabled = NO;
    sendVcBtn.isGray = YES;
    sendVcBtn.label.textColor = [UIColor colorWithRed:58/255.0 green:64/255.0 blue:78/255.0 alpha:1.0];
    sendVcBtn.backgroundColor = [UIColor colorWithRed:116/255.0 green:123/255.0 blue:140/255.0 alpha:1.0];
    sendVcBtn.layer.cornerRadius = 7.5;
    sendVcBtn.layer.masksToBounds = YES;
    sendVcBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendVcBtn addTarget:self action:@selector(codeBtnVerification) forControlEvents:UIControlEventTouchUpInside];
    [vcRegistView addSubview:sendVcBtn];
    _sendVcBtn = sendVcBtn;
    
    UIView *lineView_register = [[UIView alloc] init];
    lineView_register.backgroundColor = [UIColor colorWithHexString:@"747b8c"];
    [vcRegistView addSubview:lineView_register];
    
    UIButton *pwdLoginBtn = [[UIButton alloc] init];
    [pwdLoginBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
    [pwdLoginBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    pwdLoginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    pwdLoginBtn.tag = 5;
    [pwdLoginBtn addTarget:self action:@selector(switchLogin:) forControlEvents:UIControlEventTouchUpInside];
    [vcRegistView addSubview:pwdLoginBtn];
    
    UIView *line_pwdLoginBtn = [[UIView alloc] init];
    line_pwdLoginBtn.backgroundColor = [UIColor whiteColor];
    [vcRegistView addSubview:line_pwdLoginBtn];
    
    //密码登录view
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
    _username.font = [UIFont systemFontOfSize:17];
    NSString *holderText = @"请输入账号/手机号";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithHexString:@"747b8c"]
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:16]
                        range:NSMakeRange(0, holderText.length)];
    _username.attributedPlaceholder = placeholder;
    _username.textColor = [UIColor colorWithHexString:@"333333"];
    _username.keyboardType = UIKeyboardTypeNamePhonePad;
    _username.leftViewMode = UITextFieldViewModeAlways;
    _username.rightView = button;
    _username.rightViewMode = UITextFieldViewModeAlways;
    _username.tintColor = MAIN_COLOR;
    [_username addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [pwdLoginView addSubview:_username];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"747b8c"];
    [pwdLoginView addSubview:lineView];
    
    UILabel *leftView_pass = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 45)];
    leftView_pass.text = @"密码";
    leftView_pass.font = [UIFont systemFontOfSize:17];
    leftView_pass.textAlignment = NSTextAlignmentLeft;
    leftView_pass.textColor = [UIColor colorWithHexString:@"ffffff"];
    
    _password = [[UITextField alloc] init];
    _password.font = [UIFont systemFontOfSize:17];
    _password.secureTextEntry = YES;
    
    UIButton *eyes = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    eyes.imageEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [eyes setImage:[UIImage imageNamed:@"biyan_icon_home"] forState:UIControlStateNormal];
    [eyes setImage:[UIImage imageNamed:@"yanjing_icon_home"] forState:UIControlStateSelected];
    [eyes addTarget:self action:@selector(checkEye:) forControlEvents:UIControlEventTouchUpInside];
    NSString *holderText1 = @"请输入密码";
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:holderText1];
    [placeholder1 addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"747b8c"]
                         range:NSMakeRange(0, holderText1.length)];
    [placeholder1 addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:16]
                         range:NSMakeRange(0, holderText1.length)];
    _password.attributedPlaceholder = placeholder1;
    _password.textColor = [UIColor colorWithHexString:@"333333"];
//    _password.leftView = leftView_pass;
    _password.leftViewMode = UITextFieldViewModeAlways;
    _password.tintColor = MAIN_COLOR;
    _password.rightView = eyes;
    _password.rightViewMode = UITextFieldViewModeAlways;
    [_password addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [pwdLoginView addSubview:_password];
    
    UIView *lineView_password = [[UIView alloc] init];
    lineView_password.backgroundColor = [UIColor colorWithHexString:@"747b8c"];
    [pwdLoginView addSubview:lineView_password];
    
    UIButton *vcLoginBtn = [[UIButton alloc] init];
    [vcLoginBtn setTitle:@"手机号注册" forState:UIControlStateNormal];
    [vcLoginBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    vcLoginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    vcLoginBtn.tag = 6;
    [vcLoginBtn addTarget:self action:@selector(switchLogin:) forControlEvents:UIControlEventTouchUpInside];
    [pwdLoginView addSubview:vcLoginBtn];
    
    UIView *line_vcLoginBtn = [[UIView alloc] init];
    line_vcLoginBtn.backgroundColor = [UIColor whiteColor];
    [pwdLoginView addSubview:line_vcLoginBtn];
    
    _forget = [[UIButton alloc] init];
    [_forget setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forget setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    _forget.titleLabel.font = [UIFont systemFontOfSize:14];
    [_forget addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
    [pwdLoginView addSubview:_forget];
    
    UIView *line_forget = [[UIView alloc] init];
    line_forget.backgroundColor = [UIColor whiteColor];
    [pwdLoginView addSubview:line_forget];
    
    _loginButton = [[UIButton alloc] init];
    _loginButton.enabled = NO;
    [_loginButton setTitle:@"注册" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor colorWithRed:58/255.0 green:64/255.0 blue:78/255.0 alpha:1.0] forState:UIControlStateDisabled];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_loginButton setBackgroundColor:[UIColor colorWithRed:116/255.0 green:123/255.0 blue:140/255.0 alpha:1.0]];
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
    
    [_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.width.mas_equalTo(kScreenWidth - 90);
        make.height.mas_equalTo(45);
        make.top.equalTo(_username.mas_bottom).with.offset(25);
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
    
   
    [vcTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneTF);
        make.right.equalTo(sendVcBtn.mas_left).offset(-10);
        make.height.equalTo(phoneTF);
        make.centerY.equalTo(sendVcBtn);
    }];
    
    [lineView_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_username);
        make.height.mas_equalTo(.7);
        make.top.equalTo(_password.mas_bottom);
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
        make.top.equalTo(lineView_register.mas_bottom).offset(10);
    }];
    
    [line_pwdLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(pwdLoginBtn);
        make.top.equalTo(pwdLoginBtn.mas_bottom).offset(-6);
        make.height.mas_equalTo(.7);
    }];
    
    [vcLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_password);
        make.top.equalTo(_password.mas_bottom).offset(10);
    }];
    
    [line_vcLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(vcLoginBtn);
        make.top.equalTo(vcLoginBtn.mas_bottom).offset(-6);
        make.height.mas_equalTo(.7);
    }];
    
    [_forget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView_password);
        make.top.equalTo(_password.mas_bottom).offset(10);
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
        make.top.equalTo(_password.mas_bottom).with.offset(kScreenWidth < 375 ? 60 : 80+100);
        
    }];
    
    [self.usageGovButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(45);
        make.height.mas_offset(45);
        make.width.mas_offset(280);
        make.top.equalTo(_loginButton.mas_bottom).mas_offset(15);
    }];
    
//    [thirdLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(120);
//        make.left.right.bottom.equalTo(self.view);
//    }];
//
//
//    [thirdLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(thirdLoginView);
//        make.centerX.equalTo(thirdLoginView);
//    }];
//
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0.5);
//        make.left.equalTo(thirdLoginView).offset(34);
//        make.right.equalTo(thirdLab.mas_left).offset(-16.5);
//        make.centerY.equalTo(thirdLab);
//    }];
//
//    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(line1.mas_height);
//        make.left.equalTo(thirdLab.mas_right).offset(16.5);
//        make.right.equalTo(thirdLoginView).offset(-34);
//        make.centerY.equalTo(thirdLab);
//    }];
    
////    NSString *deviceType = [UIDevice currentDevice].model;
//    if (![InsHybrid sharedInstance].option.appUpperFlag) {
//        thirdLoginView.hidden = YES;
//        return;
//    }
//
//    CGFloat padding = RatioWithWidth(40);
//    NSInteger count = 4;
//    UIView * tempView = nil;
//    CGFloat height = 80; // 高度固定等于50
//
//    NSArray *titleArr = @[@"智能小益",@"微信",@"QQ",@"微博"];
//    NSArray *imageArr = @[@"login_echeng",@"login_weixin",@"login_qq",@"login_weibo"];
//
//    for (NSInteger i = 0; i<count; i++) {
//
//        LoginButton *subView = [[LoginButton alloc] init];
//        subView.tag = i + 1;
//        subView.titleLabel.font = [UIFont systemFontOfSize:11.5];
//        [subView setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
//        [subView setTitle:titleArr[i] forState:UIControlStateNormal];
//        [subView addTarget:self action:@selector(thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
//        [thirdLoginView addSubview:subView];
//
//        if (i == 0) {
//            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(thirdLoginView).offset(padding);
//                make.height.equalTo(@(height));
//                make.centerY.equalTo(thirdLoginView).offset(10);
//            }];
//
//        } else if (i == count -1) {
//            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(tempView.mas_right).offset(padding - 2);
//                make.right.equalTo(thirdLoginView.mas_right).offset(-padding);
//                make.height.equalTo(tempView);
//                make.width.equalTo(tempView);
//                make.centerY.equalTo(tempView);
//            }];
//
//        } else {
//            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(tempView.mas_right).offset(padding - 2);
//                make.centerY.equalTo(tempView);
//                make.height.equalTo(tempView);
//                make.width.equalTo(tempView);
//            }];
//        }
//
//        tempView = subView;
//    }
}

- (void)textFieldDidChanged:(UITextField *)tf {
    if (self.scrollView.contentOffsetX == 0) {
        
        if (tf == self.phoneTF) {
            if (tf.text.length > 11) {
                tf.text = [tf.text substringToIndex:11];
            }else if (tf.text.length < 11){
                self.sendVcBtn.enabled = NO;
                self.sendVcBtn.label.textColor = [UIColor colorWithRed:58/255.0 green:64/255.0 blue:78/255.0 alpha:1.0];
                self.sendVcBtn.backgroundColor = [UIColor colorWithRed:116/255.0 green:123/255.0 blue:140/255.0 alpha:1.0];
            }else{
                if ([self.sendVcBtn.label.text isEqualToString:@"发送验证码"]) {
                    self.sendVcBtn.enabled = YES;
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
            [_loginButton setBackgroundColor:[UIColor colorWithRed:116/255.0 green:123/255.0 blue:140/255.0 alpha:1.0]];
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
            [_loginButton setBackgroundColor:[UIColor colorWithRed:116/255.0 green:123/255.0 blue:140/255.0 alpha:1.0]];
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
            
            [SVProgressHUD showImage:AlertErrorImage status:request.responseObject[kRequestMessageKey]];
            [SVProgressHUD dismissWithDelay:2];
        }
        
        
    }];
    [InsNetwork addRequest:request];
}

- (void)thirdLoginAction:(UIButton *)btn {
//    if (btn.tag == 1) {         // 智能小益
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"SmartCity:"]]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"SmartCity://YongChengLife?type=get"]];
//        } else {
//            CommonWebViewController *vc = [[CommonWebViewController alloc] init];
//            NSString *host = [InsHybrid userHost];
//            if ([[host substringWithRange:NSMakeRange(host.length - 1, 1)] isEqualToString:@"/"]) {
//                vc.url = [NSString stringWithFormat:@"%@html/download/ecsh/index.html", [InsHybrid userHost]];
//            } else {
//                vc.url = [NSString stringWithFormat:@"%@/html/download/ecsh/index.html", [InsHybrid userHost]];
//            }
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    } else if (btn.tag == 2) {  // 微信登录
//        [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
//    } else if (btn.tag == 3) {  // QQ登录
//        [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
//    } else if (btn.tag == 4) {  // 微博登录
//        [self getUserInfoForPlatform:UMSocialPlatformType_Sina];
//    }
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
            [_loginButton setBackgroundColor:[UIColor colorWithRed:116/255.0 green:123/255.0 blue:140/255.0 alpha:1.0]];
            _loginButton.enabled = NO;
        }
        
        self.title = @"密码登录";
        
        self.scrollView.contentOffsetX = kScreenWidth;
        
        [_loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(45);
            make.width.mas_equalTo(kScreenWidth - 90);
            make.height.mas_equalTo(45);
            make.top.equalTo(_password.mas_bottom).with.offset(kScreenWidth < 375 ? 60 : 80);
        }];
        
    } else if (btn.tag == 6) {
        
        self.title = @"手机注册";
        
        self.usageGovButton.hidden = YES;
        [_loginButton setTitle:@"注册" forState:UIControlStateNormal];
        if (self.phoneTF.text.length == 11 && self.vcTF.text.length == 6) {
            [_loginButton setBackgroundColor:MAIN_COLOR];
            _loginButton.enabled = YES;
        } else {
            [_loginButton setBackgroundColor:[UIColor colorWithRed:116/255.0 green:123/255.0 blue:140/255.0 alpha:1.0]];
            _loginButton.enabled = NO;
        }
        self.scrollView.contentOffsetX = 0;
        
        [_loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(45);
            make.width.mas_equalTo(kScreenWidth - 90);
            make.height.mas_equalTo(45);
            make.top.equalTo(_password.mas_bottom).with.offset(kScreenWidth < 375 ? 60 : 80+60);
            
        }];
    }
}

//- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
//{
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
//        if (error) {
//            NSLog(@"error:%@",error);
//            [SVProgressHUD showImage:ErrorImage status:[YDShareView UMSocialPlatformErrorMessage:error.code]];
//            [SVProgressHUD dismissWithDelay:2];
//        } else {
//            UMSocialUserInfoResponse *resp = result;
//            [self thirdLogin:platformType response:resp];
//        }
//    }];
//}
//
//- (void)thirdLogin:(UMSocialPlatformType)platformType response:(UMSocialUserInfoResponse *)response {
//    // 第三方登录数据(为空表示平台未提供)
//    // 登录 --- 登录成功直接登录，登录不成功去绑定手机号
//    NSInteger index = 0;
//    if (platformType == UMSocialPlatformType_QQ) {
//        index = 1;
//    } else if (platformType == UMSocialPlatformType_WechatSession) {
//        index = 2;
//    } else if (platformType == UMSocialPlatformType_Sina) {
//        index = 3;
//    }
//    if (response.uid == nil || response.uid.length == 0) {
//        [SVProgressHUD showInfoWithStatus:@"第三方授权失败"];
//        return ;
//    }
//    [SVProgressHUD show];
//    /*
//    [DDUserCenter thirdLogin:response.uid type:index complationBlock:^(BOOL succeed, NSDictionary *datas, NSError *error) {
//        [SVProgressHUD dismiss];
//        if (succeed) {
//            // 去登录
//            [self loginSucced:datas];
//            [LoginViewController loginSuccess];
//        } else {
//            // 去注册
//            BindingPhoneViewController *vc = [[BindingPhoneViewController alloc] init];
//            vc.thirdInfo = @{@"accountId" : response.uid,
//                             @"accountName" : [response.name removedEmojiString],
//                             @"accountPhoto" : response.iconurl,
//                             @"type" : @(index)
//                             };
//            @weakify(self);
//            [vc setCallBack:^(NSString *text) {
//                @normalize(self);
//                _username.text = text;
//                _phoneTF.text = text;
//                [_loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
//                if (self.phoneTF.text.length != 0 && self.vcTF.text.length != 0) {
//                    [_loginButton setBackgroundColor:MAIN_COLOR];
//                    _loginButton.enabled = YES;
//                } else {
//                    [_loginButton setBackgroundColor:[UIColor colorWithRed:116/255.0 green:123/255.0 blue:140/255.0 alpha:1.0]];
//                    _loginButton.enabled = NO;
//                }
//                self.scrollView.contentOffsetX = 0;
//            }];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }];
//     */
//}


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
//        [_userList addObjectsFromArray:[[DDUserCenter sharedCenter] getUsers]];
    }
    return _userList;
}

- (UIButton *)usageGovButton {
    if (!_usageGovButton) {
        _usageGovButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _usageGovButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_usageGovButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_usageGovButton setImage:[UIImage imageNamed:@"login_tongyi0"] forState:UIControlStateNormal];
        _usageGovButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        NSString *text = [NSString stringWithFormat:@"注册登录即表示同意《%@用户协议》", INS_APP_NAME];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:text];
        [content addAttributes:@{NSForegroundColorAttributeName:MAIN_COLOR} range:NSMakeRange(7, text.length - 7)];
        [content addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]} range:NSMakeRange(0, 7)];
        [_usageGovButton setAttributedTitle:content forState:UIControlStateNormal];
        [_usageGovButton addTarget:self action:@selector(checkProtocol) forControlEvents:UIControlEventTouchUpInside];
        _usageGovButton.hidden = YES;
        [self.view addSubview:_usageGovButton];
    }
    return _usageGovButton;
}

    
- (void)checkProtocol {
//    NSString *host = [InsHybrid userHost];
//    NSURL *url;
//    if ([[host substringWithRange:NSMakeRange(host.length - 1, 1)] isEqualToString:@"/"]) {
//        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@html/wisdomPeople/usage.html", [InsHybrid userHost]]];
//    } else {
//        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/html/wisdomPeople/usage.html", [InsHybrid userHost]]];
//    }
//    BrowserViewController *brow = [[BrowserViewController alloc] initWithURL:url];
//    [self.navigationController pushViewController:brow animated:YES];
}

@end
