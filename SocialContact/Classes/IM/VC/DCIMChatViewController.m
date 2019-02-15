//
//  DCIMChatViewController.m
//  ChildEnd
//
//  Created by dylan on 2017/2/23.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "DCIMChatViewController.h"
@interface DCIMChatViewController () <RCPluginBoardViewDelegate>
/** 按钮 */
@property (strong, nonatomic) UIButton *action;

/** keyboardEnable */
@property (assign, nonatomic) BOOL keyboardEnable;

@end

@implementation DCIMChatViewController


#pragma mark -

// 点击头像
- (void) didTapCellPortrait: (NSString *) userId {
    // 获取用户信息
   
}

- (void)didTapUrlInMessageCell:(NSString *)url
                         model:(RCMessageModel *)model {
   
}

- (void) appendCallMessage: (NSNotification *) notification  {
    if ( notification.object && [notification.object isKindOfClass:[NSDictionary class]]  ) {
        NSDictionary *object = notification.object;
        
        RCMessage *message = object[@"message"];
        NSString *targetId = object[@"targetId"];
        
        if ( [self.targetId isEqualToString:targetId] ) {
            [self appendAndDisplayMessage:message];
        }
    }
}

#pragma mark -

- (void)sendMessage:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent {
   
    [super sendMessage:messageContent pushContent:pushContent];
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];

    self.enableNewComingMessageIcon = YES;

    
    //删除视频通话按钮
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1602];
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1601];
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}

- (void)back {
    if ( _needPopRoot ) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) refreshCurrentUserInfo {
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}


- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
