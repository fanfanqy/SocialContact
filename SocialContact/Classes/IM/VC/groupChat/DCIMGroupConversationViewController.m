//
//  DCIMGroupConversationViewController.m
//  ChildEnd
//
//  Created by dylan on 2017/2/28.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "DCIMGroupConversationViewController.h"



@interface DCIMGroupConversationViewController ()
/** 群信息 */
//@property (strong, nonatomic) DCIMGroup *group;
@end

@implementation DCIMGroupConversationViewController

#pragma mark -

#pragma mark -

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    RCMessageCell *rcell = (RCMessageCell *)cell;
    if (![rcell isKindOfClass:[RCTipMessageCell class]] && [rcell.messageContentView.subviews.firstObject isKindOfClass:[UIImageView class]] &&![cell isKindOfClass:[RCImageMessageCell class]]) {
        UIImageView *image = rcell.messageContentView.subviews.firstObject;
        if (rcell.model.messageDirection == 1) {
            // 发送
            image.image =  [[UIImage imageNamed:@"chat_to_bg_normal" inBundle:nil compatibleWithTraitCollection:nil] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 20) resizingMode:UIImageResizingModeStretch];
        } else {
            // 接受
            image.image = [[UIImage imageNamed:@"duihua-bai" inBundle:nil compatibleWithTraitCollection:nil] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 20) resizingMode:UIImageResizingModeStretch];
        }
    }
    if ([cell isKindOfClass:[RCTextMessageCell class]]) {
        RCTextMessageCell *tcell = (RCTextMessageCell *)cell;
        if ( rcell.model.messageDirection == 1) {
            tcell.textLabel.textColor = [UIColor whiteColor];
        } else {
            tcell.textLabel.textColor = Font_color2;
        }
    }
	

	[super willDisplayMessageCell:cell atIndexPath:indexPath];
}


#pragma mark -


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}


#pragma mark -

- (void)viewDidLoad {
	[super viewDidLoad];

//    self.navigationController.navigationBar.translucent = NO;
//    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
//
//        self.automaticallyAdjustsScrollViewInsets = YES;
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 11.0) {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
//    }
//
//    self.conversationMessageCollectionView.frame = self.view.bounds;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 11.0) {
//        self.conversationMessageCollectionView.contentInset = UIEdgeInsetsMake(NAVHEIGHT, 0, 0, 0);
//        self.conversationMessageCollectionView.scrollIndicatorInsets = self.conversationMessageCollectionView.contentInset;
//    }
    
    // 组信息
//    [DCIMAPI getGroupCompletedInfo:self.targetId competeBlock:^(BOOL succeed, NSError *error, DCIMGroup *group) {
//        if ( group ) {
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dian-hei"] style:UIBarButtonItemStylePlain target:self action:@selector(goChatSetting)];
//            self.group = group;
//            self.title = group.groupName;
//            [self.conversationMessageCollectionView reloadData];
//        } else {
//            self.navigationItem.rightBarButtonItem = nil;
//        }
//    }];

    
	self.enableNewComingMessageIcon = YES;
	self.displayUserNameInCell = YES;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemPressed:)];

	[self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1602];
	[self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1601];
	[self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    

}

// 点击头像
- (void) didTapCellPortrait: (NSString *) userId {
    
    // 如果是自己的跳过
    if ([userId isEqualToString:[NSString stringWithFormat:@"%ld",[SCUserCenter sharedCenter].currentUser.user_id]]) {
        return;
    }
    
	// 获取用户信息

}

- (void)didTapUrlInMessageCell:(NSString *)url
												 model:(RCMessageModel *)model {
	
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
