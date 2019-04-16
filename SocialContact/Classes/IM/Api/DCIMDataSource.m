//
//  DCIMDataSource.m
//  ChildEnd
//
//  Created by dylan on 2017/2/24.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "DCIMDataSource.h"
#import "TopicModel.h"

@implementation DCIMDataSource

static DCIMDataSource * _SOURCES;

+ (DCIMDataSource *) sharedSource {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if ( _SOURCES == NULL ) {
			_SOURCES = [[DCIMDataSource alloc] init];
		}
	});

	return _SOURCES;
}

#pragma mark -

/*!
 获取群组信息
 */
- (void)getGroupInfoWithGroupId:(NSString *)groupId
										 completion:(void (^)(RCGroup *groupInfo))completion {
	// 查看数据库是否存在该群信息
	RCGroup *groupInfo = [RCGroup searchSingleWithWhere:@{@"groupId": groupId} orderBy:nil];
	if ( groupInfo ) {
		completion(groupInfo);
	} else {
//        /moments/topic/<int:pk>/
        // 数据库中查询不到，从网络请求中读取
        GETRequest *request = [GETRequest  requestWithPath:[NSString stringWithFormat:@"/moments/topic/%@/",groupId] parameters:nil completionHandler:^(InsRequest *request) {
            
            if (!request.error) {
                TopicModel *topicModel = [TopicModel modelWithDictionary:request.responseObject[@"data"]];
                
                RCGroup *groupInfo = [[RCGroup alloc]initWithGroupId:[NSString stringWithFormat:@"%ld",topicModel.iD] groupName:topicModel.name portraitUri:topicModel.logo_url];
                [groupInfo updateToDB];
                completion(groupInfo);
            }
            
        }];
        [InsNetwork addRequest:request];
        
	}
}

/*!
 获取用户在群组中的群名片信息
 */
- (void)getUserInfoWithUserId:(NSString *)userId
											inGroup:(NSString *)groupId
									 completion:(void (^)(RCUserInfo *userInfo))completion {
//    DCIMGroupCard *card = [DCIMGroupCard searchSingleWithWhere:@{@"rcGroupId": groupId, @"userId": userId} orderBy:nil];
//    if ( card ) {
//        DCIMContact *contact = [DCIMContact searchSingleWithWhere:@{@"uid": userId} orderBy:nil];
//        RCUserInfo *userInfo = card.RCUser;
//        if ( contact && contact.isFriend == YES && ![contact.remark isEqualToString:contact.name] ) {
//
//            if (contact.remark&&contact.remark.length>0) {
//                userInfo.name  = contact.remark;
//            }else{
//                userInfo.name  = contact.name;
//            }
//        }
//
//        completion(userInfo);
//    } else {
//        [DCIMAPI searchGroupCard:groupId uid:userId competeBlock:^(BOOL succeed, NSError *error, DCIMGroupCard *card) {
//            if ( card ) {
//                DCIMContact *contact = [DCIMContact searchSingleWithWhere:@{@"uid": card.userId} orderBy:nil];
//                RCUserInfo *userInfo = card.RCUser;
//                if ( contact && contact.isFriend == YES && ![contact.remark isEqualToString:contact.name] ) {
//
//                    if (contact.remark&&contact.remark.length>0) {
//                        userInfo.name  = contact.remark;
//                    }else{
//                        userInfo.name  = contact.name;
//                    }
//
//                }
//                completion(userInfo);
//            } else {
//                completion(nil);
//            }
//        }];
//    }
}

/*!
 获取当前群组成员列表的回调（需要实现用户信息提供者 RCIMUserInfoDataSource）
 */
- (void)getAllMembersOfGroup:(NSString *)groupId
											result:(void (^)(NSArray<NSString *> *userIdList))resultBlock {
//    ILog(@"call this method");
//    [DCIMAPI getGroupCompletedInfo:groupId competeBlock:^(BOOL succeed, NSError *error, DCIMGroup *group) {
//        if ( succeed ) {
//            [group updateToDB];
//
//            NSMutableArray *memberArray = [NSMutableArray arrayWithCapacity:1];
//            [group.userMsgList enumerateObjectsUsingBlock:^(DCIMGroupMember *contact, NSUInteger idx, BOOL * _Nonnull stop) {
//                [memberArray addObject:contact.uid];
//            }];
//            resultBlock(memberArray);
//        } else {
//            resultBlock(nil);
//        }
//    }];
}

#pragma mark -

/*!
 获取用户信息
 */
- (void)getUserInfoWithUserId:(NSString *)userId
									 completion:(void (^)(RCUserInfo *userInfo))completion {
//     /customer/<int:pk>/
    // 从数据库中搜索该条数据
    RCUserInfo *userInfo = [RCUserInfo searchSingleWithWhere:@{@"userId": userId} orderBy:nil];
    if ( userInfo ) {
        completion(userInfo);
    } else {
        
        // 数据库中查询不到，从网络请求中读取
        GETRequest *request = [GETRequest  requestWithPath:[NSString stringWithFormat:@"customer/%@/",userId] parameters:nil completionHandler:^(InsRequest *request) {
            
            if (!request.error) {
                SCUserInfo *userInfo = [SCUserInfo modelWithDictionary:request.responseObject[@"data"]];
                [userInfo updateToDB];
                
                RCUserInfo *rcUserInfo = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",userInfo.user_id] name:userInfo.name portrait:userInfo.avatar_url] ;
                [rcUserInfo updateToDB];
                [[RCIM sharedRCIM] refreshUserInfoCache:rcUserInfo withUserId:rcUserInfo.userId];
                completion(rcUserInfo);
            }
            
        }];
        [InsNetwork addRequest:request];
    }
}

@end
