//
//  XiaXiaYueMessageContent.h
//  SocialContact
//
//  Created by EDZ on 2019/4/1.
//  Copyright © 2019 ha. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

NS_ASSUME_NONNULL_BEGIN

/*
 线上约，自定义内容，RCMessageContent
 */
@interface XiaShangYueMessageContent : RCMessageContent

//我的用户 ID
@property ( nonatomic ) NSInteger iD;

// 线上约ID
@property ( nonatomic ) NSInteger xianXiaYueId;

//我的 昵称
@property ( nonatomic ) NSString *name;

//我的 头像
@property ( nonatomic ) NSString *avatar_url;

//发出邀请的时间戳，10位
@property ( nonatomic ) NSInteger timestamp;

@end

NS_ASSUME_NONNULL_END
