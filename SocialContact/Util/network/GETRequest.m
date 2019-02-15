//
//  GETRequest.m
//  ChildEnd
//
//  Created by dylan on 2017/2/22.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "GETRequest.h"

@implementation GETRequest

- (InsMethod) requestMethod {
	return InsRM_GET;
}

- (int) timeout {
	return 15;
}

- (BOOL) CC {
	return NO;
}

@end
