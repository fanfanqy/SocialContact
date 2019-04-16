//
//  XiaXiaYueMessageContent.m
//  SocialContact
//
//  Created by EDZ on 2019/4/1.
//  Copyright © 2019 ha. All rights reserved.
//

#import "XiaShangYueMessageContent.h"

@implementation XiaShangYueMessageContent

- (instancetype)init {
    self = [super init];
    if ( self  ) {
        NSDate *datenow = [NSDate date];
        self.timestamp = [datenow timeIntervalSince1970];
        NSLog(@" self.timestamp==%ld", (long)self.timestamp);
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if ( self ) {
        self.avatar_url = [aDecoder decodeObjectForKey:@"roomId"];
        self.name = [aDecoder decodeObjectForKey:@"roomId"];
        self.timestamp = [aDecoder decodeIntegerForKey:@"timestamp"];
        self.iD = [aDecoder decodeIntegerForKey:@"timestamp"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.avatar_url forKey:@"avatar_url"];
    [aCoder encodeInteger:self.iD forKey:@"iD"];
    [aCoder encodeInteger:self.timestamp forKey:@"timestamp"];
}

// 编码
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.name forKey:@"name"];
    [dataDict setObject:self.avatar_url forKey:@"avatar_url"];
   [dataDict setObject:@(self.iD) forKey:@"iD"];
    [dataDict setObject:@(self.timestamp) forKey:@"timestamp"];
    
    
    if ( self.senderUserInfo ) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name
                 forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri
                 forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId
                 forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

- (void)decodeWithData:(NSData *)data {
    
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:kNilOptions
                                          error:&error];
        
        if (dictionary) {
            self.name = dictionary[@"callToId"] ?: @"";
            self.avatar_url = dictionary[@"avatar_url"] ?: @"";
            self.timestamp = [dictionary[@"timestamp"] integerValue];
            self.iD = [dictionary[@"iD"] integerValue];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

// 自定义内容标识
+ (NSString *)getObjectName {
    return @"RC:XiaShangYueMsg";
}

// 在本地存储不记录未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_ISPERSISTED;
}

// 会话列表展示的描述信息
- (NSString *)conversationDigest {
    return [NSString stringWithFormat:@"[%@]发来线上约会邀请",self.name];
}

@end
