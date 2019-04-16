//
//  SCUserCenter.h
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUser.h"

NS_ASSUME_NONNULL_BEGIN
@interface SCUserCenter : NSObject

@property ( nonatomic, strong ) NSMutableDictionary *dictionary;

+ (SCUserCenter *) sharedCenter;

INS_P_STRONG(NSString *, XCSRFToken);
/**
 The current user
 */
@property ( nonatomic, strong ) SCUser *currentUser;

#pragma mark -
- (NSMutableArray *)getUsers;
- (void)saveUser:(NSString *)user;
- (void)removeUser:(NSString *)user;


/**
 别人的信息

 @param complationBlock <#complationBlock description#>
 */
+ (void)getSelfInformationAndUpdateDBWithUserId:(NSInteger)userId completion: (void(^)(id responseObj,BOOL succeed, NSError *error)) complationBlock;

//获取某用户基本信息
//
//Request
//
//LoginRequired: True
//Method: GET
//URL:  /customer/<int:pk>/
//Headers：
//Params:
//name    type    require    example    desc
//pk    int    True        用户id
@end

NS_ASSUME_NONNULL_END
