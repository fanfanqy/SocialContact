//
//  WBStatusComposeViewController.h
//  YYKitExample
//
//  Created by ibireme on 15/9/8.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "NewDynamicsLayout.h"

/// 发布
@interface WBStatusComposeViewController : UIViewController

@property (nonatomic, copy) void (^dismiss)(void);

@property (strong, nonatomic) TopicModel *topicModel;//话题列表页 进入发帖

@property (assign, nonatomic) NSInteger maxCount;



@end
