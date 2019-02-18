//
//  SCIM.m
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "SCIM.h"
#import "DCIMDataSource.h"

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
    [RCIM sharedRCIM].enablePersistentUserInfoCache = NO;
    // 开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    // 关闭前台语音消息推送 --- 避免视频播放中断和小益语音唤醒冲突
    [RCIM sharedRCIM].disableMessageAlertSound = NO;
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
//    [[RCIM sharedRCIM] registerMessageType:[DCIMStatuMessage class]];
//    [[RCIM sharedRCIM] registerMessageType:[DCIMHiddenMessage class]];
//    [[RCIM sharedRCIM] registerMessageType:[DCIMOrderMessage class]];
//    [[RCIM sharedRCIM] registerMessageType:[DCIMHealthChangeMessage class]];
//    [[RCIM sharedRCIM] registerMessageType:[DCIMCCMessage class]];
//    [[RCIM sharedRCIM] registerMessageType:[DCIMPayMessage class]];
//    [[RCIM sharedRCIM] registerMessageType:[DCIMPermissionChangeMessage class]];
//    [[RCIM sharedRCIM] registerMessageType:[DCIMNotReadingCountMessage class]];
//    [[RCIM sharedRCIM] registerMessageType:[DCIMNotificationMessage class]];
//    [[RCIM sharedRCIM] registerMessageType:[DCIMCameraMessage class]];
//    [[RCIM sharedRCIM] registerMessageType:[DCIMHealthReport class]];
//    [[RCIM sharedRCIM] registerMessageType:[DCIMCallMessage class]];
//    [[RCIM sharedRCIM] registerMessageType:[SystemMessageContentModel class]];
    
    // 清空标记位
//    [self setCombinedWithCameraWarning:NO];
    
#pragma mark -
    
    // 先激活一下RTC 通道
//    RTCAudioSessionConfiguration *webRTCConfig =
//    [RTCAudioSessionConfiguration webRTCConfiguration];
//    webRTCConfig.categoryOptions = webRTCConfig.categoryOptions |
//    AVAudioSessionCategoryOptionDefaultToSpeaker;
//    [RTCAudioSessionConfiguration setWebRTCConfiguration:webRTCConfig];
//    RTCAudioSession *session = [RTCAudioSession sharedInstance];
//    [session addDelegate:self];
//
//    [self configureAudioSession];
//
//    // 配置 WEBRTC
//    ARDSettingsModel *settingsModel = [[ARDSettingsModel alloc] init];
//
//    [[settingsModel availableVideoCodecs] enumerateObjectsUsingBlock:^(RTCVideoCodecInfo *obj, NSUInteger idx, BOOL *stop) {
//        NSLog(@"<RTC> %@: %@", obj.name, obj.parameters);
//
//        if ( [obj.name isEqualToString:@"H264"] && obj.parameters && obj.parameters[@"profile-level-id"] && [@"42e02a" isEqualToString:obj.parameters[@"profile-level-id"]]  ) {
//            [settingsModel storeVideoCodecSetting:obj];
//            *stop = YES;
//        }
//    }];
//
//    [[settingsModel availableVideoResolutions] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"<RTC> %@", obj);
//    }];
//
//    [settingsModel storeVideoResolutionSetting:@"192x144"];
//    [settingsModel storeVideoCodecSetting:[settingsModel availableVideoCodecs][0]];
    
//    // 钟表
//    self.seconds = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeIncrement) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.seconds forMode:NSRunLoopCommonModes];
//    // 秒
//    self.incrementSeconds = 0;
//
    [self conn];
}

- (void) conn {
    // 连接融云
    @weakify(self);
    [[RCIM sharedRCIM] connectWithToken:[SCUserCenter sharedCenter].currentUser.im_token success:^(NSString *userId) {
        NSLog(@"融云登录成功：%@", userId);
        
        
    } error:^(RCConnectErrorCode status) {
//        @normalize(self);
//        [self refreshToken];
    } tokenIncorrect:^{
        @normalize(self);
        [self refreshToken];
    }];
}

- (void) refreshToken {
    @weakify(self);
    GETRequest *request = [GETRequest requestWithPath:@"/im/" parameters:nil completionHandler:^(InsRequest *request) {
        @normalize(self);
        if (!request.error) {
            [SCUserCenter sharedCenter].currentUser.im_token = request.responseObject[@"data"][@"token"];
            [[SCUserCenter sharedCenter].currentUser updateToDB];
            [self conn];
        }
        
    }];
    [InsNetwork addRequest:request];
}
@end
