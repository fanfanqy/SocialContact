//
//  YDLoadDataTablView.m
//  CSNotificationView-CSNotificationView
//
//  Created by 陈康 on 2017/11/20.
//

#import "InsLoadDataTablView.h"



@implementation InsLoadDataTablView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Remove touch delay (since iOS 8)
    UIView *wrapView = self.subviews.firstObject;
    // UITableViewWrapperView
    if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
        for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
            // UIScrollViewDelayedTouchesBeganGestureRecognizer
            if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) {
                gesture.enabled = NO;
                break;
            }
        }
    }
 
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ( [view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
}

- (void)setLoadNewData:(void (^)(void))loadNewData {
    _loadNewData = loadNewData;
    __weak typeof(self)weakSelf = self;

//    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
//        weakSelf.loadNewData();
//    }];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.loadNewData();
    }];
    
    header.ignoredScrollViewContentInsetTop = StatusBarHeight;
    
    
    
    header.stateLabel.hidden = NO;
    header.lastUpdatedTimeLabel.hidden = YES;

    self.mj_header = header;
    
}


- (void)setLoadMoreData:(void (^)(void))loadMoreData {
    
    _loadMoreData = loadMoreData;
    __weak typeof(self)weakSelf = self;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.loadMoreData();
    }];
    
//    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        weakSelf.loadMoreData();
//    }];
    
//    MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
//        weakSelf.loadMoreData();
//    }];
    [footer setTitle:@"--end--" forState:MJRefreshStateNoMoreData];
    
    self.mj_footer = footer;
}

- (void)hideFooter {
    self.mj_footer.hidden = YES;
}

- (void)showFooter {
    self.mj_footer.hidden = NO;
}

- (void)endRefreshNoMoreData {
    
//    [self.mj_footer endRefreshing];
//    self.mj_footer.state = MJRefreshStateNoMoreData;
    
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)endRefresh {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)beginRefresh {
    [self.mj_header beginRefreshing];
}

@end
