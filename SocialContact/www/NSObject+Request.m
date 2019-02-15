//
//  NSObject+Request.m
//  LMNoteDemo
//
//  Created by EDZ on 2018/12/2.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "NSObject+Request.h"
#import "Const.h"
@implementation NSObject (Request)

+ (void)requestPackageWithCompletion:(RequestCompletion)completion{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:requestUrl];

    
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            completion(data,response,error);
                                            
                                        });
                                        
                                    }];

    // 启动任务
    [task resume];
}
@end
