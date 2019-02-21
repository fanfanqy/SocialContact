//
//  DELETERequest.m
//  SocialContact
//
//  Created by EDZ on 2019/2/20.
//  Copyright © 2019 ha. All rights reserved.
//

#import "DELETERequest.h"

@implementation DELETERequest
- (InsMethod) requestMethod {
    return InsRM_DELETE;
}

- (int) timeout {
    return 15;
}

- (BOOL) CC {
    return NO;
}
@end
