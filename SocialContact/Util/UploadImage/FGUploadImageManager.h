//
//  FGUploadImageManager.h
//  FGUploadImageManager
//
//  Created by FengLe on 2018/4/2.
//  Copyright © 2018年 FengLe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Completion)(BOOL isSuccess);

@interface FGUploadImageManager : NSObject

@property (copy, nonatomic) Completion completion;

- (void)upLoadImageWithImageArray:(NSArray *)imageArray token:(NSString *)token onceCompletion:(void(^)(NSUInteger index,BOOL isSuccess,NSString *urlStr))onceCompletion objectNameArray:(NSMutableArray *)objectNameArray completion:(Completion)completion;

@end
