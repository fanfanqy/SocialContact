//
//  DCIMChatViewController.h
//  ChildEnd
//
//  Created by dylan on 2017/2/23.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface DCIMChatViewController : RCConversationViewController

@property ( nonatomic ) BOOL needPopRoot;
    /** 是否置顶 */
//@property (strong, nonatomic) RCConversationModel *conversationModel;

// 主动聊天的
@property (assign, nonatomic) BOOL isActiveChat;

@end
