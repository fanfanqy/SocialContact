//
//  DemoMegNetwork.m
//  DemoMegLiveCustomUI
//
//  Created by Megvii on 2018/11/2.
//  Copyright © 2018 Megvii. All rights reserved.
//

#import "DemoMegNetwork.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <math.h>
#import <AFNetworking/AFNetworking.h>

#define kMGFaceIDNetworkHost @"https://openapi.faceid.com"
#define kMGFaceIDNetworkTimeout 30

#define kApiKey @"pEZrk6jsACf6cVL-W3L1AyJC-OA_RG-6"
#define kApiSecret @"qjWK2Jzg46rOuDtz2Ew35zUlyFcmNRUp"

@implementation DemoMegNetwork

static DemoMegNetwork* sing = nil;
static AFHTTPSessionManager* sessionManager = nil;
+ (DemoMegNetwork *)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sing = [[DemoMegNetwork alloc] init];
        NSURL* url = [NSURL URLWithString:kMGFaceIDNetworkHost];
        sessionManager = [[AFHTTPSessionManager manager] initWithBaseURL:url];
    });
    return sing;
}

- (void)getBizTokenWithIdcardName:(NSString *)nameStr idcardNumber:(NSString *)numberStr liveConfig:(NSDictionary *)liveInfo success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock {
    [sessionManager.requestSerializer setValue:@"multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"idcard_name" : nameStr,
                                                                                    @"idcard_number" : numberStr,
                                                                                    @"sign" : [self getFaceIDSignStr],
                                                                                    @"sign_version" : [self getFaceIDSignVersionStr],
                                                                                    @"comparison_type" : @"1" ,
                                                                                    }];
    
    [params addEntriesFromDictionary:liveInfo];
    [sessionManager POST:@"/face/v1.2/sdk/get_biz_token"
              parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
}
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (successBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             successBlock([urlResponse statusCode], (NSDictionary *)responseObject);
                         });
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (failureBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             failureBlock([urlResponse statusCode], error);
                         });
                     }
                 }];
}

- (void)getBizTokenWithUUID:(NSString *)uuidStr imageRef:(UIImage *)imageRef1 liveConfig:(NSDictionary *)liveInfo success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock {
    [sessionManager.requestSerializer setValue:@"multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"uuid" : uuidStr,
                                                                                    @"sign" : [self getFaceIDSignStr],
                                                                                    @"sign_version" : [self getFaceIDSignVersionStr],
                                                                                    @"comparison_type" : @"0" ,
                                                                                    }];
    [params addEntriesFromDictionary:liveInfo];
    
    [sessionManager POST:@"/face/v1.2/sdk/get_biz_token"
              parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    NSData* imageData = UIImageJPEGRepresentation(imageRef1, 0.7f);
    [formData appendPartWithFileData:imageData name:@"image_ref1" fileName:@"image_ref1" mimeType:@"image/jpeg"];
}
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (successBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             successBlock([urlResponse statusCode], (NSDictionary *)responseObject);
                         });
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (failureBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             failureBlock([urlResponse statusCode], error);
                         });
                     }
                 }];
    
}

- (void)getSDKDetectResultWithBizToken:(NSString *)bizTokenStr verbose:(BOOL)isVerbose success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock {
    [sessionManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"sign" : [self getFaceIDSignStr],
                                                                                    @"sign_version" : [self getFaceIDSignVersionStr],
                                                                                    @"biz_token" : bizTokenStr,
                                                                                    @"verbose" : [NSNumber numberWithBool:isVerbose]
                                                                                    }];
    [sessionManager GET:@"/face/v1.2/sdk/get_result"
             parameters:params
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (successBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                            successBlock([urlResponse statusCode], (NSDictionary *)responseObject);
                        });
                    }
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (failureBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                            failureBlock([urlResponse statusCode], error);
                        });
                    }
                }];
}

- (NSString *)getFaceIDSignStr {
    NSAssert(kApiKey.length != 0 && kApiSecret.length != 0, @"Please set `kApiKey` and `kApiSecret`");
    int valid_durtion = 300;
    long int current_time = [[NSDate date] timeIntervalSince1970];
    long int expire_time = current_time + valid_durtion;
    long random = labs(arc4random() % 100000000000);
    NSString* str = [NSString stringWithFormat:@"a=%@&b=%ld&c=%ld&d=%ld", kApiKey, expire_time, current_time, random];
    const char *cKey  = [kApiSecret cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [str cStringUsingEncoding:NSUTF8StringEncoding];
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSData* sign_raw_data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [[NSMutableData alloc] initWithData:HMAC];
    [data appendData:sign_raw_data];
    NSString* signStr = [data base64EncodedStringWithOptions:0];
    return signStr;
}

- (NSString *)getFaceIDSignVersionStr {
    return @"hmac_sha1";
}

@end
