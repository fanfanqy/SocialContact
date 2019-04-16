//
//  SCIM.m
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "SCIM.h"
#import "DCIMDataSource.h"
#import "NSObject+HhtCategory.h"

@interface  SCIM() <RCIMConnectionStatusDelegate, RCIMReceiveMessageDelegate>

@property ( nonatomic, assign ) BOOL combinedWithCameraWarning;

@end

@implementation SCIM


#pragma mark -

static SCIM *_dcim = nil;

+ (SCIM *) shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( _dcim == NULL ) {
            _dcim = [[SCIM alloc] init];
        }
    });
    return _dcim;
}

/*!
 IMKit连接状态的的监听器
 
 @param status  SDK与融云服务器的连接状态
 
 @discussion 如果您设置了IMKit消息监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    
}

/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 @param left        还剩余的未接收的消息数，left>=0
 
 @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    
    // 处理新消息到来TabBar的变化
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [AppDelegate sharedDelegate].window.rootViewController;
        if ([vc isKindOfClass:[CYLTabBarController class]]) {
            
            CYLTabBarController *tabBarViewController = (CYLTabBarController *)vc;
            if ( [RCIMClient sharedRCIMClient].getTotalUnreadCount != 0 ) {
                tabBarViewController.tabBar.items[2].badgeValue = [[NSString alloc] initWithFormat:@"%d", [RCIMClient sharedRCIMClient].getTotalUnreadCount];
            } else {
                tabBarViewController.tabBar.items[2].badgeValue = nil;
            }
        }
        
        
    });
    
    if (left == 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshOtherMessageIsVip" object:message.targetId];
        
        if ([self runningInBackground]) {
            [self addLocalNotification];
        }
    }
    
}

#pragma mark -

// 基础配置等
- (void) startWithAppKey: (NSString *)key{
    
    [[RCIM sharedRCIM] initWithAppKey:key];
    // 设置连接状态代理
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    // 设置消息接受代理
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    // 优先使用WebView打开链接
    [RCIM sharedRCIM].embeddedWebViewPreferred = YES;
    // 设置日志类型
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Info;
    // 设置头像尺寸
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    [RCIM sharedRCIM].portraitImageViewCornerRadius = 23;
    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(46, 46);
    // 开启用户信息和群组信息的持久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].globalNavigationBarTintColor = Black;
    // 开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    // 开启前台语音消息推送
    [RCIM sharedRCIM].disableMessageAlertSound = YES;
    // 开启已读回执
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP)];
    // 开启多端未读状态同步
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    // 设置显示未注册的消息
    // 如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = NO;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = NO;
    // 开启消息撤回功能
    [RCIM sharedRCIM].enableMessageRecall = YES;
    
#pragma mark -
    
    // 设置用户信息源和群组信息源
    [RCIM sharedRCIM].userInfoDataSource = DCIM_DataSource;
    // 设置群信息提供
    [RCIM sharedRCIM].groupInfoDataSource = DCIM_DataSource;
    // 群成员数据源
    [RCIM sharedRCIM].groupMemberDataSource = DCIM_DataSource;
    // 群名片
    [RCIM sharedRCIM].groupUserInfoDataSource = DCIM_DataSource;
    
#pragma mark -
    
//    // 注册自定义消息
//    [[RCIM sharedRCIM] registerMessageType:[DCIMPermissionMessage class]];


    [self conn];
}

- (void) conn {
    // 连接融云
    WEAKSELF;
    [[RCIM sharedRCIM] connectWithToken:[SCUserCenter sharedCenter].currentUser.im_token success:^(NSString *userId) {
        NSLog(@"融云登录成功：%@", userId);
        // 申请要通知
        [weakSelf registerRemoteNotification];
        
    } error:^(RCConnectErrorCode status) {
        
    } tokenIncorrect:^{
        
        [weakSelf refreshToken];
    }];
}


- (void)registerRemoteNotification{
    
#pragma mark
    // 开启消息推送，这个较早请求用户的允许状态，可以等到融云token异步获取返回后请求状态。
    if ([[UIApplication sharedApplication]
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

- (void) refreshToken {
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/im/" parameters:nil completionHandler:^(InsRequest *request) {
        
        if (!request.error) {
            [SCUserCenter sharedCenter].currentUser.im_token = request.responseObject[@"data"][@"token"];
            [[SCUserCenter sharedCenter].currentUser updateToDB];
            [weakSelf conn];
        }
        
    }];
    [InsNetwork addRequest:request];
}
@end
