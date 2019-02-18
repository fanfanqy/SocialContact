//
//  FeedBackVC.m
//  SocialContact
//
//  Created by EDZ on 2019/2/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import "FeedBackVC.h"

static const CGFloat gap = 10;
static const CGFloat buttonHeight = 30;


@interface FeedBackVC ()

@property (nonatomic , strong) UIView           * buttonBackgroundView;
@property (nonatomic , strong) NSArray          * butArray;
@property (nonatomic , strong) UITextView       * textView;
@property (nonatomic , strong) UIButton         * submit;
@property (nonatomic , strong) NSMutableArray   * array;
@property (nonatomic , strong) UIView           * navigationBackView;

@end

@implementation FeedBackVC

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"反馈";
    [self.view setBackgroundColor:UIColorHex(F4F4F4)];
    
    [self creatView];
    
    [self setNavigationIteam];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGRect frame = self.textView.frame;
    frame.size.height = kScreenHeight - frame.origin.y - height - 20;
    self.textView.frame = frame;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    CGRect frame = self.textView.frame;
    frame.size.height = kScreenHeight - 50;
    self.textView.frame = frame;
}

- (void)setNavigationIteam{
    
    self.submit = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-40) / 2, self.textView.frame.origin.y + self.textView.frame.size.height + gap, buttonHeight * 2, buttonHeight)];
    self.submit.titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.submit];
    [self.submit setTitle:NSLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    [self.submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.submit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)creatView{
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(gap, 0, self.view.frame.size.width - 2 * gap, kScreenHeight - 50)];
    [self.view addSubview:self.textView];
    self.textView.layer.cornerRadius = gap;
    self.textView.font = [UIFont systemFontOfSize:17];
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    // toolbar上的2个按钮
    UIBarButtonItem *SpaceButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil  action:nil]; // 让完成按钮显示在右侧
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"complete", nil)
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(pickerDoneClicked)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:SpaceButton, doneButton, nil]];
    self.textView.inputAccessoryView = keyboardDoneButtonView;
    
}

- (void)submitAction:(UIButton *)button{

}

-(void)pickerDoneClicked{
    [self.textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
