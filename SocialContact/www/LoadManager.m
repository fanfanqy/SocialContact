//
//  LoadManager.m
//  Express
//
//  Created by EDZ on 2018/12/1.
//  Copyright © 2018年 LeeLom. All rights reserved.
//

#import "LoadManager.h"

static LoadManager *_manager;
@implementation LoadManager

+(LoadManager *)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [LoadManager new];
    });
    return _manager;
}

- (void)setDicValue:(NSString *)value key:(NSString *)key{
    [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
}

- (NSString *)getDicValueWithKey:(NSString *)key{
    NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    return value;
}
@end
