//
//  SCIM.h
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCIM : NSObject

+ (SCIM *) shared;


- (void) startWithAppKey: (NSString *)key;
@end

NS_ASSUME_NONNULL_END
