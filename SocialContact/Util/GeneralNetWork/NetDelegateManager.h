//
//  NetDelegateManager.h
//  GuaGua
//
//  Created by fqy on 2018/5/17.
//  Copyright © 2018年 HuangDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuaNetV1.h"
/**
 网络请求代理管理类
 */
@interface NetDelegateManager : NSObject<NSURLSessionDelegate>

+(NetDelegateManager *)sharedInstance;

@property (strong, nonatomic)GuaNetV1 *guaNetV1;

@end
