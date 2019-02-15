//
//  MomentImageModel.h
//  SocialContact
//
//  Created by EDZ on 2019/1/12.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MomentImageModel : NSObject
/*
 {
 "url": "https://www.djangoproject.com/s/img/small-fundraising-heart.d255f6e934e5.png",
 "h": 1280,
 "w": 720
 },
 */
@property(nonatomic ,strong ) NSString *url;

@property(nonatomic ,assign ) CGFloat h;

@property(nonatomic ,assign ) CGFloat w;

@end

NS_ASSUME_NONNULL_END
