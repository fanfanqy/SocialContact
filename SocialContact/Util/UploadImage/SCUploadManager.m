//
//  SCUploadManager.m
//  SocialContact
//
//  Created by EDZ on 2019/1/23.
//  Copyright © 2019 ha. All rights reserved.
//

#import "SCUploadManager.h"

@implementation SCUploadManager

static SCUploadManager * manager = nil;

+ (SCUploadManager *)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SCUploadManager alloc] init];
    });
    return manager;
}

- (void)uploadDataToQiNiuWithUrl:(NSString *)url fail:(void(^)(NSError *error))failBlock succeed:(void(^)(NSString *token))succeedBlock{
    
    GETRequest *request = [GETRequest requestWithPath:url parameters:nil completionHandler:^(InsRequest *request) {
    
        if (!request.error) {
            if (succeedBlock) {
                NSString *token = request.responseObject[@"data"][@"token"];
                succeedBlock(token);
            }
        }else{
            if (failBlock) {
                failBlock(request.error);
            }
        }
    }];
    [InsNetwork addRequest:request];
    
}
@end
