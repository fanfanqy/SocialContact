//
//  UIScrollView+LoadData.h
//  ChildEnd
//
//  Created by EDZ on 2018/11/14.
//  Copyright © 2018年 readyidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (LoadData)

/** 下拉刷新  */
@property (copy, nonatomic) void(^loadNewData)(void);

/** 上拉加载更多 */
@property (copy, nonatomic) void(^loadMoreData)(void);


- (void)beginRefresh;
- (void)endRefresh;
- (void)endRefreshNoMoreData;

- (void)hideFooter;
- (void)showFooter;

@end

NS_ASSUME_NONNULL_END
