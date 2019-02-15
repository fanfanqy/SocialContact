//
//  Ins_ViewController.m
//  AVInsurance
//
//  Created by Dylan on 2016/7/28.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "Ins_ViewController.h"


@interface InsViewController () {
//  IHUD *_loadingHud;
}

/** netweakView */
@property (strong, nonatomic) UIView *netweakView;
/** 设置网络 */
@property (strong, nonatomic) UIButton *netSetAction;

/** 重新加载 */
@property (strong, nonatomic) UIButton *reloadAction;

/** 无网络图片 */
@property (strong, nonatomic) UIImageView *netweakImage;

/** 显示的内容 */
@property (strong, nonatomic) UILabel *netweakLabel;


/** 加载View */
@property (strong, nonatomic) UIView *loadingView;

/** 加载中的图片 */
@property (strong, nonatomic) UIImageView *loadingImage;

/** 加载中的文字 */
@property (strong, nonatomic) UILabel *loadingText;

/** 重新加载 */
@property (copy, nonatomic) void(^reload)(void);

@end

@implementation InsViewController

- (instancetype)initWithHybridParams: (NSDictionary *)params {
	self = [super init];
	if ( self ) {
		
	}
	return self;
}


- (void)dealloc {
    NSLog(@"%@：dealloc——————————————————————————————————————", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@：init——————————————————————————————————————————", self);
  // 初始化类名称为唯一标识
  self->_ins_vc_identifier = NSStringFromClass(self.class);
    
    self->_fixedFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - GuaTopHeight);
    
    
  self->_fixedScrollFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - GuaTopHeight);
    

    
    
  self->_fixedScrollInsets = UIEdgeInsetsZero;

  // TabBar存在
  if ( self.tabBarController ) {
    // H-=49
    self->_fixedFrame = CGRectMake(
                                   CGRectGetMinX(self->_fixedFrame),
                                   CGRectGetMinY(self->_fixedFrame),
                                   CGRectGetWidth(self->_fixedFrame),
                                   CGRectGetHeight(self->_fixedFrame) - UITabBarHeight);
    // 下距 49
    self->_fixedScrollInsets = UIEdgeInsetsMake(
                                                self->_fixedScrollInsets.top,
                                                self->_fixedScrollInsets.left,
                                                self->_fixedScrollInsets.bottom + UITabBarHeight,
                                                self->_fixedScrollInsets.right);
  }

  // 手动布局滑动视图
  if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
  
  self.view.backgroundColor = [UIColor whiteColor];

  UINavigationBar *bar = self.navigationController.navigationBar;
  [bar setShadowImage:[UIImage new]];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemClick)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
}

- (void)leftBarButtonItemClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
    
    

- (void) enableViewLoading {
//  if ( !_loadingHud ) {
    dispatch_async(dispatch_get_main_queue(), ^{
//      _loadingHud = [IHUD hud];
//      _loadingHud.frame = [IHUD hudFrame:_loadingHud];
//      _loadingHud.center = self.navigationController.view.center;
//      [self.navigationController.view addSubnode:_loadingHud];
    });
//  }
}

- (void) disableViewLoading {
  // 停止小菊花的转动
  dispatch_async(dispatch_get_main_queue(), ^{
//    [_loadingHud removeFromSupernode];
  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - 网络加载失败
- (void)showNetworkWeakView:(NSString *)title isNetWeak:(BOOL)isNetWeak {
//    if (!isNetWeak) {
        self.netSetAction.hidden = YES;
        self.netweakLabel.text = title ?: @"请求出了点问题哦, 请稍后重试";
        self.reloadAction.frame = CGRectMake(0, 190,  (kScreenWidth - 60), 45);
//    } else {
//        self.netSetAction.hidden = NO;
//        self.netweakLabel.text = @"网络异常，请检查您的网络状态";
//        self.reloadAction.frame = CGRectMake(CGRectGetMaxX(self.netSetAction.frame) + 15, 190,  (kScreenWidth - 70) * 0.5, 45);
//    }
    [self.view addSubview:self.netweakView];
}

- (void)hideNetworkWeakView {
    [self.netweakView removeFromSuperview];
}

- (void)showError:(NSError *)error reload:(void (^)())reload {
    if (error.code == -1001 || error.code == -1009) {
        // 请求超时
        [self showNetworkWeakView:nil isNetWeak:YES];
    } else {
        [self showNetworkWeakView:error.localizedDescription isNetWeak:NO];
    }
    self.reload = reload;
}

- (void)clickAction:(UIButton *)action {
    if (action == self.netSetAction) {
        // 去设置网络
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    } else if (action == self.reloadAction) {
        // 重新加载
        [self load];
        [self hideNetworkWeakView];
    }
}

- (void)load {
    // 重新加载
    if (self.reload) {
        self.reload();
        return;
    }
    [self fetchData];
}

- (void)fetchData{
    
}

#pragma mark - 加载中
- (void)showLoading {
//    [self.view addSubview:self.loadingView];
    [self.view makeToastActivity:CSToastPositionCenter];
}

- (void)hideLoading {
//    if (_loadingView == nil) {
//        return;
//    }
//    [self.loadingView removeFromSuperview];
//    [self.loadingImage removeFromSuperview];
//    [self.loadingText removeFromSuperview];
//    _loadingText = nil;
//    _loadingImage = nil;
//    _loadingView = nil;
    [self.view hideToastActivity];
}



#pragma mark - 加载错误中的文件
- (UIView *)netweakView {
    if (_netweakView == nil) {
        _netweakView = [[UIView alloc] initWithFrame:CGRectMake(30, (kScreenHeight - 250) * 0.5 - 64, kScreenWidth - 30, 250)];
        _netweakView.backgroundColor = [UIColor clearColor];
        [_netweakView addSubview:self.netweakImage];
        [_netweakView addSubview:self.netweakLabel];
        [_netweakView addSubview:self.netSetAction];
        [_netweakView addSubview:self.reloadAction];
    }
    
    return _netweakView;
}

- (UIButton *)netSetAction {
    if (_netSetAction == nil) {
        _netSetAction = [[UIButton alloc] initWithFrame:CGRectMake(0, 190, (kScreenWidth - 70) * 0.5, 45)];
        _netSetAction.backgroundColor = MAIN_COLOR;
        [_netSetAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _netSetAction.titleLabel.font = [UIFont systemFontOfSize:17];
        _netSetAction.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_netSetAction setTitle:@"设置网络" forState:UIControlStateNormal];
        [_netSetAction addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _netSetAction.layer.cornerRadius = 5.0;
        _netSetAction.layer.masksToBounds = YES;
    }
    return _netSetAction;
}

- (UIButton *)reloadAction {
    if (_reloadAction == nil) {
        _reloadAction = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.netSetAction.frame) + 15, 190,  (kScreenWidth - 70) * 0.5, 45)];
        _reloadAction.backgroundColor = MAIN_COLOR;
        [_reloadAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reloadAction.titleLabel.font = [UIFont systemFontOfSize:17];
        _reloadAction.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_reloadAction setTitle:@"重新加载" forState:UIControlStateNormal];
        _reloadAction.layer.cornerRadius = 5.0;
        _reloadAction.layer.masksToBounds = YES;
        [_reloadAction addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadAction;
    
}

- (UIImageView *)netweakImage {
    if (!_netweakImage) {
        _netweakImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-100) * 0.5 - 25, 0, 100, 105)];
        _netweakImage.contentMode = UIViewContentModeScaleAspectFit;
        _netweakImage.image = [UIImage imageNamed:@"imag_yichang"];
    }
    return _netweakImage;
}

- (UILabel *)netweakLabel {
    if (!_netweakLabel) {
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 120,  kScreenWidth - 60, 20)];
        text.text = @"网络异常，请检查您的网络状态";
        text.textAlignment = NSTextAlignmentCenter;
        text.font = [UIFont systemFontOfSize:14];
        text.textColor = Font_color2;
        _netweakLabel = text;
    }
    return _netweakLabel;
}


#pragma mark - 加载中的控件
- (UIView *)loadingView {
    
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 100) * 0.5, (kScreenHeight - 120) * 0.5 - 80, 100, 120)];
        [_loadingView addSubview:self.loadingImage];
        [_loadingView addSubview:self.loadingText];
    }
    return _loadingView;
}

- (UIImageView *)loadingImage {
    
    if (!_loadingImage) {
        _loadingImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]];
//        _loadingImage.image = [UIImage sd_animatedGIFWithData:gif];
    }
    return _loadingImage;
}

- (UILabel *)loadingText {
    
    if (!_loadingText) {
        _loadingText = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 20)];
        _loadingText.textColor = Font_color2;
        _loadingText.font = [UIFont systemFontOfSize:14];
        _loadingText.text = @"正在加载中...";
        _loadingText.textAlignment = NSTextAlignmentCenter;
    }
    return _loadingText;
}


@end
