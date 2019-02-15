//
//  RegisteRequest.m
//  ChildEnd
//
//  Created by dylan on 2017/2/20.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "POSTRequest.h"

@implementation POSTRequest

- (InsMethod) requestMethod {
	return InsRM_POST;
}

- (int) timeout {
	return 15;
}

- (BOOL) CC {
	return NO;
}

@end
