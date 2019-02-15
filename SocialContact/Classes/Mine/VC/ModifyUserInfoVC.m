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
    //    self.fd_interactivePopDisabled = YES;

    [self.view addSubview:self.publishButton];
    
    [_textView becomeFirstResponder];
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
    //    self.fd_interactivePopDisabled = NO;
}



- (void)_initNavBar {
    if (_modifyType == ModifyTypeNickName) {
        self.title = @"设置昵称";
        _maxWords = kNickNameMaxWords;
    }
    if (_modifyType == ModifyTypeSelfIntroduce) {
        self.title = @"设置个性签名";
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
        _publishButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_publishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_publishButton setTitleColor:UIColorHex(FFFFFF) forState:UIControlStateNormal];
        [_publishButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [_publishButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(63D190)] forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(_publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishButton;
}

- (void)initTextView {
    if (_textView) return;
    _textView = [YYTextView new];
    _textView.top = GuaTopHeight;
    _textView.size = CGSizeMake(self.view.width, 160);
    _textView.textContainerInset = UIEdgeInsetsMake(16, 16, 16, 16);
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = UIColorHex(C8C8C8).CGColor;
    
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
    
//    TextLinePositionModifier *modifier = [TextLinePositionModifier new];
//    modifier.font = [UIFont fontWithName:@"Heiti SC" size:16];
//    modifier.paddingTop = 12;
//    modifier.paddingBottom = 12;
//    modifier.lineHeightMultiple = 1.5;
    
//    _textView.linePositionModifier = modifier;
    
    NSString *placeholderPlainText ;
    
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.color = UIColorHex(c4c4c4);
        atr.font = [UIFont systemFontOfSize:16];
        _textView.placeholderAttributedText = atr;
    }
    [self.view addSubview:_textView];
    
}

- (void)_publishBtnClick{
    [self.view endEditing:YES];
    if ([NSString ins_String:_textView.text]) {
        WEAKSELF
        if (_modifyType == ModifyTypeNickName) {
            
//            [AlertControllerManager alertWithTitle:nil message:@"没有输入昵称，请重新输入" textFieldNumber:0 actionNumber:1 actionTitles:@[@"我知道了"] textFieldHandler:nil actionHandler:^(UIAlertAction *action, NSUInteger index) {
//                weakSelf.textView.text = nil;
//                [weakSelf.textView becomeFirstResponder];
//            } vc:self];
        }
        if (_modifyType == ModifyTypeSelfIntroduce) {
//            [AlertControllerManager alertWithTitle:nil message:@"没有输入个性签名，请重新输入" textFieldNumber:0 actionNumber:1 actionTitles:@[@"我知道了"] textFieldHandler:nil actionHandler:^(UIAlertAction *action, NSUInteger index) {
//                weakSelf.textView.text = nil;
//                [weakSelf.textView becomeFirstResponder];
//            } vc:self];
        }
        
    }else{
        
        [self modifyUserinfo];
        
    }
}

- (void)modifyUserinfo{
    WEAKSELF
    
    if (_modifyType == ModifyTypeNickName) {
//        self.model.nickname = self.textView.text;
    }
    if (_modifyType == ModifyTypeSelfIntroduce) {
//        self.model.selfIntroduction = self.textView.text;
    }
    
//    [ChannelRequest modifyStudentInfoWithUserInfoModel:self.model Success:^(NetResponseModel *model) {
//
//        if (model) {
//            [weakSelf.navigationController.view makeToast:model.msg];
//            if (model.code == kRequest_OK) {
//
//                [[UserManager sharedInstance]setUserInfoModel:weakSelf.model];
//
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }
//        }else{
//            [weakSelf.tableView makeToast:kServerBusyAlert];
//        }
//
//    } failure:^(NSError *error) {
//        [weakSelf.navigationController.view makeToast:error.localizedDescription];
//    }];
    
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
    if ([text isEqualToString:@"\n"]){
        [self.textView resignFirstResponder];//在这里做你响应return键的代码//判断输入的字是否是回车，即按下return
        [self _publishBtnClick];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
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
