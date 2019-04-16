//
//  VipVC.m
//  SocialContact
//
//  Created by EDZ on 2019/2/13.
//  Copyright © 2019 ha. All rights reserved.
//

#import "VipVC.h"
#import "ServiceModel.h"
#import "ViewTopView.h"
#import "YueServiceView.h"
#import "YFMPaymentView.h"
#import "WechatOrderModel.h"
#import "WXApiManager.h"
#import "VipView.h"

@interface VipVC ()<ViewTopViewDelegate,YueServiceViewDelegate,UIScrollViewDelegate,WXApiManagerDelegate,VipViewDelegate>
// 所有服务卡
INS_P_STRONG(NSMutableArray *, dataArray);

// 当前充值的 服务下期中一项价格，ProductInfoModel
INS_P_STRONG(ProductInfoModel *, productInfoModel);
// 当前充值的 服务类型
INS_P_STRONG(ServiceModel *, payServiceModel);


// 当前页面的服务类型
INS_P_STRONG(ServiceModel *, serviceModel);
// 线下服务卡
INS_P_STRONG(ServiceModel *, serviceXianXiaYueModel);


INS_P_STRONG(UIScrollView *, bgScrollView);

INS_P_STRONG(UIImageView *, bgImgView);

// 置顶项目 收费视图
INS_P_STRONG(ViewTopView *, viewTopView);

INS_P_STRONG(VipView *, vipView);

// 服务卡收费视图
INS_P_STRONG(YueServiceView *, yueServiceView);

/*
 会员和支付选中的价格列表
 0：
 1：
 2：
 */

INS_P_ASSIGN(NSInteger, selectedIndex);

/*
 服务卡选中的价格列表
 0：线上服务卡
 1：线下服务卡
 */
INS_P_ASSIGN(NSInteger, selectedServiceCardIndex);

@end

@implementation VipVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_type == 2) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    }else{
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    self.fd_prefersNavigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PayBackApp) name:@"PayBackApp" object:nil];
    [WXApiManager sharedManager].delegate = self;
    
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.bgScrollView];
    if (_type == 2) {
        
        [self.bgScrollView addSubview:self.bgImgView];
        [self.bgScrollView addSubview:self.viewTopView];
        [self createCustomTitleView:@"置顶服务" backgroundColor:[UIColor colorWithHexString:@"FBE4EC"]  rightItem:nil backContainAlpha:NO];
        [self serviceProduct];
        
    }else if (_type == 1) {
        
//        [self.bgScrollView addSubview:self.bgImgView];
        [self.bgScrollView addSubview:self.vipView];
        [self createCustomTitleView:@"会员服务" backgroundColor:Black  rightItem:nil backContainAlpha:NO];
        [self serviceProduct];
        [self refreshUserInfo];
        
    }else if (_type == 3) {
        
        [self.bgScrollView addSubview:self.yueServiceView];
        [self createCustomTitleView:@"红娘牵线卡" backgroundColor:YueHuiRed rightItem:nil backContainAlpha:NO];
        [self serviceProduct];
        
        // 更新最新的个人信息状态
        [self refreshUserInfo];
        
    }
}

- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        
        if (_type == 2) {
            _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, GuaTopHeight, kScreenWidth, kScreenHeight-GuaTopHeight)];
            _bgScrollView.contentSize = CGSizeMake(kScreenWidth, 2.85*kScreenWidth+350);
        }else if (_type == 1) {
            _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            _bgScrollView.contentSize = CGSizeMake(kScreenWidth, 750);
        }else if (_type == 3) {
            _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, GuaTopHeight, kScreenWidth, kScreenHeight-GuaTopHeight)];
            _bgScrollView.contentSize = CGSizeMake(kScreenWidth, 2.2*kScreenWidth);
        }
        _bgScrollView.bounces = NO;
        _bgScrollView.delegate = self;
        _bgScrollView.showsVerticalScrollIndicator = NO;
    }
    return _bgScrollView;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    if ( _type == 1 || _type == 2) {
//        if (scrollView.contentOffset.y<StatusBarHeight) {
//            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//        }else{
//            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//        }
//    }
}


- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 4*kScreenWidth)];
        _bgImgView.image = [UIImage imageNamed:@"vip_top"];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bgImgView;
    
}

- (ViewTopView *)viewTopView{
    if (!_viewTopView) {
        _viewTopView = [[[NSBundle mainBundle]loadNibNamed:@"ViewTopView" owner:self options:nil] lastObject];
        _viewTopView.delegate = self;
        _viewTopView.frame = CGRectMake(0, 2.85*kScreenWidth, kScreenWidth, 350);
        _viewTopView.hidden = YES;
    }
    return _viewTopView;
}

- (VipView *)vipView{
    
    if (!_vipView) {
        _vipView = [[[NSBundle mainBundle]loadNibNamed:@"VipView" owner:self options:nil] lastObject];
        _vipView.delegate = self;
        _vipView.frame = CGRectMake(0, 0, kScreenWidth,750);
        _vipView.hidden = YES;
    }
    return _vipView;
}

- (YueServiceView *)yueServiceView{
    if (!_yueServiceView) {
        _yueServiceView = [[[NSBundle mainBundle]loadNibNamed:@"YueServiceView" owner:self options:nil] lastObject];
        _yueServiceView.delegate = self;
        _yueServiceView.frame = CGRectMake(0, 0, kScreenWidth, 2.2*kScreenWidth);
        _yueServiceView.hidden = YES;
    }
    return _yueServiceView;
}


- (void)selectPayMethod:(NSInteger )selectPriceIndex{
    
    NSArray *payTypeArr;
    
    payTypeArr = @[@{@"pic":@"pic_alipay",
                              @"recommend":@"recommend_alipay",
                              @"title":@"支付宝",
                              @"des":@"数亿用户都在用，安全可托付",
                              @"type":@"alipay"},
                            @{@"pic":@"pic_wxpay",
                              @"recommend":@"recommend_wxpay",
                              @"title":@"微信",
                              @"des":@"亿万用户的选择，更快更安全",
                              @"type":@"wxpay"}];
    
    YFMPaymentView *pop = [[YFMPaymentView alloc]initTotalPay:[NSString stringWithFormat:@"%.2lf",self.productInfoModel.price] vc:self dataSource:payTypeArr];
    STPopupController *popVericodeController = [[STPopupController alloc] initWithRootViewController:pop];
    popVericodeController.style = STPopupStyleBottomSheet;
    [popVericodeController presentInViewController:self];
    
    WEAKSELF;
    pop.payType = ^(NSString *type,NSString *balance) {
        
        NSLog(@"选择了支付方式:%@\n需要支付金额:%@",type,balance);
        if ([type isEqualToString:@"alipay"]) {
            
            [weakSelf buy:selectPriceIndex pay_type:1 payServiceModel:weakSelf.payServiceModel];
        }else if ([type isEqualToString:@"wxpay"]) {
            
            [weakSelf buy:selectPriceIndex pay_type:2 payServiceModel:weakSelf.payServiceModel];
        }
    };
    
}

#pragma mark YueServiceViewDelegate

- (void)xianShangBtnClicked{
    
    _selectedServiceCardIndex = 0;
    
    if ([SCUserCenter sharedCenter].currentUser.userInfo.online_card_count == 0) {
        [self.yueServiceView.payBtn setTitle:@"购买线上服务卡" forState:UIControlStateNormal];
    }else{
        [self.yueServiceView.payBtn setTitle:@"使用线上服务卡约" forState:UIControlStateNormal];
    }
    
}

- (void)xianXiaBtnClicked{
    
    _selectedServiceCardIndex = 1;
    
    if ([SCUserCenter sharedCenter].currentUser.userInfo.offline_card_count == 0) {
        [self.yueServiceView.payBtn setTitle:@"购买线下服务卡" forState:UIControlStateNormal];
    }else{
        [self.yueServiceView.payBtn setTitle:@"使用线下服务卡约" forState:UIControlStateNormal];
    }
}

/*
 微信支付回调
 */
- (void)payClicked{
    
    if (_selectedServiceCardIndex == 0) {
        
        if ([SCUserCenter sharedCenter].currentUser.userInfo.online_card_count == 0) {
            [self checkPayService];
            [self selectPayMethod:0];
        }else{
            [self yueRen];
        }
    }else if (_selectedServiceCardIndex == 1) {
        
        if ([SCUserCenter sharedCenter].currentUser.userInfo.offline_card_count == 0) {
            [self checkPayService];
            [self selectPayMethod:0];
        }else{
            [self yueRen];
        }
    }
    
}

#pragma mark 微信支付回调
/*
 微信支付回调
 */
- (void)managerDidRecvNonTaxpayRespResponse:(PayResp *)response
{
    
    
    
    NSLog(@"支付结果%@",response.returnKey);
    
   
    switch(response.errCode){
        case WXSuccess:
            //服务器端查询支付通知或查询API返回的结果再提示成功
            NSLog(@"支付成功");
            [self PayBackApp];
            break;
        default:
            NSLog(@"支付失败，retcode=%d",response.errCode);
            
            [SVProgressHUD showImage:AlertErrorImage status:response.errStr?:@"您已取消支付"];
            [SVProgressHUD dismissWithDelay:1.5];
            break;
        
    }

}

- (void)yueRen{
    
    /*
     0    请求微信
     1    线上约她
     2    线下约她
     */
    [self showLoading];
    
    NSInteger demand_type = _selectedServiceCardIndex+1;
    
    NSDictionary *dic = @{
                          @"to_customer_id":[NSNumber numberWithInteger:self.userId],
                          @"demand_type":[NSNumber numberWithInteger:demand_type],
                          };
    WEAKSELF;
    POSTRequest *request = [POSTRequest requestWithPath:@"/api/demands/add_ask/" parameters:dic completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            [weakSelf.view makeToast:@"约会申请发送成功"];
            [weakSelf refreshUserInfo];
        }
        
    }];
    [InsNetwork addRequest:request];
}

- (void)refreshUserInfo{
    WEAKSELF;
    [SCUserCenter getSelfInformationAndUpdateDBWithUserId:[SCUserCenter sharedCenter].currentUser.userInfo.iD completion:^(id  _Nonnull responseObj, BOOL succeed, NSError * _Nonnull error) {
        
        
        if (weakSelf.type == 1) {
            
            weakSelf.vipView.userModel = [SCUserCenter sharedCenter].currentUser.userInfo;
            
        }else{
        
            if (weakSelf.selectedServiceCardIndex == 0 ) {
                
              
                
                if ([SCUserCenter sharedCenter].currentUser.userInfo.online_card_count == 0) {
                    [weakSelf.yueServiceView.payBtn setTitle:@"购买线上服务卡" forState:UIControlStateNormal];
                }else{
                    [weakSelf.yueServiceView.payBtn setTitle:@"使用线上服务卡约" forState:UIControlStateNormal];
                }
                
            }else if (weakSelf.selectedServiceCardIndex == 1 ) {
                
                if ([SCUserCenter sharedCenter].currentUser.userInfo.offline_card_count == 0) {
                    [weakSelf.yueServiceView.payBtn setTitle:@"购买线下服务卡" forState:UIControlStateNormal];
                }else{
                    [weakSelf.yueServiceView.payBtn setTitle:@"使用线下服务卡约" forState:UIControlStateNormal];
                }
            }
            
            weakSelf.yueServiceView.fuwuKa.text = [NSString stringWithFormat:@"线上服务卡 %ld 张，线下服务卡 %ld 张",[SCUserCenter sharedCenter].currentUser.userInfo.online_card_count,[SCUserCenter sharedCenter].currentUser.userInfo.offline_card_count];
        }
    }];
    
}

    



- (void)checkPayService{
    
    for (ServiceModel *model in self.dataArray) {
        
        
        if (self.type == 1) {
            if (model.service_type == 1) {
                self.payServiceModel = model;
                self.productInfoModel = model.pricelist[_selectedIndex];
            }
        }else if (self.type == 2) {
            if (model.service_type == 2) {
                self.payServiceModel = model;
                self.productInfoModel = model.pricelist[_selectedIndex];
            }
        }else if (self.type == 3) {
            
            if (_selectedServiceCardIndex == 0 && model.service_type == 3) {
                self.payServiceModel = model;
                self.productInfoModel = model.pricelist[0];
            }else if (_selectedServiceCardIndex == 1 && model.service_type == 4) {
                self.payServiceModel = model;
                self.productInfoModel = model.pricelist[0];
            }
        }
        
    }
    
}

#pragma mark ViewTopViewDelegate

- (void)btn1Clicked{

    _selectedIndex = 0;
}

- (void)btn2Clicked{

    _selectedIndex = 1;
}

- (void)btn3Clicked{

    _selectedIndex = 2;
}

- (void)dredgeBtnClicked{
    
    [self checkPayService];
    
    [self selectPayMethod:_selectedIndex];
}


- (void)selectedIndex:(NSInteger)index{
    _selectedIndex = index;
}

- (void)vipDredgeBtnClicked{
    
    [self checkPayService];
    
    [self selectPayMethod:_selectedIndex];
}

- (void)PayBackApp{

    /*
     1    会员
     2    首页显示
     3    红娘线上服务卡
     4    红娘线下服务卡
     */
#pragma mark TODO
    // 1s 后查询状态
    
    WEAKSELF;
    
    if (weakSelf.type == 1 || weakSelf.type == 2) {
        [Help vipIsExpired:^(BOOL expired) {
            
            if (weakSelf.type == 1) {
                [weakSelf alert:expired];
            }
            
            [SCUserCenter getSelfInformationAndUpdateDBWithUserId:[SCUserCenter sharedCenter].currentUser.userInfo.iD completion:^(id  _Nonnull responseObj, BOOL succeed, NSError * _Nonnull error) {
               
                weakSelf.vipView.userModel = [SCUserCenter sharedCenter].currentUser.userInfo;
                
            }];
            
        } topIsExpired:^(BOOL expired) {
            
            if (weakSelf.type == 2) {
                [weakSelf alert:expired];
            }
            
        }];
    }else if(weakSelf.type == 3){
        
        [SCUserCenter getSelfInformationAndUpdateDBWithUserId:[SCUserCenter sharedCenter].currentUser.userInfo.iD completion:^(id  _Nonnull responseObj, BOOL succeed, NSError * _Nonnull error) {
           
            if (weakSelf.selectedServiceCardIndex == 0 ) {
                
                if ([SCUserCenter sharedCenter].currentUser.userInfo.online_card_count > 0) {
                    [weakSelf.view makeToast:@"线上服务卡购买成功"];
                }else{
                    [weakSelf.view makeToast:@"线上服务卡购买失败，请联系客服解决"];
                }
                
                if ([SCUserCenter sharedCenter].currentUser.userInfo.online_card_count == 0) {
                    [weakSelf.yueServiceView.payBtn setTitle:@"购买线上服务卡" forState:UIControlStateNormal];
                }else{
                    [weakSelf.yueServiceView.payBtn setTitle:@"使用线上服务卡约" forState:UIControlStateNormal];
                }
                
            }else if (weakSelf.selectedServiceCardIndex == 1 ) {
                
                if ([SCUserCenter sharedCenter].currentUser.userInfo.offline_card_count > 0) {
                    [weakSelf.view makeToast:@"线下服务卡购买成功"];
                }else{
                    [weakSelf.view makeToast:@"线下服务卡购买失败，请联系客服解决"];
                }
                
                if ([SCUserCenter sharedCenter].currentUser.userInfo.offline_card_count == 0) {
                    [weakSelf.yueServiceView.payBtn setTitle:@"购买线下服务卡" forState:UIControlStateNormal];
                }else{
                    [weakSelf.yueServiceView.payBtn setTitle:@"使用线下服务卡约" forState:UIControlStateNormal];
                }
            }
            
            weakSelf.yueServiceView.fuwuKa.text = [NSString stringWithFormat:@"线上服务卡 %ld 张，线下服务卡 %ld 张",[SCUserCenter sharedCenter].currentUser.userInfo.online_card_count,[SCUserCenter sharedCenter].currentUser.userInfo.offline_card_count];
            
            
            
        }];
        
    }
    
}

- (void)alert:(BOOL)expired{
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.labelTitle.textColor = [UIColor redColor];
    if (expired) {
        [alert showError:[NSString stringWithFormat:@"%@充值失败",self.productInfoModel.name] subTitle:self.serviceModel.detail closeButtonTitle:@"确定" duration:0];
    }else{
        [alert showSuccess:[NSString stringWithFormat:@"%@充值成功",self.productInfoModel.name] subTitle:self.serviceModel.detail closeButtonTitle:@"确定" duration:0];
    }
}


/**
 服务列表
 */
- (void)serviceProduct{
/*    /api/virtual-services/
    
    id    int        平台服务id
 service_type    int    服务类型, 1: VIP服务; 2: 置顶服务;  3    红娘线上服务卡；4    红娘线下服务卡
    name    string        平台服务名称
    pricelist    list        套餐列表
    detail    string        服务介绍
    create_at    string        服务创建时间
 */
    [self.view makeToastActivity:CSToastPositionCenter];
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/api/virtual-services/" parameters:nil completionHandler:^(InsRequest *request) {
        
        [weakSelf.view hideToastActivity];
        
        if (request.error) {
            
        }else{
            NSArray *resultArray = request.responseObject[@"data"][@"results"];
            if ( resultArray && resultArray.count > 0 ) {
            
                if (self.type == 2) {
                    weakSelf.viewTopView.hidden = NO;
                }else if (self.type == 1){
                    weakSelf.vipView.hidden = NO;
                }else if (self.type == 3) {
                    weakSelf.yueServiceView.hidden = NO;
                }
                
                
                [weakSelf.dataArray removeAllObjects];
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ServiceModel *productModel = [ServiceModel modelWithDictionary:obj];
                    [weakSelf.dataArray addObject:productModel];
                    
                }];
                
                for (ServiceModel *model in self.dataArray) {
                    
                    
                    if (self.type == 1) {
                        if (model.service_type == 1) {
                            weakSelf.serviceModel = model;
                            
                            if (model.pricelist.count > 4) {
                                weakSelf.vipView.frame = CGRectMake(0, 0, kScreenWidth,750);
                                weakSelf.bgScrollView.contentSize = CGSizeMake(kScreenWidth, 750);
                            }else{
                                weakSelf.vipView.frame = CGRectMake(0, 0, kScreenWidth,650);
                                weakSelf.bgScrollView.contentSize = CGSizeMake(kScreenWidth, 650);
                            }
                            
                        }
                    }else if (self.type == 2) {
                        if (model.service_type == 2) {
                            weakSelf.serviceModel = model;
                        }
                    }else if (self.type == 3) {
                        
                        if (model.service_type == 3) {
                            weakSelf.serviceModel = model;
                        }else if (model.service_type == 4) {
                            weakSelf.serviceXianXiaYueModel = model;
                        }
                    }
                    
                }
                if ( self.type == 2) {
                    weakSelf.viewTopView.serviceModel = weakSelf.serviceModel;
                }else if (self.type == 1) {
                    weakSelf.vipView.serviceModel = weakSelf.serviceModel;
                }else if (self.type == 3) {
                    weakSelf.yueServiceView.serviceXianShangYueModel = weakSelf.serviceModel;
                    weakSelf.yueServiceView.serviceXianXiaYueModel = weakSelf.serviceXianXiaYueModel;
                    weakSelf.yueServiceView.fuwuKa.text = [NSString stringWithFormat:@"线上服务卡 %ld 张，线下服务卡 %ld 张",[SCUserCenter sharedCenter].currentUser.userInfo.online_card_count,[SCUserCenter sharedCenter].currentUser.userInfo.offline_card_count];
                    
                    if ([SCUserCenter sharedCenter].currentUser.userInfo.online_card_count == 0) {
                        [weakSelf.yueServiceView.payBtn setTitle:@"购买线上服务卡" forState:UIControlStateNormal];
                    }else{
                        [weakSelf.yueServiceView.payBtn setTitle:@"使用线上服务卡约" forState:UIControlStateNormal];
                    }
                    
                }
                
            }else{
                if (self.type == 1) {
                    weakSelf.vipView.hidden = YES;
                    
                }else if (self.type == 2) {
                    weakSelf.viewTopView.hidden = YES;
                }else if (self.type == 3) {
                    weakSelf.yueServiceView.hidden = YES;
                }
            }
        }
        
    }];
    
    [InsNetwork addRequest:request];
}

- (void)buy:(NSInteger)index pay_type:(NSInteger)pay_type payServiceModel:(ServiceModel *)serviceModel{
    
    /*
    购买服务
    
     service_type    int    服务类型, 1: VIP服务; 2: 置顶服务
     
    Request
    
LoginRequired: False
Method: POST
URL:  /api/virtual-services/<int:pk>/buy/
     
     pk    int    True        付费服务id
     pay_type    True    int        支付平台: 支付宝==1，微信==2
     pay_from    int    True        支付方式: APP==APP支付
     price_index    int    True        价格套餐: 价格套餐对应index, 默认：0
     
     */
    
    if (!serviceModel) {
        return;
    }
    
    if (pay_type == 1) {

        if (serviceModel.pricelist.count > index) {
            NSDictionary *para = @{
                                   @"pk":[NSNumber numberWithInteger:serviceModel.iD],
                                   @"pay_from":@"APP",
                                   @"price_index":@(index),
                                   };
            [self.view makeToastActivity:CSToastPositionCenter];
            WEAKSELF;
            POSTRequest *request = [POSTRequest requestWithPath:[NSString stringWithFormat:@"/api/virtual-services/%ld/alipay/",serviceModel.iD] parameters:para completionHandler:^(InsRequest *request) {
                
                [weakSelf.view hideToastActivity];
                if (request.error) {
                    
                }else{
                    NSString *orderStr = request.responseObject[@"data"][@"order_string"];
                    if ([NSString ins_String:orderStr]) {
                        [weakSelf payOrder:orderStr payType:pay_type];
                    }
                }
            }];
            [InsNetwork addRequest:request];
        }
        
    }else if (pay_type == 2) {
        
        if (serviceModel.pricelist.count > index) {
            NSDictionary *para = @{
                                   @"pk":[NSNumber numberWithInteger:serviceModel.iD],
                                   @"pay_from":@"APP",
                                   @"price_index":@(index),
                                   };
            [self.view makeToastActivity:CSToastPositionCenter];
            WEAKSELF;
            POSTRequest *request = [POSTRequest requestWithPath:[NSString stringWithFormat:@"/api/virtual-services/%ld/wechatpay/",serviceModel.iD] parameters:para completionHandler:^(InsRequest *request) {
                
                [weakSelf.view hideToastActivity];
                if (request.error) {
                    
                }else{
                    WechatOrderModel *wechatOrderModel = [WechatOrderModel modelWithDictionary:request.responseObject[@"data"][@"order_string"]];
                    if (wechatOrderModel) {
                        [weakSelf weChatPay:wechatOrderModel];
                    }
                }
            }];
            [InsNetwork addRequest:request];
        }
    }
    
}

#pragma mark 调起支付

/**
 调起支付

 @param orderString 订单参数签名字符串
 @param payType 1：支付宝，2：微信
 */
- (void)payOrder:(NSString *)orderString payType:(NSInteger)payType{
    // NOTE: 调用支付结果开始支付
    
    if (payType == 1) {
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"com.cvmars.handan" callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PayBackApp" object:resultDic];
        }];
        
    }else if (payType == 2) {
        
        
    }
    
    
}

- (void)weChatPay:(WechatOrderModel *)model{
    
    //向微信注册
    [WXApi registerApp:model.appid];
    
    //调起微信支付
    PayReq* req  = [[PayReq alloc] init];
    req.partnerId = model.partnerid;
    req.prepayId  = model.prepayid;
    req.nonceStr  = model.noncestr;
    int  timesta = model.timestamp.intValue;
    req.timeStamp = (UInt32)timesta;
    req.package = model.package;
    req.sign = model.sign;
    if ([WXApi sendReq:req]) {

    }else{
        [self.view makeToast:@"请先安装微信客户端"];
    }
    
}



#pragma mark ---  创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (![[dict objectForKey:categoryId] isEqualToString:@""]&& ![categoryId isEqualToString:@"sign"] && ![categoryId isEqualToString:@"key"] )  {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", kWeChatAppS];
    NSLog(@"%@",contentString);
    //得到MD5 sign签名
    NSString *md5Sign =[[contentString md5String]uppercaseString];
    return md5Sign;
}

#pragma mark - 产生随机字符串
- (NSString *)generateRandomString {
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
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
