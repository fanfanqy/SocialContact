//
//  Ins_Network.h
//  AVInsurance
//
//  Created by Dylan on 2016/7/28.
//  Copyright © 2016年 Dylan. All rights reserved.
//


#import "Ins_Request.h"
@class InsNetwork;
// Session管理类
@interface InsNetwork : NSObject

INS_SINGLETON(InsNetwork)

/**
 Session Manager
 */
@property (readonly,strong) AFURLSessionManager *sessionManager;

@property (readonly,strong) NSMutableArray * requestQueue;

+ (void) addRequest: (InsRequest *)request;
+ (void) addRequestForGPS: (InsRequest *)request;
+ (void) removeRequest: (InsRequest *)request;

@end
