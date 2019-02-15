//
//  StartOption.h
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InitialOption.h"
#import "Ins_Color.h"

NS_ASSUME_NONNULL_BEGIN

@interface StartOption : NSObject

+ (StartOption *) sharedInstance;



/**
 调试模式是否打开
 */
@property(nonatomic,readonly) BOOL debugger;

@property(nonatomic) InitialOption * option;

/**
 启动App
 */
+ (void) startAppWithOption: (InitialOption *) option;


/**
 设置线上模式
 */
+ (void) setProduct;

/**
 设置线上模式
 */
+ (void) setDebugger;

- (void) applyTheme;


@end

NS_ASSUME_NONNULL_END
