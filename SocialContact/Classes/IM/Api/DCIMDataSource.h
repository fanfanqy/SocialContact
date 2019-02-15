//
//  DCIMDataSource.h
//  ChildEnd
//
//  Created by dylan on 2017/2/24.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef  DCIM_DataSource
#define DCIM_DataSource [DCIMDataSource sharedSource]

// 融云的好友信息提供者
@interface DCIMDataSource : NSObject <RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCIMGroupUserInfoDataSource, RCIMGroupMemberDataSource>

+ (DCIMDataSource *) sharedSource;

@end
