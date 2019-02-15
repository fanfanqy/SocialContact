//
//  NSObject+Request.h
//  LMNoteDemo
//
//  Created by EDZ on 2018/12/2.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^RequestCompletion)(NSData *data, NSURLResponse *response, NSError *error);

@interface NSObject (Request)
+ (void)requestPackageWithCompletion:(RequestCompletion)completion;
@end

NS_ASSUME_NONNULL_END
