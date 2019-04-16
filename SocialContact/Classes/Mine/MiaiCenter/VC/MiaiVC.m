//
//  MiaiVC.m
//  SocialContact
//
//  Created by EDZ on 2019/3/29.
//  Copyright © 2019 ha. All rights reserved.
//

#import "MiaiVC.h"
#import "XLSphereView.h"
#import "UIButton+WebCache.h"
#import "UserHomepageVC.h"

@interface MiaiVC ()

@property (nonatomic,strong) XLSphereView *sphereView;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) UIButton *exchangeBtn;

@end

@implementation MiaiVC


- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相亲大厅";
    self.fd_prefersNavigationBarHidden = NO;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"C9D6DE"];
    [self.view addSubview:self.sphereView];
    [self.view addSubview:self.exchangeBtn];
    
    self.array = [NSMutableArray array];
    [self fetchData:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"修改资料" style:UIBarButtonItemStylePlain target:self action:@selector(modifyUserInfo)];
    self.navigationItem.rightBarButtonItem.tintColor = ORANGE;
    
}

- (void)modifyUserInfo{
    
    
    
}

- (UIButton *)exchangeBtn{
    
    if (!_exchangeBtn) {
        _exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exchangeBtn setTitle:@"换一批" forState:UIControlStateNormal];
        _exchangeBtn.titleLabel.textColor = [UIColor whiteColor];
        _exchangeBtn.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:15];
        _exchangeBtn.frame = CGRectMake(0, kScreenHeight-150, 100, 44);
        _exchangeBtn.centerX = self.view.centerX;
        [_exchangeBtn setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
        _exchangeBtn.layer.cornerRadius = 22;
        _exchangeBtn.layer.masksToBounds = YES;
        [_exchangeBtn addTarget:self action:@selector(exchangeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeBtn;
}

- (void)exchangeBtnClick{
    
    [self fetchData:YES];
}

- (void)fetchData:(BOOL)refresh{
    
//    /customer/single/lists/
    if (refresh) {
        _page = 1;
    }else{
        _page ++;
    }
    NSDictionary *dic = @{
                          @"page":@(_page),
                          };
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/customer/single/lists/" parameters:dic completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            
            [weakSelf.array removeAllObjects];
            
            NSArray *resultArray = request.responseObject[@"data"][@"results"];
            if ( resultArray && resultArray.count > 0 ) {
            
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    SCUserInfo *model = [SCUserInfo modelWithDictionary:obj];
                    [weakSelf.array addObject:model];
                    
                }];
            }
            
            [weakSelf reload];
        }
        
    }];
    [InsNetwork addRequest:request];
}


- (XLSphereView *)sphereView{
    
    if (!_sphereView) {
        CGFloat sphereViewW = self.view.frame.size.width - 30 * 2;
        CGFloat sphereViewH = sphereViewW;
        _sphereView = [[XLSphereView alloc] initWithFrame:CGRectMake(30, 100, sphereViewW, sphereViewH)];
    }
    return _sphereView;
}

- (void)reload{
    
    
    [_sphereView timerStop];
    
    [_sphereView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSInteger i = 0; i < self.array.count; i ++) {
        
        SCUserInfo *model = self.array[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 80, 80);
        [btn sd_setImageWithURL:[NSURL URLWithString:model.avatar_url?:@""] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 40;
        btn.clipsToBounds = YES;
        btn.tag = i+1000;
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        
        [_sphereView addSubview:btn];
    }
    [_sphereView setItems:array];
}

- (void)buttonPressed:(UIButton *)btn
{
    [_sphereView timerStop];
    WEAKSELF;
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(2., 2.);
    } completion:^(BOOL finished) {
        
        [weakSelf.sphereView timerStart];
        [weakSelf sayHi:btn.tag-1000];
        
    }];
}


- (void)sayHi:(NSInteger)idx{
    
    // 打招呼
    SCUserInfo *userInfo = self.array[idx];
    
    UserHomepageVC *vc = [[UserHomepageVC alloc]init];
    vc.userId = userInfo.iD;
    [self.navigationController pushViewController:vc animated:YES];
    
    
#pragma mark TODO
//    RCTextMessage *rcMC = [RCTextMessage messageWithContent:@"你好"];
//    
//    WEAKSELF;
//    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId: [NSString stringWithFormat:@"%ld",userInfo.user_id] content:rcMC pushContent:nil pushData:nil success:^(long messageId) {
//        
//        NSLog(@"打招呼成功");
//        [weakSelf.view makeToast:@"打招呼成功"];
//        
//        [weakSelf.sphereView timerStart];
//        
//    } error:^(RCErrorCode nErrorCode, long messageId) {
//        NSLog(@"打招呼失败");
//        
//        [weakSelf.sphereView timerStart];
//        
//    }];
    
    
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
