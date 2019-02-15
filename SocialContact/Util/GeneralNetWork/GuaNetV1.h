//
//  GuaNetV1.h
//  GuaGua
//
//  Created by fqy on 2018/5/17.
//  Copyright © 2018年 HuangDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
	kRequestTypePost,
	kRequestTypeGet,
	kRequestTypePut,
}RequestType;

@interface GuaNetV1 : NSObject

+ (GuaNetV1 *)sharedInstance;

@property (strong, nonatomic)NSURLSession *session;

/**
 2.0以后使用此回调
 */
	// New 网络成功的回调
typedef void (^NetSuccess)(NSData * data,NSURLResponse *response);
	//网络失败的回调
typedef void (^NetFailure)(NSError * error,NSURLResponse *response);

- (void)logOpen:(BOOL)open;

/**
 自定义请求时间，对于请求时间较长的
 */
- (void)startTaskWithUrl:(NSString *)urlStr type:(RequestType)type parmaters:(NSDictionary *)parmaters timeoutInterval:(NSInteger)timeoutInterval success:(NetSuccess)success failure:(NetFailure)failure;

/**
 自定义请求
 */
- (void)startTaskWithRequest:(NSMutableURLRequest *)request successBlockNew:(NetSuccess)success failureBlockNew:(NetFailure)failure;

@end
