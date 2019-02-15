//
//  SCUploadManager.h
//  SocialContact
//
//  Created by EDZ on 2019/1/23.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNUploadManager.h"


NS_ASSUME_NONNULL_BEGIN

@interface SCUploadManager : QNUploadManager

+ (SCUploadManager *)manager;

- (void)uploadDataToQiNiuWithUrl:(NSString *)url fail:(void(^)(NSError *error))failBlock succeed:(void(^)(NSString *token))succeedBlock;

@end

NS_ASSUME_NONNULL_END
