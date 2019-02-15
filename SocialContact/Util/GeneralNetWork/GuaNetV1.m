//
//  GuaNetV1.m
//  GuaGua
//
//  Created by fqy on 2018/5/17.
//  Copyright © 2018年 HuangDeng. All rights reserved.
//

#import "GuaNetV1.h"
static BOOL _openLog;
static GuaNetV1 *_netV1;

@implementation GuaNetV1
+ (GuaNetV1 *)sharedInstance{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_netV1 = [[GuaNetV1 alloc]init];
	});
	return _netV1;
}

-(void)logOpen:(BOOL)open{
	_openLog = open;
}

- (NSMutableURLRequest *)createRequestWithUrl:(NSString *)urlString Parmaters:(NSDictionary *)parmaters Type:(RequestType)type{
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	request.timeoutInterval = 15;
	if (type == kRequestTypeGet){
		[request setHTTPMethod:@"GET"];
	}else if(type == kRequestTypePost){
		[request setHTTPMethod:@"POST"];
		NSError *error;
		NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parmaters options:NSJSONWritingPrettyPrinted error:&error];
		if (error) {
			NSLog(@"%@",error);
		}
		[request setHTTPBody:jsonData];
	}else if (type == kRequestTypePut){
		
	}
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	return request;
}

- (void)startTaskWithUrl:(NSString *)urlStr type:(RequestType)type parmaters:(NSString *)parmaters timeoutInterval:(NSInteger)timeoutInterval success:(NetSuccess)success failure:(NetFailure)failure{
	NSMutableURLRequest *request = [self createRequestWithUrl:urlStr Parmaters:parmaters Type:type];
	request.timeoutInterval = timeoutInterval;
	[self startTaskWithRequest:request successBlockNew:success failureBlockNew:failure];
}


- (void)startTaskWithRequest:(NSMutableURLRequest *)request successBlockNew:(NetSuccess)success failureBlockNew:(NetFailure)failure{
	
	NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (error == nil){
			success(data,response);
		}else{
			failure(error,response);
		}
	}];
	[dataTask resume];
	
}

@end
