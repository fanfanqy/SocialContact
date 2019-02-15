//
//  SCUserCenter.m
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "SCUserCenter.h"

@implementation SCUserCenter



#pragma mark -

static SCUserCenter *CENTER = nil;

+ (SCUserCenter *) sharedCenter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( CENTER == NULL ) {
            CENTER = [[SCUserCenter alloc] init];
            CENTER.currentUser = [SCUser searchSingleWithWhere:nil orderBy:nil];
        }
    });
    
    return CENTER;
}

- (void)setCurrentUser:(SCUser *)currentUser {
    _currentUser = currentUser;
    
    // Remove local user
    [[SCUser getUsingLKDBHelper] dropTableWithClass:[SCUser class]];
    
    if ( _currentUser ) {
        // Save current user to Database
        [_currentUser saveToDB];
    }
}

- (NSMutableDictionary *)dictionary {
    if ( !_dictionary ) {
        _dictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _dictionary;
}

#pragma mark -
// 获取
- (NSMutableArray *)getUsers {
    NSMutableArray *list = [NSMutableArray array];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userList"];
    if (data != nil) {
        [list addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
    return list;
}

// 添加
- (void)saveUser:(NSString *)user {
    NSMutableArray *list = [self getUsers];
    if ([list containsObject:user]) {
        return;
    }
    if (user == nil) {
        return;
    }
    [list addObject:user];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:list];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userList"];
}

// 减
- (void)removeUser:(NSString *)user {
    NSMutableArray *list = [self getUsers];
    [list removeObject:user];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:list];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userList"];
}

+ (void) getOtherUserInformationWithUserId:(NSInteger)userId completion: (void(^)(id responseObj, BOOL succeed, NSError *error)) complationBlock{
    
    //[SCUserCenter sharedCenter].currentUser.userInfo.account] 自己的
    GETRequest *request = [GETRequest  requestWithPath:[NSString stringWithFormat:@"customer/%ld/",userId] parameters:nil completionHandler:^(InsRequest *requset) {
        
        if (!request.error) {
            SCUserInfo *userInfo = [SCUserInfo modelWithDictionary:requset.responseObject[@"data"]];
            [userInfo updateToDB];
            
            [SCUserCenter sharedCenter].currentUser.XCSRFToken = [SCUserCenter sharedCenter].XCSRFToken;
            [SCUserCenter sharedCenter].currentUser.userInfo = userInfo;
            [[SCUserCenter sharedCenter].currentUser updateToDB];
            
            RCUserInfo *rcUserInfo = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",[SCUserCenter sharedCenter].currentUser.user_id] name:[SCUserCenter sharedCenter].currentUser.name portrait:userInfo.avatar_url] ;
            [rcUserInfo updateToDB];
            [RCIM sharedRCIM].currentUserInfo = rcUserInfo;
            [[RCIM sharedRCIM] refreshUserInfoCache:rcUserInfo withUserId:rcUserInfo.userId];
            if (complationBlock) {
                complationBlock(request.responseObject,YES,nil);
            }
            
        }else{
            if (complationBlock) {
                complationBlock(request.responseObject,NO,nil);
            }
        }
        
    }];
    [InsNetwork addRequest:request];
}
@end
