//
//  NSObject+HhtCategory.m
//  ChildEnd
//
//  Created by EDZ on 2018/8/1.
//  Copyright © 2018年 readyidu. All rights reserved.
//

#import "NSObject+HhtCategory.h"

@implementation NSObject (HhtCategory)
-(BOOL) runningInBackground
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateBackground);
    
    return result;
}

-(void)addLocalNotification{
    //定义本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.repeatInterval = 0; //通知重复次数
    //设置通知属性
    notification.alertTitle= @"消息提醒";
    notification.alertBody = @"您有新消息未读~";
    notification.applicationIconBadgeNumber = 1;
    notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    notification.soundName=@"callAlert.caf";//通知声音（需要真机才能听到声音）

    // 震动提示
    AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
        
    });
    //调用通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}

-(void)addLocalNotificationWithTitle:(NSString *)title body:(NSString *)body {
    //定义本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    //设置调用时间
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];//通知触发时间，10s之后
    notification.repeatInterval = 0; //通知重复次数
    
    //设置通知属性
    notification.alertTitle = title;
    notification.alertBody = body;
    //    notification.alertTitle=@"爱";
    //    notification.alertBody = @"你好";
    //通知主体
    notification.applicationIconBadgeNumber = 0;//应用程序右上角显示的未读消息数
    // notification.alertAction = @"打开应用";//待机界面的滑动动作提示
    //    notification.alertLaunchImage = @"launch";//通过点击通知打开应用时的启动图片，这里使用程序启动图片
    notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    //    notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
    
    //设置用户信息@{@"content":@"你好",@"pushID":@"",@"title":@"爱",@"type":@"0"}
//    notification.userInfo =@"" ;
    
    //调用通知
    //    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    
    
}
@end
