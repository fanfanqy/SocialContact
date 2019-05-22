//
//  ModifyUserInfoVC.m
//  SocialContact
//
//  Created by EDZ on 2019/1/19.
//  Copyright © 2019 ha. All rights reserved.
//

#import "ModifyUserInfoVC.h"

@interface ModifyUserInfoVC ()<YYTextViewDelegate, YYTextKeyboardObserver>

@property (strong, nonatomic) UIButton *publishButton;

@property (nonatomic, strong) YYTextView *textView;

@property (assign, nonatomic) NSInteger maxWords;

@end

@implementation ModifyUserInfoVC

- (instancetype)init {
    self = [super init];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    return self;
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initNavBar];
    [self initTextView];
    
    self.fd_interactivePopDisabled = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.publishButton];
    
    [_textView becomeFirstResponder];
    if (self.model) {
        
        if (_modifyType == ModifyTypeNickName) {
           _textView.text = self.model.name;
        }else if (_modifyType == ModifyTypeSelfIntroduce) {
            _textView.text = self.model.intro;
            
        }else if (_modifyType == ModifyTypeWeChat) {
            _textView.text = self.model.wechat_id;
            
        }
    }else{
        self.model = [SCUserInfo new];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}

- (void)_initNavBar {
    if (_modifyType == ModifyTypeNickName) {
        self.title = @"设置昵称";
        _maxWords = kNickNameMaxWords;
    }else if (_modifyType == ModifyTypeSelfIntroduce) {
        self.title = @"设置自我介绍";
        _maxWords = kSelfIntroduceMaxWords;

    }else if (_modifyType == ModifyTypeWeChat) {
        self.title = @"设置微信号";
        _maxWords = kSelfIntroduceMaxWords;
        
    }
}

- (UIButton *)publishButton{
    if (!_publishButton) {
        
        _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishButton.frame = CGRectMake(0, 0, 54, 24);
        _publishButton.top = StatusBarHeight+10;
        _publishButton.left = kScreenWidth-54-20;
        _publishButton.layer.cornerRadius = 4.0;
        _publishButton.layer.masksToBounds = YES;
        _publishButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_publishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_publishButton setTitleColor:UIColorHex(FFFFFF) forState:UIControlStateNormal];
        [_publishButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [_publishButton setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(_publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishButton;
}

- (void)initTextView {
    if (_textView) return;
    _textView = [YYTextView new];
    _textView.top = 0;
    _textView.size = CGSizeMake(self.view.width, 160);
    _textView.textContainerInset = UIEdgeInsetsMake(16, 16, 16, 16);
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = Line.CGColor;
    
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
    
    NSString *placeholderPlainText = self.title;
    
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.color = UIColorHex(c4c4c4);
        atr.font = [UIFont systemFontOfSize:15];
        _textView.placeholderAttributedText = atr;
    }
    [self.view addSubview:_textView];
    
}

- (void)_publishBtnClick{
    [self.view endEditing:YES];
    if (![NSString ins_String:_textView.text]) {
        [self.view makeToast:@"请输入有效内容"];
        return;
    }else{
        if (_modifyType == ModifyTypeNickName) {
            
            if(_textView.text.length > _maxWords){
                [self.view makeToast:@"昵称过长，赞不支持"];
                return;
            }
            self.model.name = _textView.text;
        }else if (_modifyType == ModifyTypeSelfIntroduce) {
            
            if(_textView.text.length > _maxWords){
                [self.view makeToast:@"自我介绍过长，暂不支持"];
                return;
            }
            self.model.intro = _textView.text;
        }else if (_modifyType == ModifyTypeWeChat) {
            self.model.wechat_id = _textView.text;
        }
        
    }
    
    [self modifyUserinfo];
}

- (void)modifyUserinfo{
    
    NSDictionary *dic;
    
    if (_modifyType == ModifyTypeNickName) {
        self.model.name = self.textView.text;
        dic = @{
                @"name":self.model.name?:@"",
                };
    }else if (_modifyType == ModifyTypeSelfIntroduce) {
        self.model.intro = self.textView.text;
        dic = @{
                @"intro":self.model.intro?:@"",
                };
        
    }else if (_modifyType == ModifyTypeWeChat) {
        self.model.wechat_id = self.textView.text;
        dic = @{
                @"wechat_id":self.model.wechat_id?:@"",
                };
    }
    
    
    WEAKSELF;
    POSTRequest *request = [POSTRequest requestWithPath:@"/customer/profile/" parameters:dic ?: nil completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            weakSelf.model = [SCUserInfo modelWithDictionary:request.responseObject[@"data"]];
            
            // 1.
            [SCUserCenter sharedCenter].currentUser.userInfo = weakSelf.model;
            [[SCUserCenter sharedCenter].currentUser updateToDB];
            
            // 2.[SCUserCenter sharedCenter].currentUser.user_id
            RCUserInfo *rcUserInfo = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",weakSelf.model.iD] name:[SCUserCenter sharedCenter].currentUser.name portrait:weakSelf.model.avatar_url] ;
            [rcUserInfo updateToDB];
            [RCIM sharedRCIM].currentUserInfo = rcUserInfo;
            [[RCIM sharedRCIM] refreshUserInfoCache:rcUserInfo withUserId:rcUserInfo.userId];
            
            [weakSelf.view makeToast:@"设置完成"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    [InsNetwork addRequest:request];
    
}

#pragma mark @protocol YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    debugMethod();
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (textView.text.length >= _maxWords) {
        if ([text isEqualToString:@""]) {// 删除符号是@""
            return YES;
        }
        return NO;
    }
//    if ([text isEqualToString:@"\n"]){
//        [self.textView resignFirstResponder];//在这里做你响应return键的代码//判断输入的字是否是回车，即按下return
//        [self _publishBtnClick];
//        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
//    }
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
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
