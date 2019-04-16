//
//  YDLoadDataTablView.h
//  CSNotificationView-CSNotificationView
//
//  Created by 陈康 on 2017/11/20.
//

#import <UIKit/UIKit.h>
#import "HHRefreshManager.h"

@interface InsLoadDataTablView : UITableView

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
