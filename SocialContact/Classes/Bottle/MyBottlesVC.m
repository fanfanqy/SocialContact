//
//  MyBottlesVC.m
//  SocialContact
//
//  Created by EDZ on 2019/2/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "MyBottlesVC.h"
#import "BottlesVC.h"

@interface MyBottlesVC ()<JXCategoryViewDelegate,SwipeViewDelegate,SwipeViewDataSource>

@property(nonatomic,strong) JXCategoryTitleView *categoryView;

@property(nonatomic,strong) SwipeView *swipeView;

@property(nonatomic,strong) NSMutableArray *vcItem;

@end

@implementation MyBottlesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的漂流瓶";
    
    [self.view addSubview:self.categoryView];
    [self setUpViewItem];
    [self.view addSubview:self.swipeView];
    [self.swipeView reloadData];
    
}

- (JXCategoryTitleView *)categoryView{
    if (!_categoryView) {
        
        //1、初始化JXCategoryTitleView
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _categoryView.delegate = self;
        _categoryView.titles = @[@"捡到的瓶子",@"扔出的瓶子"];
        _categoryView.backgroundColor = Font_color333;
        //2、添加并配置指示器
        //lineView
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineViewColor = m1;
//        lineView.indicatorLineWidth = 10;
        lineView.indicatorLineViewHeight = 1;
        self.categoryView.indicators = @[lineView];
        
        self.categoryView.titleColor = m2;
        self.categoryView.titleSelectedColor = m1;
        
//        self.categoryView.titleSelectedFont = [UIFont systemFontOfSize:25];
        self.categoryView.titleFont = [UIFont systemFontOfSize:15];
        
    }
    return _categoryView;
}

- (SwipeView *)swipeView{
    if (!_swipeView) {
        _swipeView = [[SwipeView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-GuaTopHeight-40)];
        _swipeView.pagingEnabled    = YES;
        _swipeView.delegate         = self;
        _swipeView.dataSource       = self;
        _swipeView.bounces          = NO;
        
    }
    return _swipeView;
}

//为什么会把选中代理分为三个，因为有时候只关心点击选中的，有时候只关心滚动选中的，有时候只关心选中。所以具体情况，使用对应方法。
/**
 点击选择或者滚动选中都会调用该方法，如果外部不关心具体是点击还是滚动选中的，只关心选中这个事件，就实现该方法。
 
 @param categoryView categoryView description
 @param index 选中的index
 */
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    [_swipeView scrollToItemAtIndex:index duration:0];
}

#pragma mark SwipeViewDelegate
- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView{
    [self.categoryView selectItemAtIndex:swipeView.currentItemIndex];
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView{
    return self.swipeView.bounds.size;
}

#pragma mark SwipeViewDataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    return _vcItem.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (_vcItem.count > index) {
        UIViewController *vc = (UIViewController *)_vcItem[index];
        return vc.view;
    }else{
        return view;
    }
}

- (void)setUpViewItem{
    if (!_vcItem) {
        _vcItem = [NSMutableArray array];
    }
    
    /**
     1.我捡到的瓶子
     2.我扔出的瓶子
     */
    
    BottlesVC *vc1 = [[BottlesVC alloc]init];
    vc1.type = 1;
    vc1.fatherVC = self;
    vc1.height = kScreenHeight-GuaTopHeight-40;
    [_vcItem addObject:vc1];
    
    //   最新动态
    BottlesVC *vc2 = [[BottlesVC alloc]init];
    vc2.type = 2;
    vc2.fatherVC = self;
    vc2.height = kScreenHeight-GuaTopHeight-40;
    [_vcItem addObject:vc2];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
