//
//  XHBottleViewController.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-17.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHBottleViewController.h"

#import "MyBottlesVC.h"

#import "XHInputView.h"
#import "BottleModel.h"


@interface XHBottleViewController ()

@property (nonatomic, strong) UIImageView *pickerMarkImageView;
@property (nonatomic, strong) UIButton *pickerButton;
@property (nonatomic, strong) UIImageView *fishwaterAnimatedImageView;

@property (nonatomic, weak) UIImageView *boardImageView;
@property (nonatomic, weak) UIButton *throwButton;
@property (nonatomic, weak) UIButton *fishButton;
@property (nonatomic, weak) UIButton *mineButton;

@property (nonatomic, strong) BottleModel *pickedBottleModel;
@end

@implementation XHBottleViewController

#pragma mark - Action

- (void)boardButtonClicked:(UIButton *)sender {
    
    
    /*
     1. 发个文本
     */
    if ([sender isEqual:self.throwButton]) {
        
        [self send];
        
    }else if ([sender isEqual:self.fishButton]) {
        
        [self pickBottle];
        
    }else if ([sender isEqual:self.mineButton]) {
        
        MyBottlesVC *vc = [MyBottlesVC new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (void)send{
    
    WEAKSELF;
    [XHInputView showWithStyle:InputViewStyleLarge configurationBlock:^(XHInputView *inputView) {
        
        inputView.placeholder = @"分享情感";
        inputView.sendButtonTitle = @"发送";

        
    } sendBlock:^BOOL(NSString *text) {
        
        if (text.length) {
            
            [weakSelf sendPiaoLiuPing:text];
        }else {
            
            [weakSelf.view makeToast:@"内容不能为空"];
        }
        
        return YES;
        
    }];
    
}

- (void)sendPiaoLiuPing:(NSString *)text{
    
//    /bottles-mine/
    NSDictionary *para = @{
                           @"text":text,
                           };
    WEAKSELF;
    POSTRequest *request = [POSTRequest requestWithPath:@"/api/bottles-mine/" parameters:para completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            [weakSelf showPickerMarkImageView:YES result:2 send:YES];
        }
        
    }];
    [InsNetwork addRequest:request];
}

- (void)pickBottle{
    // /bottles/pickone/
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/api/bottles/pickone/" parameters:nil completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            BottleModel *model = [BottleModel modelWithDictionary:request.responseObject[@"data"]];
            if (model) {
                weakSelf.pickedBottleModel = model;
                [weakSelf showPickerMarkImageView:!weakSelf.pickerMarkImageView.alpha result:2 send:NO];
            }else{
                [weakSelf showPickerMarkImageView:!weakSelf.pickerMarkImageView.alpha result:0 send:NO];
            }
        }
    }];
    [InsNetwork addRequest:request];
}

- (void)pickerButtonClicked:(UIButton *)sender {
    // 打开瓶子
    [self showPickerButton:NO];
    
    //Using Block
    WEAKSELF;
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = NO;
    [alert removeTopCircle];
    //    backgroundColor, borderWidth, borderColor, textColor
    alert.buttonFormatBlock = ^NSDictionary *{
        return @{
                 @"backgroundColor":ORANGE,
                 @"textColor":[UIColor whiteColor],
                 };
    };
    
    [alert alertIsDismissed:^{
        
        if (!weakSelf.pickedBottleModel.isAbandon) {
            [[AppDelegate sharedDelegate].isBottleCharts addObject:[NSString stringWithFormat:@"%ld",weakSelf.pickedBottleModel.customer.user_id]];
        }
        
    }];
    
    
    [alert addButton:@"扔回大海" actionBlock:^(void) {
        [weakSelf deletePickedBottle];
    }];
    
    [alert showNotice:self title:[NSString stringWithFormat:@"来自 %@ ",_pickedBottleModel.customer.name] subTitle:_pickedBottleModel.text closeButtonTitle:@"收集" duration:0.0f]; // Notice
    
    
}

- (void)addChatrecord{
    
//    /api/chatrecord/upload_record/
    
    NSDictionary *dic = @{
                    @"user_id":@(self.pickedBottleModel.customer.user_id),
                          };
    POSTRequest *request = [POSTRequest requestWithPath:@"/api/chatrecord/upload_record/" parameters:dic completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            
        }else{
            [SVProgressHUD showImage:AlertSuccessImage status:@"你们2个人可以无限制聊天了"];
            [SVProgressHUD dismissWithDelay:1.5];
        }
        
    }];
    [InsNetwork addRequest:request];
    
}

- (void)deletePickedBottle{
//    /api/bottles-picked/<int:pk>/
    
    _pickedBottleModel.isAbandon = YES;
    DELETERequest *request = [DELETERequest requestWithPath:[NSString stringWithFormat:@"/api/bottles-picked/%ld",_pickedBottleModel.iD] parameters:nil completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            
        }else{
            
        }
        
    }];
    [InsNetwork addRequest:request];
    
}


#pragma mark 动画

- (void)showPickerMarkImageView:(BOOL)show result:(NSInteger)result send:(BOOL)send{
    
    if (send) {
        self.pickerButton.alpha = 1;
        _fishwaterAnimatedImageView.center = CGPointMake(CGRectGetWidth(self.pickerMarkImageView.bounds) / 2.0, CGRectGetHeight(self.pickerMarkImageView.bounds) / 2.0);
    }else{
        _fishwaterAnimatedImageView.center = CGPointMake(CGRectGetWidth(self.pickerMarkImageView.bounds) / 1.6, CGRectGetHeight(self.pickerMarkImageView.bounds) / 2.0);
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pickerMarkImageView.alpha = show;
        
        if (send) {
            self.pickerButton.alpha = 0;
        }else{
            self.pickerButton.alpha = show;
        }
        
        self.boardImageView.alpha = !show;
        self.throwButton.alpha = !show;
        self.fishButton.alpha = !show;
        self.mineButton.alpha = !show;
    } completion:^(BOOL finished) {
        if (show) {
            
            [self setupResult:result send:send];
            
            if (send) {
                [self performSelector:@selector(hideResult) withObject:nil afterDelay:0.5];
            }else{
                [self performSelector:@selector(showResult) withObject:nil afterDelay:0.5];
            }
        }
    }];
}

// 瓶子出现，捡瓶子
- (void)showResult {
    [self showPickerButton:YES];
}
// 瓶子消失，扔瓶子
- (void)hideResult{
    [self showPickerButton:NO];
}

- (void)showPickerButton:(BOOL)show {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pickerButton.alpha = show;
        self.fishwaterAnimatedImageView.alpha = show;
        self.pickerMarkImageView.alpha = show;
        
        self.boardImageView.alpha = !show;
        self.throwButton.alpha = !show;
        self.fishButton.alpha = !show;
        self.mineButton.alpha = !show;
        
    } completion:^(BOOL finished) {
        [self.fishwaterAnimatedImageView stopAnimating];
    }];
}


- (void)setupResult:(NSInteger)result send:(BOOL)send{
//    NSInteger result = random()%3;
    
    NSString *resultImageName;
    switch (result) {
        case 0:
            resultImageName = @"bottleStarfish";
            break;
        case 1:
            resultImageName = @"bottleRecord";
            break;
        case 2:
            resultImageName = @"bottleWriting";
            break;
        default:
            break;
    }
    [self.pickerButton setBackgroundImage:[UIImage imageNamed:resultImageName] forState:UIControlStateNormal];
    
    if (send) {
        self.fishwaterAnimatedImageView.alpha = 1.0;
        [self.fishwaterAnimatedImageView startAnimating];
    }
    
}

#pragma mark - Propertys

- (UIImageView *)pickerMarkImageView {
    if (!_pickerMarkImageView) {
        _pickerMarkImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _pickerMarkImageView.image = [UIImage imageNamed:@"bottleBkgSpotLight"];
        _pickerMarkImageView.alpha = 0.0;
    }
    return _pickerMarkImageView;
}

- (UIButton *)pickerButton {
    if (!_pickerButton) {
        _pickerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 104, 60)];
        [_pickerButton addTarget:self action:@selector(pickerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _pickerButton.center = CGPointMake(CGRectGetWidth(self.pickerMarkImageView.bounds) / 2.0, CGRectGetHeight(self.pickerMarkImageView.bounds) / 2.0);
        _pickerButton.alpha = 0.0;
    }
    return _pickerButton;
}

- (UIImageView *)fishwaterAnimatedImageView {
    if (!_fishwaterAnimatedImageView) {
        _fishwaterAnimatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 68, 48)];
        _fishwaterAnimatedImageView.alpha = 0.0;
        _fishwaterAnimatedImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"fishwater"], [UIImage imageNamed:@"fishwater2"], [UIImage imageNamed:@"fishwater3"], nil];
        _fishwaterAnimatedImageView.animationDuration = 1.0;
        _fishwaterAnimatedImageView.center = CGPointMake(CGRectGetWidth(self.pickerMarkImageView.bounds) / 1.6, CGRectGetHeight(self.pickerMarkImageView.bounds) / 2.0);
    }
    return _fishwaterAnimatedImageView;
}

#pragma mark - Life Cycle

- (void)initilzer {
    // duw with backgrounImage form date
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit fromDate:now];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"bg_piaoliu"];
//    if(components.hour > 12) {
//        backgroundImage = [UIImage imageNamed:@"bottleNightBkg"];
//    } else {
//        backgroundImage = [UIImage imageNamed:@"bottleBkg"];
//    }
    [self setupBackgroundImage:backgroundImage];
    
    // board
    if (!_boardImageView) {
        UIImageView *boardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 46, CGRectGetWidth(self.view.bounds), 46)];
        boardImageView.image = [UIImage imageNamed:@"bottleBoard"];
        [self.view addSubview:boardImageView];
        self.boardImageView = boardImageView;
    }
    
    // buttons
    CGFloat buttonWidth = 76;
    CGFloat buttonHeight = 86;
    CGFloat insets = 23;
    CGFloat paddingX = CGRectGetMidX(self.view.bounds) - insets - buttonWidth * 1.5;
    CGFloat paddingY = CGRectGetHeight(self.view.bounds) - buttonHeight;
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(paddingX + i * (buttonWidth + insets), paddingY, buttonWidth, buttonHeight);
        
        [button addTarget:self action:@selector(boardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageName;
        switch (i) {
            case 0: {
                imageName = @"bottleButtonThrow";
                self.throwButton = button;
                break;
            }
            case 1: {
                self.fishButton = button;
                imageName = @"bottleButtonFish";
                break;
            }
            case 2:
                self.mineButton = button;
                imageName = @"bottleButtonMine";
                break;
            default:
                break;
        }
        
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    
    [self.view addSubview:self.pickerMarkImageView];
    [self.view addSubview:self.pickerButton];
    [self.view addSubview:self.fishwaterAnimatedImageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createCustomTitleView:@"漂流瓶" backgroundColor:nil rightItem:nil backContainAlpha:NO];
    
    self.fd_prefersNavigationBarHidden = YES;
    [self initilzer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}


- (void)setupBackgroundImage:(UIImage *)backgroundImage {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
