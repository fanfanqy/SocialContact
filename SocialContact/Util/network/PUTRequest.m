//
//  PUTRequest.m
//  SocialContact
//
//  Created by EDZ on 2019/2/20.
//  Copyright © 2019 ha. All rights reserved.
//

#import "PUTRequest.h"

@implementation PUTRequest
- (InsMethod) requestMethod {
    return InsRM_PUT;
}

- (int) timeout {
    return 15;
}

- (BOOL) CC {
    return NO;
}
@end
