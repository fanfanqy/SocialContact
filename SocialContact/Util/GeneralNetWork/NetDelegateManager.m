//
//  NetDelegateManager.m
//  GuaGua
//
//  Created by fqy on 2018/5/17.
//  Copyright © 2018年 HuangDeng. All rights reserved.
//

#import "NetDelegateManager.h"
#import <AssertMacros.h>
static NetDelegateManager *_sharedManager;
@implementation NetDelegateManager

+(NetDelegateManager *)sharedInstance{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [[NetDelegateManager alloc]init];
		_sharedManager.guaNetV1 = [GuaNetV1 sharedInstance];
	});
	return _sharedManager;
}

- (void)setGuaNetV1:(GuaNetV1 *)guaNetV1{
	_guaNetV1 = guaNetV1;
	_guaNetV1.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
	NSLog(@"证书认证");
		//AFNetworking中的处理方式
	NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
	__block NSURLCredential *credential = nil;
		//判断服务器返回的证书是否是服务器信任的
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
		credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
		/*disposition：如何处理证书
		 NSURLSessionAuthChallengePerformDefaultHandling:默认方式处理
		 NSURLSessionAuthChallengeUseCredential：使用指定的证书    NSURLSessionAuthChallengeCancelAuthenticationChallenge：取消请求
		 */
		if (credential) {
			disposition = NSURLSessionAuthChallengeUseCredential;
		} else {
			disposition = NSURLSessionAuthChallengePerformDefaultHandling;
		}
	} else {
		disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
	}
		//安装证书
	if (completionHandler) {
		completionHandler(disposition, credential);
	}
	return [[challenge sender] useCredential: credential forAuthenticationChallenge: challenge];
}

@end
