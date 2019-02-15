//
//  FGUploadHTTPRequest.m
//  FGUploadImageManager
//
//  Created by FengLe on 2018/4/2.
//  Copyright © 2018年 FengLe. All rights reserved.
//

#import "FGUploadHTTPRequest.h"

#import "SCUploadManager.h"

@implementation FGUploadHTTPRequest

FGShareSingletonM(Upload);

/**
 自己实现图片上传功能...
 */
- (void)uploadPhotoAlbum:(NSData *)data token:(NSString *)token objectKey:(NSString *)objectKey uploadProgress:(void(^)(float percent))progress completeBlock:(void(^)(BOOL isSuccess,NSString *urlStr))completeBlock
{
    
    [[SCUploadManager manager]putData:data key:objectKey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        NSLog(@"%@", info);
        NSLog(@"%@", resp);
        NSLog(@"key = %@",key);
        if (info.isOK) {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,key];
            if (completeBlock) {
                completeBlock(YES ,urlStr);
            }
        } else {
            if (completeBlock) {
                completeBlock(NO ,nil);
            }
        }
        
    } option:nil];
    
}


@end
