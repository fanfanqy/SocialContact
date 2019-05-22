//
//  DemoMegNetwork.h
//  DemoMegLiveCustomUI
//
//  Created by Megvii on 2018/11/2.
//  Copyright © 2018 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RequestSuccess)(NSInteger statusCode, NSDictionary* responseObject);
typedef void(^RequestFailure)(NSInteger statusCode, NSError* error);

@interface DemoMegNetwork : NSObject

+ (DemoMegNetwork *)singleton;

//  获取有源对比biz_token
- (void)getBizTokenWithIdcardName:(NSString *)nameStr idcardNumber:(NSString *)numberStr liveConfig:(NSDictionary *)liveInfo success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock;

//  获取无源对比biz_token
- (void)getBizTokenWithUUID:(NSString *)uuidStr imageRef:(UIImage *)imageRef1 liveConfig:(NSDictionary *)liveInfo success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock;

//  获取活体验证结果
- (void)getSDKDetectResultWithBizToken:(NSString *)bizTokenStr verbose:(BOOL)isVerbose success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock;

@end

NS_ASSUME_NONNULL_END
