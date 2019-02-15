//
//  Ins_RequestProtocol.h
//  AVInsurance
//
//  Created by Dylan on 2016/7/29.
//  Copyright © 2016年 Dylan. All rights reserved.
//



@class InsRequest;

@protocol InsRequestProtocol <NSObject>

@optional

/**
 网络请求开始
 */
- (void) requestStarted: (InsRequest *) request;

/**
 上传进度
 */
- (void) uploadProgress: (double) progress;

@required

/**
 网络请求成功
 */
- (void) requestSucceed: (InsRequest *) request;

/**
 网络请求失败
 */
- (void) requestFailed: (InsRequest *) request;

@end
