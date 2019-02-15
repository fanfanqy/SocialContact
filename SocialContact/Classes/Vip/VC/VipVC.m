//
//  VipVC.m
//  SocialContact
//
//  Created by EDZ on 2019/2/13.
//  Copyright © 2019 ha. All rights reserved.
//

#import "VipVC.h"
#import "ServiceModel.h"

@interface VipVC ()

INS_P_STRONG(NSMutableArray *, dataArray);

// 当前充值的 ProductInfoModel
INS_P_STRONG(ProductInfoModel *, productInfoModel);

INS_P_STRONG(ServiceModel *, serviceModel);

@end

@implementation VipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray = [NSMutableArray array];
    [self serviceProduct];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PayBackApp) name:@"PayBackApp" object:nil];
}

- (void)PayBackApp{
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.labelTitle.textColor = [UIColor redColor];
//    alert.attributedFormatBlock = ^NSAttributedString* (NSString *value)
//    {
//        NSMutableAttributedString *subTitle = [[NSMutableAttributedString alloc]initWithString:value];
//        
//        
//        [subTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:subTitle.rangeOfAll];
//        
//      
//        
//        return subTitle;
//    };
    
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
            
                [weakSelf.dataArray removeAllObjects];
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ServiceModel *productModel = [ServiceModel modelWithDictionary:obj];
                    [weakSelf.dataArray addObject:productModel];
                    
                }];
            }
        }
        
    }];
    
    [InsNetwork addRequest:request];
}

- (IBAction)vip1Clicked:(id)sender {
    
    [self buy:0];
    
}

- (IBAction)vip2Clicked:(id)sender {
    
    [self buy:1];
}

- (IBAction)vip3Clicked:(id)sender {
    
    [self buy:2];
}


- (void)buy:(NSInteger)index{
    
    /*
    购买服务
    
    Request
    
LoginRequired: False
Method: POST
URL:  /api/virtual-services/<int:pk>/buy/
     
     pk    int    True        付费服务id
     pay_type    True    int        支付平台: 支付宝==1
     pay_from    int    True        支付方式: APP==APP支付
     price_index    int    True        价格套餐: 价格套餐对应index, 默认：0
     
     */
    ServiceModel *serviceModel = self.dataArray[0];
    _serviceModel = serviceModel;
    
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
