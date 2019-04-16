//
//  UIImageView+SCImgRequest.h
//  SocialContact
//
//  Created by EDZ on 2019/2/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (SCImgRequest)

- (void)sc_setImgWithUrl:(NSString *)url placeholderImg:(NSString *)imgName;

@end

NS_ASSUME_NONNULL_END
