//
//  UIImageView+SCImgRequest.m
//  SocialContact
//
//  Created by EDZ on 2019/2/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import "UIImageView+SCImgRequest.h"

@implementation UIImageView (SCImgRequest)

- (void)sc_setImgWithUrl:(NSString *)url placeholderImg:(NSString *)imgName{
    
    if ([NSString ins_String:url]) {
        if (![url containsString:@"http"]) {
            url = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,url];
        }
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imgName]];
    }else{
        self.image = [UIImage imageNamed:imgName];
    }
}
@end
