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

@interface VipVC ()<ViewTopViewDelegate>

INS_P_STRONG(NSMutableArray *, dataArray);

// 当前充值的 ProductInfoModel
INS_P_STRONG(ProductInfoModel *, productInfoModel);

INS_P_STRONG(ServiceModel *, serviceModel);

INS_P_STRONG(UIScrollView *, bgScrollView);

INS_P_STRONG(UIImageView *, bgImgView);

// 置顶项目 收费视图
INS_P_STRONG(ViewTopView *, viewTopView);

INS_P_ASSIGN(NSInteger, selectedIndex);

@end

@implementation VipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PayBackApp) name:@"PayBackApp" object:nil];
    
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.bgImgView];
    [self.bgScrollView addSubview:self.viewTopView];
    [self serviceProduct];
}

- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-GuaTopHeight)];
        _bgScrollView.contentSize = CGSizeMake(kScreenWidth, 4*kScreenWidth);
        _bgScrollView.showsVerticalScrollIndicator = NO;
    }
    return _bgScrollView;
    
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
        _viewTopView.frame = CGRectMake(0, 2.85*kScreenWidth, kScreenWidth, 1.15*kScreenWidth);
    }
    return _viewTopView;
}

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
    [self buy:_selectedIndex];
}

- (void)PayBackApp{
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.labelTitle.textColor = [UIColor redColor];
    [alert showSuccess:[NSString stringWithFormat:@"%@充值成功",_productInfoModel.name] subTitle:_serviceModel.detail closeButtonTitle:@"确定" duration:0];
    
}

- (void)serviceProduct{
/*    /api/virtual-services/
    
    id    int        平台服务id
    service_type    int    服务类型, 1: VIP服务; 2: 置顶服务
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
            
                weakSelf.viewTopView.hidden = NO;
                
                [weakSelf.dataArray removeAllObjects];
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ServiceModel *productModel = [ServiceModel modelWithDictionary:obj];
                    [weakSelf.dataArray addObject:productModel];
                    
                }];
                
                for (ServiceModel *model in self.dataArray) {
                    if (model.service_type == 2) {
                        weakSelf.serviceModel = model;
                    }
                }
                
                weakSelf.viewTopView.serviceModel = weakSelf.serviceModel;
                
            }else{
                weakSelf.viewTopView.hidden = YES;
            }
        }
        
    }];
    
    [InsNetwork addRequest:request];
}

- (void)buy:(NSInteger)index{
    
    /*
    购买服务
    
     service_type    int    服务类型, 1: VIP服务; 2: 置顶服务
     
    Request
    
LoginRequired: False
Method: POST
URL:  /api/virtual-services/<int:pk>/buy/
     
     pk    int    True        付费服务id
     pay_type    True    int        支付平台: 支付宝==1
     pay_from    int    True        支付方式: APP==APP支付
     price_index    int    True        价格套餐: 价格套餐对应index, 默认：0
     
     */
    ServiceModel *serviceModel;
    for (ServiceModel *model in self.dataArray) {
        if (model.service_type == 2) {
            serviceModel = model;
            _serviceModel = serviceModel;
        }
    }
    if (!serviceModel) {
        return;
    }
    
    if (serviceModel.pricelist.count > index) {
        self.productInfoModel = serviceModel.pricelist[index];
        NSDictionary *para = @{
                               @"pk":[NSNumber numberWithInteger:serviceModel.iD],
                               @"pay_type":@(YES),
                               @"pay_from":@"APP",
                               @"price_index":@(index),
                               };
        [self.view makeToastActivity:CSToastPositionCenter];
        WEAKSELF;
        POSTRequest *request = [POSTRequest requestWithPath:[NSString stringWithFormat:@"/api/virtual-services/%ld/buy/",serviceModel.iD] parameters:para completionHandler:^(InsRequest *request) {
           
            [weakSelf.view hideToastActivity];
            if (request.error) {
                
            }else{
                NSString *orderStr = request.responseObject[@"data"][@"order_string"];
                if ([NSString ins_String:orderStr]) {
                    [weakSelf payOrder:orderStr];
                }
            }
        }];
        [InsNetwork addRequest:request];
    }
    
    
}

#pragma mark 调起支付
- (void)payOrder:(NSString *)orderString{
    // NOTE: 调用支付结果开始支付
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"com.cvmars.xing" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PayBackApp" object:resultDic];
    }];
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
