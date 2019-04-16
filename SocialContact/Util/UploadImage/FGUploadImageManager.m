//
//  FGUploadImageManager.m
//  FGUploadImageManager
//
//  Created by FengLe on 2018/4/2.
//  Copyright © 2018年 FengLe. All rights reserved.
//

#import "FGUploadImageManager.h"
#import "FGUploadHTTPRequest.h"
#import "SCUploadManager.h"

@interface FGUploadImageManager ()

/**
 *  上传失败的数组
 */
@property (nonatomic, strong) NSMutableArray *failedIndexs;
/**
 *  上传图片数据
 */
@property (nonatomic, strong) NSArray *upLoadArray;

@property (strong, nonatomic) NSMutableArray *objectNameArray;
/**
 *  标识的下标
 */
@property (nonatomic, assign) NSUInteger currentIndex;
/**
 某一张图片失败次数
 */
@property (nonatomic, assign) NSInteger onceFailedCount;

@end

//单张图片上传失败最大次数
const static NSInteger kMaxUploadCount = 3;

@implementation FGUploadImageManager

/**
 上传多张图片入口
 */
- (void)upLoadImageWithImageArray:(NSArray *)imageArray token:(NSString *)token onceCompletion:(void(^)(NSUInteger index,BOOL isSuccess,NSString *urlStr))onceCompletion objectNameArray:(NSMutableArray *)objectNameArray completion:(Completion)completion
{
    
//    WEAKSELF;
//
//
//        
    
    [self cleanData];
    //初始化数据
    self.failedIndexs = [NSMutableArray array];
    self.upLoadArray = [NSArray arrayWithArray:imageArray];
    self.objectNameArray = objectNameArray;
    
    //[SVProgressHUD showWithStatus:@"正在上传图片..."];
    [self upLoadPhotosWithToken:token OnceCompletion:^(NSUInteger index, BOOL isSuccess, NSString *urlStr) {
        if (isSuccess) {
            //添加上传成功后的动作...(刷新UI等)
            NSLog(@"成功上传第%zd照片",index);
            
            // 成功的进行记录
            if (onceCompletion) {
                onceCompletion(index,isSuccess,urlStr);
            }
        }
        else {
            [self.failedIndexs addObject:@(index)];
        }
        
    } completeBlock:^{
        
        if (self.failedIndexs.count != 0) {
            completion(NO);
            //[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@上传失败",mutableString]];
        }else{
            //[SVProgressHUD showSuccessWithStatus:@"图片全部上传成功"];
            completion(YES);
        }
        [self cleanData];
    }];
    
    
    
}


/**
 *  递归上传照片
 */
- (void)upLoadPhotosWithToken:(NSString *)token OnceCompletion:(void(^)(NSUInteger index,BOOL isSuccess,NSString *urlStr))onceCompletion completeBlock:(void(^)(void))completeBlock{
    //根据下标,从数组中取出图片,转为二进制数据
    NSData * data = self.upLoadArray[self.currentIndex];
    //发起网络请求
	NSString *objectKey = self.objectNameArray[self.currentIndex];
    
    [[FGUploadHTTPRequest shareUpload] uploadPhotoAlbum:data token:token objectKey:objectKey uploadProgress:^(float percent) {
        //显示上传的进度
        //        [SVProgressHUD showProgress:(CGFloat)(self.currentIndex + percent) / self.upLoadArray.count status:@"正在上传中"];
    } completeBlock:^(BOOL isSuccess, NSString *urlStr) {
        
        //如果上传失败,并且没有超过最大上传次数,重新上传
        if (!isSuccess) {
            self.onceFailedCount++;
            if (self.onceFailedCount < kMaxUploadCount) {
                [self upLoadPhotosWithToken:token OnceCompletion:onceCompletion completeBlock:completeBlock];
                return;
            }
        }
        
        //回调一次的结果
        if (onceCompletion) onceCompletion(self.currentIndex,isSuccess,urlStr);
        
        //清空失败次数
        self.onceFailedCount = 0;
        //记录新的下标index++
        self.currentIndex++;
        
        //判断是否上传完毕
        if (self.currentIndex == self.upLoadArray.count) {
            //如果是已经上传完了,结束
            self.currentIndex = 0 ;
            if (completeBlock) completeBlock();
        }
        else
        {
            //如果还没上传完成,继续下一次上传
            [self upLoadPhotosWithToken:token OnceCompletion:onceCompletion completeBlock:completeBlock];
        }
    }];
}

/**
 清空数据
 */
- (void)cleanData
{
    self.onceFailedCount = 0;
    self.currentIndex = 0;
    
    if (self.upLoadArray) {
        self.upLoadArray = nil;
    }
    if (self.failedIndexs) {
        [self.failedIndexs removeAllObjects];
        self.failedIndexs = nil;
    }
	if (self.objectNameArray) {
		[self.objectNameArray removeAllObjects];
		self.objectNameArray = nil;
	}
}

@end
