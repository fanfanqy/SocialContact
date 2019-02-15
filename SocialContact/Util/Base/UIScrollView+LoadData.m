//
//  UIScrollView+LoadData.m
//  ChildEnd
//
//  Created by EDZ on 2018/11/14.
//  Copyright © 2018年 readyidu. All rights reserved.
//

#import "UIScrollView+LoadData.h"


static const void *loadNewDataKey = &loadNewDataKey;
static const void *loadMoreDataKey = &loadMoreDataKey;

@implementation UIScrollView (LoadData)

- (void (^)(void))loadNewData{
    
  return  objc_getAssociatedObject(self, loadNewDataKey);
}

- (void (^)(void))loadMoreData{
    
    return  objc_getAssociatedObject(self, loadMoreDataKey);
}


- (void)setLoadNewData:(void (^)(void))loadNewData {
    
    objc_setAssociatedObject(self, loadNewDataKey, loadNewData, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    _loadNewData = loadNewData;
    
    __weak typeof(self)weakSelf = self;
    /*
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        weakSelf.loadNewData();
    }];
    NSData *data = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"pullToRefresh" ofType:@"gif"]];
    
    NSDictionary *dict = [UIImage imagesFromGif:data];
    NSArray *images = dict[@"images"] ?: [NSArray array];
    [header setImages:images forState:MJRefreshStateRefreshing];
    if (images.count > 0) {
        [header setImages:@[images.firstObject] forState:MJRefreshStatePulling];
        [header setImages:@[images.firstObject] forState:MJRefreshStateWillRefresh];
        [header setImages:@[images.firstObject] forState:MJRefreshStateIdle];
    }
    
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [header setTitle:@"将要加载" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    [header.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(-50);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(46);
    }];
    [header.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(header.gifView.mas_right).offset(10);
        make.centerY.mas_equalTo(header.gifView.mas_centerY);
    }];
    self.mj_header = header;
     */
}


- (void)setLoadMoreData:(void (^)(void))loadMoreData {
    
    objc_setAssociatedObject(self, loadMoreDataKey, loadMoreData, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    _loadMoreData = loadMoreData;
    
    __weak typeof(self)weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.loadMoreData();
    }];
    self.mj_footer = footer;
}

- (void)hideFooter {
    self.mj_footer.hidden = YES;
}

- (void)showFooter {
    self.mj_footer.hidden = NO;
}

- (void)endRefreshNoMoreData {
    [self.mj_footer endRefreshing];
    self.mj_footer.state = MJRefreshStateNoMoreData;
}

- (void)endRefresh {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)beginRefresh {
    [self.mj_header beginRefreshing];
}

@end
