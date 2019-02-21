//
//  Ins_Enviroment.h
//  AVInsurance
//
//  Created by Dylan on 2016/7/29.
//  Copyright © 2016年 Dylan. All rights reserved.
//



@class InsRequest;

typedef enum {
    /**
     GET
     */
    InsRM_GET = 0,
    /**
     POST
     */
    InsRM_POST = 1,
    /**
     PUT
     */
    InsRM_PUT = 2,
    /**
     DELETE
     */
    InsRM_DELETE = 3,
    
} InsMethod;

@protocol InsEnviroment <NSObject>

/**
 网络请求方式
 */
- (InsMethod) requestMethod;

/**
 取消当前网络请求
 */
- (void) cancelTask;

/**
 是否启用缓存
 */
- (BOOL) canUseCachedDataForRequest: (InsRequest *) request;

/**
 默认的超时
 */
- (int) timeout;

/**
 发起网络请求
 */
- (void) send;
/**
 发起定位网络请求
 */
- (void) sendGPS;



/**
 预备以后的HTTPS服务
 */
- (BOOL) SSL;

/**
 是否需要当前用户的cc
 */
- (BOOL) CC;

@end
