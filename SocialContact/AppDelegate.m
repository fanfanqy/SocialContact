//
//  AppDelegate.m
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "AppDelegate.h"

#import "WXApiManager.h"

#import "AXWebViewController.h"
#import "LoadManager.h"

#import "MainTabBarController.h"
#import "LoginViewController.h"
#import "GeRenZiLiaoVC.h"
#import "AuthenticationVC.h"

// 引入 JPush 功能所需头文件
#import <JPUSHService.h>
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif




@interface AppDelegate ()<JPUSHRegisterDelegate,UITabBarControllerDelegate>

@property(nonatomic,strong)MainTabBarController *tabBarController;

@property (nonatomic, weak) UIButton *selectedCover;

@property(strong, nonatomic)NSTimer *monitorDateChageTimer;//定时刷新日历
@property(assign, nonatomic)UIBackgroundTaskIdentifier backTaskId;//后台任务

@end

@implementation AppDelegate

#define RANDOM_COLOR [UIColor colorWithHue: (arc4random() % 256 / 256.0) saturation:((arc4random()% 128 / 256.0 ) + 0.5) brightness:(( arc4random() % 128 / 256.0 ) + 0.5) alpha:1]

+(AppDelegate *)sharedDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication]delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //向微信注册
    [WXApi registerApp:kWeChatAppId];
    
//    //Required
//    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
//    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        // 可以添加自定义 categories
//        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
//        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
//    }
//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//
//    // Required
//    // init Push
//    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
//    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
//    [JPUSHService setupWithOption:launchOptions appKey:@"3d20691d52cbc75875d16bd9" channel:nil apsForProduction:YES];
    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 自定义的全局样式渲染
    [SCCommonUIDefine renderGlobalAppearances];

    // 设置主窗口,并设置根控制器
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    [self SDWebImageConfig];
    [self  thirdLibraryApplication:application didFinishLaunchingWithOptions:launchOptions otherOptions:nil];
    
    [self configRootVC];
    
    return YES;
}

- (void)SDWebImageConfig{
    //关闭预绘制
    [[SDImageCache sharedImageCache].config setShouldDecompressImages:NO];
    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [[SDImageCache sharedImageCache] setMaxMemoryCost:10*1024*1024];//10m
    [[SDImageCache sharedImageCache] setMaxMemoryCountLimit:10];
    
}


- (void)requestBottleCharts{
    
    self.isBottleCharts = [NSMutableArray array];
    
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/api/chatrecord/record_list/" parameters:nil completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            
        }else{
//            record_list
            weakSelf.isBottleCharts = request.responseObject[@"data"][@"record_list"];
            
        }
        
    }];
    [InsNetwork addRequest:request];
    
}

- (void)requestAppConfig{
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/appconfig/" parameters:nil completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            weakSelf.appConfigModel = [AppConfigModel new];
            weakSelf.appConfigModel.isOnlineSwitch = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf onceAgain];
            });
            
        }else{
            weakSelf.appConfigModel = [AppConfigModel modelWithDictionary:request.responseObject];
        }
    }];
    [InsNetwork addRequest:request];
    
}

- (void)onceAgain{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self requestAppConfig];
    });
}


- (void)configRootVC{
    
    [self requestAppConfig];
    
    /**
     ios 11适配
     */
    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
    }
    
    if ([SCUserCenter sharedCenter].currentUser) {
        
        // 头像审核中，返回是空的
        if (![Help checkFillAllInfo:[SCUserCenter sharedCenter].currentUser.userInfo ignoreAvatar:YES] ) {
            
            [SVProgressHUD showImage:AlertErrorImage status:@"请先完善个人信息"];
            [SVProgressHUD dismissWithDelay:1.5];
            
            GeRenZiLiaoVC *gerenZiLiaoVC = [GeRenZiLiaoVC new];
            gerenZiLiaoVC.vcType = 1;
            gerenZiLiaoVC.title = @"完善个人信息";
            gerenZiLiaoVC.userModel = [SCUserCenter sharedCenter].currentUser.userInfo;
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:gerenZiLiaoVC];
            [self.window setRootViewController:nav];
            [self.window makeKeyAndVisible];
            
        }
//        else if (![SCUserCenter sharedCenter].currentUser.userInfo.is_idcard_verified){
//            
//            [SVProgressHUD showImage:AlertErrorImage status:@"请先进行实名认证"];
//            [SVProgressHUD dismissWithDelay:1.5];
//            
//            AuthenticationVC *vc = [[AuthenticationVC alloc]initWithNibName:@"AuthenticationVC" bundle:nil];
//            vc.userModel = [SCUserCenter sharedCenter].currentUser.userInfo;
//            vc.type = 1;
//            
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//            [self.window setRootViewController:nav];
//            [self.window makeKeyAndVisible];
//            
//        }
        else{
            
            MainTabBarController *tabBarController = [[MainTabBarController alloc] init];
            [tabBarController hideTabBadgeBackgroundSeparator];
            tabBarController.delegate = self;
            self.tabBarController = tabBarController;
            [self.window setRootViewController:tabBarController];
            [self.window makeKeyAndVisible];
            // 连接融云
            [[SCIM shared] startWithAppKey:kRongYunKey];
            
            [self requestBottleCharts];
            [self requestAppConfig];
            
            [self mapManagerConfig];
        }
        
    }else{
        LoginViewController *vc = [[LoginViewController alloc]init];
        CYLBaseNavigationController *nav = [[CYLBaseNavigationController alloc]initWithRootViewController:vc];
        [self.window setRootViewController:nav];
        [self.window makeKeyAndVisible];
        
    }
}

- (void)setSelectedCoverShow:(BOOL)show {
    if (_selectedCover.superview && show) {
        [self addOnceScaleAnimationOnView:_selectedCover];
        return;
    }
    UIControl *selectedTabButton = [[self cyl_tabBarController].viewControllers[0].tabBarItem cyl_tabButton];
    if (show && !_selectedCover.superview) {
        UIButton *selectedCover = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"home_select_cover"];
        [selectedCover setImage:image forState:UIControlStateNormal];
        selectedCover.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        if (selectedTabButton) {
            selectedCover.center = CGPointMake(selectedTabButton.cyl_tabImageView.center.x, selectedTabButton.center.y);
            [self addOnceScaleAnimationOnView:selectedCover];
            [selectedTabButton addSubview:(_selectedCover = selectedCover)];
            [selectedTabButton bringSubviewToFront:_selectedCover];
        }
    } else if (_selectedCover.superview){
        [_selectedCover removeFromSuperview];
        _selectedCover = nil;
    }
    if (selectedTabButton) {
        selectedTabButton.cyl_tabLabel.hidden =
        (show );
        selectedTabButton.cyl_tabImageView.hidden = (show);
    }
}

//缩放动画
- (void)addOnceScaleAnimationOnView:(UIView *)animationView {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@0.5, @1.0];
    animation.duration = 0.1;
    //    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

- (void)customizeInterfaceWithTabBarController:(CYLTabBarController *)tabBarController {
    //设置导航栏
    [self setUpNavigationBarAppearance];
    
    [tabBarController hideTabBadgeBackgroundSeparator];
    //添加小红点
    UIViewController *viewController = tabBarController.viewControllers[0];
    UIView *tabBadgePointView0 = [UIView cyl_tabBadgePointViewWithClolor:RANDOM_COLOR radius:4.5];
    [viewController.tabBarItem.cyl_tabButton cyl_setTabBadgePointView:tabBadgePointView0];
    [viewController cyl_showTabBadgePoint];
    
    UIView *tabBadgePointView1 = [UIView cyl_tabBadgePointViewWithClolor:RANDOM_COLOR radius:4.5];
    @try {
        [tabBarController.viewControllers[1] cyl_setTabBadgePointView:tabBadgePointView1];
        [tabBarController.viewControllers[1] cyl_showTabBadgePoint];
        
        UIView *tabBadgePointView2 = [UIView cyl_tabBadgePointViewWithClolor:RANDOM_COLOR radius:4.5];
        [tabBarController.viewControllers[2] cyl_setTabBadgePointView:tabBadgePointView2];
        [tabBarController.viewControllers[2] cyl_showTabBadgePoint];
        
        [tabBarController.viewControllers[3] cyl_showTabBadgePoint];
        
        //添加提示动画，引导用户点击
        [self addScaleAnimationOnView:tabBarController.viewControllers[3].cyl_tabButton.cyl_tabImageView repeatCount:20];
    } @catch (NSException *exception) {}
    
}

/**
 *  设置navigationBar样式
 */
- (void)setUpNavigationBarAppearance {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName : [[UIFont systemFontOfSize:14]fontWithBold],
                           NSForegroundColorAttributeName : Font_color333,
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        textAttributes = @{
                           UITextAttributeFont : [[UIFont systemFontOfSize:18]fontWithBold],
                           UITextAttributeTextColor : Font_color333,
                           UITextAttributeTextShadowColor : [UIColor clearColor],
                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    
}


#pragma mark - delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    
    if ([control cyl_isTabButton]) {
        //更改红标状态
//        if ([[self cyl_tabBarController].selectedViewController cyl_isShowTabBadgePoint]) {
//            [[self cyl_tabBarController].selectedViewController cyl_removeTabBadgePoint];
//        } else {
//            [[self cyl_tabBarController].selectedViewController cyl_showTabBadgePoint];
//        }
        
        animationView = [control cyl_tabImageView];
    }
    
    UIButton *button = CYLExternPlusButton;
    BOOL isPlusButton = [control cyl_isPlusButton];
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if (isPlusButton) {
        animationView = button.imageView;
    }
    
//    if ([self cyl_tabBarController].selectedIndex % 2 == 0) {
        [self addScaleAnimationOnView:animationView repeatCount:1];
//    } else {
//        [self addRotateAnimationOnView:animationView];
//    }
    
    //添加仿淘宝tabbar，第一个tab选中后有图标覆盖
    //    if ([control cyl_isTabButton]|| [control cyl_isPlusButton]) {
    //        BOOL shouldSelectedCoverShow = ([self cyl_tabBarController].selectedIndex == 0);
    //        [self setSelectedCoverShow:shouldSelectedCoverShow];
    //    }
    
    
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    // 针对旋转动画，需要将旋转轴向屏幕外侧平移，最大图片宽度的一半
    // 否则背景与按钮图片处于同一层次，当按钮图片旋转时，转轴就在背景图上，动画时会有一部分在背景图之下。
    // 动画结束后复位
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}




- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
   
}

//- (void)application:(UIApplication *)application
//didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    /// Required - 注册 DeviceToken
//    [JPUSHService registerDeviceToken:deviceToken];
//}
//
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
//    [application registerForRemoteNotifications];
//}
//
//#pragma mark- JPUSHRegisterDelegate
//// iOS 12 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
//    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        //从通知界面直接进入应用
//    }else{
//        //从通知设置界面进入应用
//    }
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//}
//
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
//}
//
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    // Required
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler();  // 系统要求执行这个方法
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//
//    // Required, iOS 7 Support
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//
//    // Required, For systems with less than or equal to iOS 6
//    [JPUSHService handleRemoteNotification:userInfo];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PayBackApp" object:resultDic];
        }];
    }else{
        NSLog(@"hostUrl:%@",url);
        if ([url.absoluteString containsString:kWeChatAppId]) {
            [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
        
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (status != ConnectionStatus_SignUp) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient]
                              getUnreadCount:@[
                                               @(ConversationType_PRIVATE),
                                               @(ConversationType_DISCUSSION),
                                               @(ConversationType_APPSERVICE),
                                               @(ConversationType_PUBLICSERVICE),
                                               @(ConversationType_GROUP)
                                               ]];
        application.applicationIconBadgeNumber = unreadMsgCount;
    }
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%s",__func__);
    
    /**
     最后的页面是登录模块的页面，开启后台任务，验证码计时器可以正常运行
     */
    [self beginBackTask];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"%s",__func__);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%s",__func__);
}

//申请后台
-(void)beginBackTask
{
    NSLog(@"beginBackTask");
    WEAKSELF;
    _backTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //在时间到之前会进入这个block，一般是iOS7及以上是3分钟。按照规范，在这里要手动结束后台，你不写也是会结束的（据说会crash）
        NSLog(@"将要挂起");
        [weakSelf endBackTask];
    }];
}

//注销后台任务
-(void)endBackTask
{
    NSLog(@"endBackTask");
    [[UIApplication sharedApplication] endBackgroundTask:_backTaskId];
    _backTaskId = UIBackgroundTaskInvalid;
}

//进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application{
    
    NSLog(@"%s",__func__);
    
    [self endBackTask];//结束后台任务
    
    /**
     定时器用于自动更新剩余聊天个数，当进入是23：50或其他时间，在打开APP情况下，如果日期过了一天，设置定时器多长时间后更新聊天个数
     */
    NSDate *nowDate = [NSDate date];
    NSInteger hour = [nowDate hour];
    NSInteger minute = [nowDate minute];
    NSInteger second = [nowDate second];
    NSTimeInterval delta = 24*60*60 - hour*60*60-minute*60-second; // 计算出差多少秒刚好到明天,重新执行聊天限制个数;
    if (_monitorDateChageTimer) {
        [_monitorDateChageTimer invalidate];
        _monitorDateChageTimer = nil;
    }
    WEAKSELF;
    _monitorDateChageTimer = [NSTimer scheduledTimerWithTimeInterval:delta block:^(NSTimer * _Nonnull timer) {
        
        // to do
        [weakSelf refreshTotalChatCount];
        
    } repeats:NO];
    
    /**
     日期不是同一天了，重新执行聊天限制个数
     */
    NSDate *oldDate = [[NSUserDefaults standardUserDefaults] valueForKey:kEnterBackgroundDate];
    if (oldDate) {
        NSInteger dayNow = [nowDate day];
        NSInteger dayOld = [oldDate day];
        if (dayNow != dayOld) {//day不一样，不是同一天，重新执行聊天限制个数
            
            [self refreshTotalChatCount];
        }
    }else{
        [self refreshTotalChatCount];
    }
    
}

- (void)refreshTotalChatCount{
    
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:kEnterBackgroundDate];
    // 最大聊天个数，可以和3个人聊天
    [[NSUserDefaults standardUserDefaults]setObject:@(kConstChatCount) forKey:kChatCount];
    [[NSUserDefaults standardUserDefaults]setObject:@(kConstSayHiCount) forKey:kSayHiCount];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kChatedUser];
    [[NSUserDefaults standardUserDefaults]setObject:@(kConstPickBottleCount) forKey:kPickBottleCount];
    [[NSUserDefaults standardUserDefaults]setObject:@(kConstSendBottleCount) forKey:kSendBottleCount];
    
//    if ([SCUserCenter sharedCenter].currentUser.userInfo.isOnlineSwitch) {
//        
//        
//        
//    }else{
//        
//        [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:kEnterBackgroundDate];
//        // 最大聊天个数，可以和3个人聊天
//        [[NSUserDefaults standardUserDefaults]setObject:@(1000) forKey:kChatCount];
//        [[NSUserDefaults standardUserDefaults]setObject:@(1000) forKey:kSayHiCount];
//        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kChatedUser];
//    }
    
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings: (UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError ERROR：%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // 统计推送打开率
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    // 获取融云推送服务扩展字段
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // 统计推送打开率
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    
    //    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于前台时的远程推送接受
            //关闭U-Push自带的弹出框
            //        [UMessage setAutoAlert:NO];
            //必须加这句代码
            //        [UMessage didReceiveRemoteNotification:userInfo];
            
        }else{
            //应用处于前台时的本地推送接受
        }
    } else {
        // Fallback on earlier versions
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    //        NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        //         [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

@end
