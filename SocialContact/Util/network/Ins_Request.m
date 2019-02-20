//
//  Ins_Request.m
//  AVInsurance
//
//  Created by Dylan on 2016/7/29.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "Ins_Request.h"
#import "ORAppUtil.h"
#import "SecurityUtil.h"
#import <JPUSHService.h>


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface InsRequest ()

@property ( nonatomic, copy ) void (^completeBlock) (InsRequest *);
@property ( nonatomic, strong ) NSDictionary *aesDatas;

/** 加密失败 */
@property (assign, nonatomic) BOOL securityError;

@end

@implementation InsRequest

- (InsMethod)requestMethod {
    // 默认为GET请求
    return InsRM_GET;
}

- (void) cancelTask {
    self->_error = nil;
    self->_responseObject = nil;
    
    if ( self.task ) {
        [self.task cancel];
        self->_task = nil;
    }
}

- (BOOL) canUseCachedDataForRequest: (InsRequest *) request {
    // 默认关闭缓存
    return NO;
}

- (int) timeout {
    // 默认为10秒
    return 10;
}

- (BOOL) SSL {
    // 目前服务器还不支持, 所以别的地方没有做证书的验证支持
    return NO;
}

- (BOOL) CC {
    // 默认需要携带cc
    return YES;
}
- (void) sendGPS {
    // 处理Request的网络请求方式, 服务器仅支持GET/POST
    NSString * requestMethod = nil;
    if ( InsRM_POST == [self requestMethod] ) {
        requestMethod = @"POST";
    }else if ( InsRM_PUT == [self requestMethod] ) {
        requestMethod = @"PUT";
    }else if ( InsRM_DELETE == [self requestMethod] ) {
        requestMethod = @"DELETE";
    } else {
        requestMethod = @"GET";
    }
    
    // 处理服务器标识选择(根地址)
    NSString * requestHost = [self verifiedHostGPS];
    
    // 处理apiPath
    NSMutableString * URLString = [[NSMutableString alloc] initWithString:requestHost];
    if ( [NSString ins_String:_apiPath] ) {
        [self verifiedPath];
        [URLString appendString:_apiPath];
    }
    
    if ( [_apiPath hasPrefix:@"http://"] || [_apiPath hasPrefix:@"https://"] ) {
        URLString = [[NSMutableString alloc] initWithString:_apiPath];
    }
    
    // 处理参数, 加密数据
    [self verifiedParam];
    
    // 使用AFHttpRequestSer生成MutableRequest
    NSError * error = nil;
    
    AFHTTPRequestSerializer * serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest * buildRequest;
    if ( _files.count > 0 ) {
        buildRequest =
        [serializer multipartFormRequestWithMethod:requestMethod URLString:URLString parameters:_parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [_files enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * stop) {
                if ( [obj isKindOfClass:[NSDictionary class]] ) {
                    // 文件的拼接处理
                    NSData * fileData = obj[@"fdata"];
                    NSString * name = obj[@"fname"] ?: @"fileData";
                    NSString * fileName = obj[@"filename"] ?: @"file";
                    NSString * mimeType = obj[@"mime"] ?: @"image/jpg";
                    if ( fileData ) {
                        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
                    }
                }
            }];
        } error:&error];
    } else {
        buildRequest =
        [serializer requestWithMethod:requestMethod URLString:URLString parameters:_parameters error:&error];
    }
    
    // 创建异常, 直接代理抛出错误
    if ( error ) {
        self->_error = error;
        return;
    }
    
    // 白名单过滤, 如果不合法, 抛出异常
//    if ( ![InsHybrid legalRequest:buildRequest] ) {
//        self->_error = INS_NET_WHITELIST_ERROR;
//        return;
//    }
    
    // 拼接Header
    [self buildHeader:buildRequest];
    
    // 网络请求的默认超时时间
    buildRequest.timeoutInterval = [self timeout];
    
    if ( [StartOption sharedInstance].debugger  ) {
        NSMutableString *debugString = [NSMutableString string];
        [debugString appendString:@"--------- Network request begin ---------\n"];
        [debugString appendFormat:@"[%@] %@\n", requestMethod, URLString];
        [debugString appendFormat:@"%@\n", _parameters ?: @""];
        [debugString appendString:@"---------- Network request end ----------\n\n"];
        printf("%s", debugString.UTF8String);
    }
    
    // 开始网络请求
    [self startRequest];
    
    AFURLSessionManager * sessionManager = [InsNetwork sharedInstance].sessionManager;
    @weakify(self);
    
    if ( _files.count > 0 ) {
        _task = [sessionManager
         uploadTaskWithStreamedRequest:buildRequest
         progress:^(NSProgress * uploadProgress) {
             @normalize(self);
             [self progressUpdate:uploadProgress];
         } completionHandler:^(NSURLResponse * response, id responseObject, NSError * error) {
             @normalize(self);
             [self completionWithObj:responseObject error:error response:response];
         }];
    } else {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        _task = [sessionManager dataTaskWithRequest:buildRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            @normalize(self);
            [self completionWithObj:responseObject error:error response:response];
            if ( [StartOption sharedInstance].debugger  ) {
                   CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
                   NSLog(@"->network, %@ - cost: %.2f", buildRequest.URL.path, endTime - startTime);
            }
        }];
        
    }
    
    [_task resume];
}

- (void) send {
    // 处理Request的网络请求方式, 服务器仅支持GET/POST
    NSString * requestMethod = nil;
    if ( InsRM_POST == [self requestMethod] ) {
        requestMethod = @"POST";
    } else {
        requestMethod = @"GET";
    }
    
    // 处理服务器标识选择(根地址)
    NSString * requestHost = [self verifiedHost];
    
    // 处理apiPath
    NSMutableString * URLString = [[NSMutableString alloc] initWithString:requestHost];
    if ( [NSString ins_String:_apiPath] ) {
        [self verifiedPath];
        [URLString appendString:_apiPath];
    }
    
    if ( [_apiPath hasPrefix:@"http://"] || [_apiPath hasPrefix:@"https://"] ) {
        URLString = [[NSMutableString alloc] initWithString:_apiPath];
    }
    
    // 处理参数, 加密数据
    [self verifiedParam];
    
    if (_securityError) {
//        [InsHybrid
//         startWithOptions:nil
//         completeBlock:^(BOOL initSuccess, NSError *error) {
//             if ( initSuccess ) {
//                 [SVProgressHUD showImage:ErrorImage status:@"操作失败，请重试"];
//                 [SVProgressHUD dismissWithDelay:2];
//             } else {
//                 [SVProgressHUD showImage:ErrorImage status:@"操作失败，请重试"];
//                 [SVProgressHUD dismissWithDelay:2];
//             }
//         }];
        return;
    }
    
    // 使用AFHttpRequestSer生成MutableRequest
    NSError * error = nil;
    
    AFHTTPRequestSerializer * serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest * buildRequest;
    if ( _files.count > 0 ) {
        buildRequest =
        [serializer multipartFormRequestWithMethod:requestMethod URLString:URLString parameters:_parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [_files enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * stop) {
                if ( [obj isKindOfClass:[NSDictionary class]] ) {
                    // 文件的拼接处理
                    NSData * fileData = obj[@"fdata"];
                    NSString * name = obj[@"fname"] ?: @"fileData";
                    NSString * fileName = obj[@"filename"] ?: @"file";
                    NSString * mimeType = obj[@"mime"] ?: @"image/jpg";
                    if ( fileData ) {
                        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
                    }
                }
            }];
        } error:&error];
    } else {
        buildRequest =
        [serializer requestWithMethod:requestMethod URLString:URLString parameters:_parameters error:&error];
    }
    
    // 创建异常, 直接代理抛出错误
    if ( error ) {
        self->_error = error;
        return;
    }
    
    // 拼接Header
    [self buildHeader:buildRequest];

    
    // 网络请求的默认超时时间
    buildRequest.timeoutInterval = [self timeout];
    
    if ( [StartOption sharedInstance].debugger  ) {
        NSMutableString *debugString = [NSMutableString string];
        [debugString appendString:@"--------- Network request begin ---------\n"];
        [debugString appendFormat:@"[%@] %@\n", requestMethod, URLString];
        [debugString appendFormat:@"%@\n", _parameters ?: @""];
        [debugString appendString:@"---------- Network request end ----------\n\n"];
        printf("%s", debugString.UTF8String);
    }
    
    [self startRequest];
    
    AFURLSessionManager * sessionManager = [InsNetwork sharedInstance].sessionManager;
    @weakify(self);
    
    if ( _files.count > 0 ) {
        _task =
        [sessionManager
         uploadTaskWithStreamedRequest:buildRequest
         progress:^(NSProgress * uploadProgress) {
             @normalize(self);
             [self progressUpdate:uploadProgress];
         } completionHandler:^(NSURLResponse * response, id responseObject, NSError * error) {
             @normalize(self);
             [self completionWithObj:responseObject error:error response:response];
         }];
    } else {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        _task = [sessionManager dataTaskWithRequest:buildRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            [self completionWithObj:responseObject error:error response:response];
            CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
            NSLog(@"->network, %@ - cost: %.2f", buildRequest.URL.path, endTime - startTime);
        }];
       
    }
    
    [_task resume];
}

//------------------------------------------------------------------------------
// 网络请求结束
//------------------------------------------------------------------------------

- (void) completionWithObj: (id) responseObject error: (NSError *) error response:(NSURLResponse *)response{
    if ( [StartOption sharedInstance].debugger ) {
        NSMutableString *debugString = [NSMutableString string];
        [debugString appendString:@"--------- Response begin ---------\n"];
        [debugString appendFormat:@"[%@] %@\n", self.requestMethod == InsRM_GET ? @"GET": @"POST", self.apiPath];
        if ( responseObject ) {
            [debugString appendFormat:@"%@\n", [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]];
        }
        if ( error ) {
            [debugString appendFormat:@"%@\n", error];
        }
        [debugString appendString:@"---------- Response end ----------\n\n"];
        printf("%s", debugString.UTF8String);
    }
    
    // 移出队列
    [InsNetwork removeRequest:self];
    // 网络级别的错误, 客户端不需要抛出一些没用的问题解释给用户看
    if ( !responseObject ) {
        self->_error = INS_NET_SERVER_ERROR;
        if ( error ) {
            self->_error = error;
        }
        [self failWithError];
        return ;
    }
    
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    
    self->_responseObject = dic;
    
    // 本次操作没有成功, 需要告诉用户原因了 ~, 这里的状态标识意味着： 服务器收到请求并正确处理了请求。
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ( httpResponse.statusCode != 200 ) {
        NSError * err =
        [NSError errorWithDomain:INS_DOMAIN code:dic[@"errorCode"]? [dic[@"status_code"] integerValue] : error.code
                        userInfo:@{NSLocalizedDescriptionKey:dic[@"detail"] ?: INS_ERROR_STR_DEFULT}];
        self->_error = err;
        [self failWithError];
        return ;
    }
    
    if ([self->_apiPath isEqualToString:@"customer/login/"]) {
        NSString *cookie = [httpResponse.allHeaderFields objectForKey:@"Set-Cookie"];
        NSString *csrftoken = [cookie componentsSeparatedByString:@";"][0];
        NSString *token = [csrftoken componentsSeparatedByString:@"="][1];
        [SCUserCenter sharedCenter].XCSRFToken = token;
    }
    
    // 网络请求成功了
    [self requestSuccess];
}

- (void) failWithError {
    if ( [self.delegate respondsToSelector:@selector(requestFailed:)] ) {
        [self.delegate requestFailed:self];
    }
    BLOCK_EXEC(self.completeBlock, self);
    
#pragma mark  Waiting code review 等待查看代码
//    if 逻辑 为什么要增加 ![_apiPath containsaString:@"user/qRCodeLogin.do"] 的条件
    
    if ( self.error.code == 403  ) {
        NSLog(@"下线通知");
//        if ([InsHybrid aesPublickey] && [InsHybrid aesPublickey].length > 0 && [DDUserCenter sharedCenter].currentUser) {
//            [Ins_AlterView showWith:@"下线通知" message:@"您的账号在其他手机客户端登录，请确定是否是你本人登录。" confirm:@"确定" complete:^(BOOL isComplete) {
//                // 去快速登录页面
//                [[AppDelegate app] setRootViewController:INS_NAV([LoginViewController new])];
//                // 重新登录
//                [DDUserCenter sharedCenter].currentUser = nil;
//                // 断开融云连接
//                [[RCIM sharedRCIM] logout];
//                [[RCIM sharedRCIM] clearUserInfoCache];
//                [[RCIM sharedRCIM] clearGroupInfoCache];
//                [[RCIM sharedRCIM] clearGroupUserInfoCache];
//                [LKDBHelper clearTableData:[DDUserInfo class]];
//                [LKDBHelper clearTableData:[DDUser class]];
//                // 删除原来的
//                [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:[[DCIM shared] getLocalCachedCommunityId]];
//                // 删除原来的
//                [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//                    NSLog(@"%@",iAlias);
//                } seq:1];
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocalCachedCommunityId"];
//                // 清除电视视频数据
//                [[YDVideoData sharedVideoData] cleanData];
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"YDVideoTVPlayBindKey"];
//            }];
//            [DDUserCenter sharedCenter].currentUser = nil;
//            // 清除电视视频数据
//            [[YDVideoData sharedVideoData] cleanData];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"YDVideoTVPlayBindKey"];
//            return;
//        }
    }
    
}

- (void) startRequest {
    [self cancelTask];
    
    if ( [self.delegate respondsToSelector:@selector(requestStarted:)] ) {
        [self.delegate requestStarted:self];
    }
}

- (void) requestSuccess {
    if ( [self.delegate respondsToSelector:@selector(requestSucceed:)] ) {
        [self.delegate requestSucceed:self];
    }
    BLOCK_EXEC(self.completeBlock, self);
}

- (void) progressUpdate: (NSProgress *) uploadProgress {
    if ( [self.delegate respondsToSelector:@selector(uploadProgress:)] ) {
        [self.delegate uploadProgress:uploadProgress.fractionCompleted];
    }
}

//------------------------------------------------------------------------------
// 内容规范
//------------------------------------------------------------------------------

- (void) verifiedPath {
    if ( [_apiPath hasPrefix:@"/"] ) {
        _apiPath = [_apiPath substringFromIndex:1];
    }
}

- (NSString *) verifiedHost {
    NSString * requestHost = nil;
    requestHost = APP_HOST;
    
//    if ( ![requestHost hasSuffix:@"/"] ) {
//        requestHost = [requestHost stringByAppendingString:@"/"];
//    }
//
//    if ( ![requestHost hasPrefix:@"http://"] && ![requestHost hasPrefix:@"https://"]) {
//        NSString * scheme;
//
//        if ( [self SSL] ) {
//            scheme = @"https://";
//        } else {
//            scheme = @"http://";
//        }
//        requestHost = [scheme stringByAppendingString:requestHost];
//    }
    
    return requestHost;
}


- (NSString *) verifiedHostGPS {
    return @"";
}

- (void) verifiedParam {
    _securityError = NO;
    if ( _parameters && [_parameters isKindOfClass:[NSDictionary class]] ) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:((NSDictionary *)_parameters )];
        for (NSString * key in dict.allKeys) {
            if ( [[dict objectForKey:key] isKindOfClass:[NSString class]]) {
                
                if ( [NSString ins_String:((NSString *) [dict objectForKey:key])] && [((NSString *) [dict objectForKey:key]) isIncludingEmoji] ) {
                    [dict setObject:[((NSString *) [dict objectForKey:key]) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:key];
                }
            }
        }
        _parameters = dict;
    }
    
    if ( !_parameters ) {
        _parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    

    
    if ( _aesDatas ) {
//        NSString *key = [SecurityUtil aesDecryptUrs:[InsHybrid aesPrivatekey] key:INS_PRIV_KEY];
//        NSString *objStr = [SecurityUtil aesEncryptUrs:_aesDatas.urlEncodedKeyValueString key:key];
//        if (objStr == nil || objStr.length == 0) {
//            // 解密后台返回的key出现了问题，让其重新加载app启动时的接口
//            _securityError = YES;
//            return;
//        }
//        [_parameters setObject:objStr forKey:@"params"];
    }
}

- (void) buildHeader: (NSMutableURLRequest *) request {
//    if ([request valueForHTTPHeaderField:@"Accept-Encoding"] == nil) {
//        [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
//    }
//
//    // 默认添加的头部内容
//    [request setValue:@"0" forHTTPHeaderField:@"paramsPlatform"];
//    [request setValue:INS_APP_VERSION forHTTPHeaderField:@"paramsVersion"];
////    [request setValue:CITY_CODE forHTTPHeaderField:@"cityId"];
//    [request setValue:@"app" forHTTPHeaderField:@"loginType"];
    
//    if ( [InsHybrid aesPublickey] ) {
//        NSLog(@"%@",[InsHybrid aesPublickey]);
//        [request setValue:[InsHybrid aesPublickey] forHTTPHeaderField:@"deviceKey"];
//    }
    
//    if ( [DDUserCenter sharedCenter].currentUser ) {
//        [request setValue:[DDUserCenter sharedCenter].currentUser.token forHTTPHeaderField:@"token"];
//    }
    
//    if ( [_apiPath isEqualToString:API_LAUNCH] ) {
//        NSString *bundeId = [ORAppUtil bundleId];
//        NSString *shortVersion = [ORAppUtil appShortVersion];
//        NSString *uuid = INS_DEVICE_UUID;
//        NSString *deviceType = [ORAppUtil deviceType];
//        NSString *systemName = [ORAppUtil systemName];
//        NSString *systemVersion = [ORAppUtil systemVersion];
//        NSString *resolution = [ORAppUtil resolution];
//        NSString *language = [ORAppUtil currentLanguage];
//        
//        NSDictionary *param =  [NSDictionary dictionaryWithObjectsAndKeys:
//                                bundeId, @"bundleId",
//                                shortVersion, @"sysVersion",
//                                uuid, @"deviceId",
//                                deviceType, @"deviceType",
//                                systemName, @"sysName",
//                                systemVersion, @"sysVersion",
//                                resolution, @"resolution",
//                                language, @"language",
//                                nil];
//        
//        [request setValue:[SecurityUtil aesEncryptUrs:param.urlEncodedKeyValueString key:INS_PRIV_KEY] forHTTPHeaderField:@"params"];
//    }
    
//    NSLog(@"Header = %@", request.allHTTPHeaderFields);
    if ([SCUserCenter sharedCenter].currentUser.XCSRFToken) {
        [request setValue:[SCUserCenter sharedCenter].currentUser.XCSRFToken forHTTPHeaderField:@"X-CSRFToken"];
    }
    [request setValue:Referer forHTTPHeaderField:@"Referer"];
    
    
}

//------------------------------------------------------------------------------
// 初始化方法
//------------------------------------------------------------------------------

+ (instancetype) requestWithPath: (NSString *) apiPath
                      parameters: (NSDictionary *) parameters
                        delegate: (id<InsRequestProtocol>) delegate {
    return [self requestWithPath:apiPath parameters:parameters files:nil delegate:delegate];
}

+ (instancetype) requestWithPath: (NSString *) apiPath
                      parameters: (NSDictionary *) parameters
                           files: (NSArray *) files
                        delegate: (id<InsRequestProtocol>) delegate {
    return [[[self class] alloc] initWithPath:apiPath parameters:parameters files:files delegate:delegate];
}

+ (instancetype) requestWithPath: (NSString *) apiPath
                      parameters: (id) parameters
               completionHandler: (void (^)(InsRequest *)) handler {
    InsRequest * request = [self requestWithPath:apiPath parameters:parameters files:nil delegate:nil];
    request.completeBlock = handler;
    return request;
}

+ (instancetype) requestWithPath: (NSString *) apiPath
                      parameters: (id) parameters
                       aesHeader: (NSDictionary *) datas
               completionHandler: (void (^)(InsRequest *)) handler {
    InsRequest * request = [self requestWithPath:apiPath parameters:parameters files:nil delegate:nil];
    request.completeBlock = handler;
    request.aesDatas = datas;
    return request;
}

- (instancetype) initWithPath: (NSString *) apiPath
                   parameters: (NSDictionary *) parameters
                        files: (NSArray *) files
                     delegate: (id<InsRequestProtocol>) delegate {
    if ( self ) {
        self->_apiPath = apiPath;
        self->_parameters = parameters;
        self->_files = files;
        self->_delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    if ( self.task ) {
        [self.task cancel];
        self->_task = nil;
    }
}

@end
#pragma clang diagnostic pop
