//
//  LoadManager.h
//  Express
//
//  Created by EDZ on 2018/12/1.
//  Copyright © 2018年 LeeLom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadManager : NSObject

+(LoadManager *)instance;

- (void)setDicValue:(NSString *)value key:(NSString *)key;

- (NSString *)getDicValueWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
