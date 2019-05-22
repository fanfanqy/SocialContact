//
//  DCIMChatViewController.m
//  ChildEnd
//
//  Created by dylan on 2017/2/23.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "DCIMChatViewController.h"
#import "UserHomepageVC.h"
#import "VipVC.h"
#import "XHPopMenu.h"
#import "UserFeedBackViewController.h"
#import "AuthenticationVC.h"

typedef void(^CanChatBlock)(BOOL can);

@interface DCIMChatViewController () <RCPluginBoardViewDelegate>
/** 按钮 */
@property (strong, nonatomic) UIButton *action;

/** keyboardEnable */
@property (assign, nonatomic) BOOL keyboardEnable;

@property (assign, nonatomic) BOOL canChat;

@property (assign, nonatomic) BOOL isUseLocalChatCount;

/*
 
 决定是不是要判断 other is VIP
 主动发的，别人发的第一条消息是VIP，无限制聊天，不是VIP，限制聊天
 
 被动发的，历史别人发的第一条消息的另外一个用户是不是VIP，是VIP，可以聊天，不是的话限制聊天
 */
@property (assign, nonatomic) BOOL firstMessageSendIsVip;

@property (assign, nonatomic) BOOL historyMessageContainOther;

@property(nonatomic,strong) UIButton *moreBtn;

@property(nonatomic,strong) XHPopMenu *popMenu;

@property (assign, nonatomic)NSInteger relation_status;

@end

@implementation DCIMChatViewController


#pragma mark -

// 点击头像
- (void) didTapCellPortrait: (NSString *) userId {
    
    // 获取用户信息
    UserHomepageVC *vc = [UserHomepageVC new];
    vc.userId = [userId integerValue];
    vc.name = @"";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didTapUrlInMessageCell:(NSString *)url
                         model:(RCMessageModel *)model {
   
}

#pragma mark -

- (void)sendMessage:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent {
    
    if (![SCUserCenter sharedCenter].currentUser.userInfo.is_idcard_verified){

        [SVProgressHUD showImage:AlertErrorImage status:@"请先进行实名认证"];
        [SVProgressHUD dismissWithDelay:1.5];

        AuthenticationVC *vc = [[AuthenticationVC alloc]initWithNibName:@"AuthenticationVC" bundle:nil];
        vc.userModel = [SCUserCenter sharedCenter].currentUser.userInfo;
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    /*
     聊天限制
     */
    if (self.isUseLocalChatCount) {
        self.canChat =[self chatCountLocalJudge:YES];
    }
    
    if (self.canChat) {
        
        [super sendMessage:messageContent pushContent:pushContent];
    }else{
#pragma mark TODO  充值 VIP
        [self goVip];
    }
    
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    
    /*
     聊天限制
     */
    if (!self.canChat) {
        self.canChat =[self chatCountLocalJudge:NO];
    }
    
    if (self.canChat) {
        [super  pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }else{
        #pragma mark TODO  充值 VIP
        [self goVip];
        
    }
}

- (void)goVip{
    [SVProgressHUD showImage:AlertErrorImage status:@"充值会员，无限制聊天次数"];
    [SVProgressHUD dismissWithDelay:3];
    VipVC *vc = [VipVC new];
    vc.type = 1;
    vc.userId = [SCUserCenter sharedCenter].currentUser.userInfo.iD;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];

    self.enableNewComingMessageIcon = YES;
    self.enableUnreadMessageIcon = YES;
    self.allowsMessageCellSelection = NO;
    self.enableContinuousReadUnreadVoice = YES;
    NSArray *displayConversationTypeArray = @[[NSNumber numberWithInteger:ConversationType_PRIVATE], [NSNumber numberWithInteger:ConversationType_GROUP]];
    self.displayConversationTypeArray = displayConversationTypeArray;
    
    
    //删除视频通话按钮
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1602];
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1601];
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back_black"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCanChat:) name:@"RefreshOtherMessageIsVip" object:nil];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.moreBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    });
    
    
}

- (void)refreshCanChat:(NSNotification *)note{
    
    NSString *targetId = (NSString *)note.object;
    
    if ([targetId isEqualToString:self.targetId]) {
        
        [self canChatRequest];
    }
    
}

- (BOOL)chatCountLocalJudge:(BOOL)sendMessage{
    
    _isUseLocalChatCount = YES;
    
    NSInteger chatCount = [[[NSUserDefaults standardUserDefaults]objectForKey:kChatCount]integerValue];
    NSMutableArray *chatedUser = [NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults]objectForKey:kChatedUser]];
    
    if (chatCount <= 0) {
        
        if ([chatedUser containsObject:self.targetId]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        if (sendMessage) {
            if (![chatedUser containsObject:self.targetId]) {
                NSInteger chatCount = [[[NSUserDefaults standardUserDefaults]objectForKey:kChatCount]integerValue];
                chatCount --;
                [[NSUserDefaults standardUserDefaults]setObject:@(chatCount) forKey:kChatCount];
                
                [chatedUser addObject:self.targetId];
                [[NSUserDefaults standardUserDefaults] setObject:chatedUser forKey:kChatedUser];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
        return YES;
    }
    
}



- (void)canChatRequest{
    
    
//    WEAKSELF;
//    [self otherIsVip:^(BOOL can) {
//        if (!can) {
//            weakSelf.canChat = [weakSelf chatCountLocalJudge:NO];
//        }else{
//            weakSelf.canChat = YES;
//        }
//
//    }];
    
    
    if ([[AppDelegate sharedDelegate].isBottleCharts containsObject:self.targetId]) {
        self.canChat = YES;
        return;
    }else{
        
        if ([[AppDelegate sharedDelegate].isBottleCharts containsObject:[NSNumber numberWithInteger:[self.targetId integerValue]]]){
            self.canChat = YES;
            return;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger myId = [SCUserCenter sharedCenter].currentUser.userInfo.iD;
        for (RCMessageModel *model in self.conversationDataRepository) {
            
            if ([model.userInfo.userId integerValue] != myId) {
                self.historyMessageContainOther = YES;
            }
            
        }
    });
    
    WEAKSELF;
    NSString *service_vip_expired_at = [SCUserCenter sharedCenter].currentUser.userInfo.service_vip_expired_at;
    if ([NSString ins_String:service_vip_expired_at]) {
        
        [Help vipIsExpired:^(BOOL expired) {
            if (!expired) {
                weakSelf.canChat = YES;
            }else{
                
                if (weakSelf.historyMessageContainOther) {
                    [weakSelf otherIsVip:^(BOOL can) {
                        if (!can) {
                            weakSelf.canChat = [weakSelf chatCountLocalJudge:NO];
                        }else{
                            weakSelf.canChat = YES;
                        }
                    }];
                }else{
                    weakSelf.canChat = [weakSelf chatCountLocalJudge:NO];
                }
                
            }
        } topIsExpired:nil];
    }else{
        if (weakSelf.historyMessageContainOther) {
            [self otherIsVip:^(BOOL can) {
                if (!can) {
                    weakSelf.canChat = [weakSelf chatCountLocalJudge:NO];
                }else{
                    weakSelf.canChat = YES;
                }
            }];
        }else{
            weakSelf.canChat = [weakSelf chatCountLocalJudge:NO];
        }
        
    }
    
}

- (void)otherIsVip:(CanChatBlock)canChatBlock{
    
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:[NSString stringWithFormat:@"customer/%@/",self.targetId] parameters:nil completionHandler:^(InsRequest *request) {
        
        if (!request.error) {
            if (request.responseObject[@"data"]) {
                SCUserInfo *userInfo = [SCUserInfo modelWithDictionary:request.responseObject[@"data"]];
                
                if (userInfo.service_vip_expired_at) {
                    
                    NSDate *date = [userInfo.service_vip_expired_at sc_dateWithUTCString];
                    
//                    [NSDate dateWithString:userInfo.service_vip_expired_at format:@"yyyy-MM-dd'T'HH:mm:ss"];
                    NSTimeInterval interval = [date timeIntervalSinceNow];
                    if (interval <= 0) {
                        if (canChatBlock) {
                            canChatBlock(NO);
                        }
                    }else{
                        // 和对方的关系是屏蔽状态
                        if (userInfo.relation_status == 0) {
                            if (canChatBlock) {
                                canChatBlock(NO);
                            }
                        }else{
                            if (canChatBlock) {
                                canChatBlock(YES);
                            }
                        }
                        
                    }
                }else{
                    if (canChatBlock) {
                        canChatBlock(NO);
                    }
                }
                
            }else{
                if (canChatBlock) {
                    canChatBlock(NO);
                }
            }
        }else{
            if (canChatBlock) {
                canChatBlock(NO);
            }
        }
    
    }];
    [InsNetwork addRequest:request];
    
}

- (void)back {
    if ( _needPopRoot ) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IS_IPHONEX) {
            _moreBtn.frame = CGRectMake(kScreenWidth - 44, StatusBarHeight, 44, 44);
        }else{
            _moreBtn.frame = CGRectMake(kScreenWidth - 44, 0, 44, 44);
        }
        
        [_moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        
        [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (void)moreBtnClick{
    [self.popMenu showMenuOnView:self.view atPoint:CGPointZero];
}

#pragma mark - Propertys

- (XHPopMenu *)popMenu {
    if (!_popMenu) {
        _popMenu.backgroundColor = Black;
        //        [UIColor whiteColor];
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < 3; i ++) {
            NSString *title;
            switch (i) {
                case 0: {
                    title = @"用户主页";
                    break;
                }
                case 1: {
                    title = @"举报";
                    break;
                }
                case 2: {
                    title = @"屏蔽";
                    break;
                }
                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:nil title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        WEAKSELF;
        _popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
        _popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems) {
            if (index == 0) {
                [weakSelf goUserHomeVC:weakSelf.targetId.integerValue];
            }else if (index == 1) {
                [weakSelf jubao];
            }else if (index == 2) {
                [weakSelf lahei];
            }
        };
    }
    return _popMenu;
}

// 用户主页
- (void)goUserHomeVC:(NSInteger)userId{
    // 获取用户信息
    UserHomepageVC *vc = [UserHomepageVC new];
    vc.userId = userId;
    vc.name = @"";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)jubao{
    
    UserFeedBackViewController *vc = [UserFeedBackViewController new];
    vc.type = 0;
    vc.title = @"举报";
    vc.to_customer_id = [self.targetId integerValue];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)lahei{
    
    WEAKSELF;
    
    NSDictionary *dic = @{
                          @"customer_id":[NSNumber numberWithInteger:[self.targetId integerValue]],
                          @"status":@(0),
                          };
    POSTRequest *request = [POSTRequest requestWithPath:@"/customer/following/" parameters:dic completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            [weakSelf.view makeToast:@"已拉黑"];
            [[RCIMClient sharedRCIMClient]addToBlacklist:weakSelf.targetId success:^{
                
            } error:^(RCErrorCode status) {
                
            }];
        }
        
    }];
    [InsNetwork addRequest:request];
    
}

- (void) refreshCurrentUserInfo {
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    
    [self canChatRequest];
    
   
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
