//
//  BottomToolView.h
//  SocialContact
//
//  Created by EDZ on 2019/1/20.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BottomToolViewDelegate <NSObject>

@optional

// 立即参与
-(void)partiClick;

// 加入讨论
- (void)joinClick;

@end

/**
 <#Description#>
 */
@interface BottomToolView : UIView
@property (weak, nonatomic) IBOutlet UIButton *partiBtn;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@property (weak, nonatomic) id<BottomToolViewDelegate> delegate;


/**
 0: 话题列表页
 1: 个人主页
 */
@property (assign, nonatomic) NSInteger type;

@end

NS_ASSUME_NONNULL_END
