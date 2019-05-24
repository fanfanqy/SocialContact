//
//  AppConfigModel.h
//  SocialContact
//
//  Created by EDZ on 2019/5/23.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppConfigModel : NSObject

@property(nonatomic,strong)NSString *version;

@property(nonatomic,assign)BOOL isOnlineSwitch;

@property(nonatomic,strong)NSString *kefuid;


@end

NS_ASSUME_NONNULL_END
