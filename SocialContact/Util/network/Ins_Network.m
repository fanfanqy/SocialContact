//
//  Ins_Network.m
//  AVInsurance
//
//  Created by Dylan on 2016/7/28.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "Ins_Network.h"

@interface InsNetwork ()

@end

@implementation InsNetwork

DEF_SINGLETON_AUTOLOAD(InsNetwork)

- (instancetype) init {
	self = [super init];
	if ( self ) {
//		[NSURLSessionConfiguration backgroundSessionConfiguration:@"app.framework.ins"];
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
		configuration.URLCache = nil;
		configuration.timeoutIntervalForRequest = 10.0;
		configuration.URLCredentialStorage = nil;
		_sessionManager = [[AFURLSessionManager alloc]
											 initWithSessionConfiguration:configuration];
		_sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
		configuration = nil;

		_requestQueue = [NSMutableArray arrayWithCapacity:1];
	}
	return self;
}

/*
 维持生命周期到网络请求结束
 */

+ (void) addRequest: (InsRequest *)request {
	if ( request ) {
		[[InsNetwork sharedInstance].requestQueue addObject:request];
		[request send];
	}
}

+ (void) addRequestForGPS: (InsRequest *)request{
    if ( request ) {
        [[InsNetwork sharedInstance].requestQueue addObject:request];
        [request sendGPS];
    }
}

+ (void) removeRequest: (InsRequest *)request {
	[[InsNetwork sharedInstance].requestQueue removeObject:request];
}

@end
