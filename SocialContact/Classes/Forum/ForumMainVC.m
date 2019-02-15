//
//  ForumMainVC.m
//  SocialContact
//
//  Created by EDZ on 2019/1/12.
//  Copyright © 2019 ha. All rights reserved.
//

#import "ForumMainVC.h"
#import "ForumVC.h"
#import "WBStatusComposeViewController.h"


@interface ForumMainVC ()<JXCategoryViewDelegate,SwipeViewDelegate,SwipeViewDataSource>

@property(nonatomic,strong) JXCategoryTitleView *categoryView;

@property(nonatomic,strong) SwipeView *swipeView;

@property(nonatomic,strong) NSMutableArray *vcItem;

@property(nonatomic,strong) UIButton *publishBtn;

@end

@implementation ForumMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.publishBtn];
    [self setUpViewItem];
    [self.view addSubview:self.swipeView];
    [self.swipeView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (JXCategoryTitleView *)categoryView{
    if (!_categoryView) {
       
        //1、初始化JXCategoryTitleView
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, 150, 50)];
        _categoryView.delegate = self;
//        _categoryView.titles = @[@"话题",@"最新",@"关注",@"技能"];
        _categoryView.titles = @[@"朋友圈",@"话题"];
        //2、添加并配置指示器
        //lineView
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineViewColor = [UIColor redColor];
        lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
        //backgroundView
//        JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
//        backgroundView.backgroundViewColor = [UIColor redColor];
//        backgroundView.backgroundViewWidth = JXCategoryViewAutomaticDimension;
        self.categoryView.indicators = @[lineView];
       
   
    }
    return _categoryView;
}

- (UIButton *)publishBtn{
    if (!_publishBtn) {
        _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishBtn.frame = CGRectMake(kScreenWidth-60, StatusBarHeight, 50, 50);
        [_publishBtn setImage:[UIImage imageNamed:@"ic_camersss"] forState:UIControlStateNormal];
        [_publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}

- (void)publishBtnClick{
    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (SwipeView *)swipeView{
    if (!_swipeView) {
        _swipeView = [[SwipeView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+50, kScreenWidth, kScreenHeight-50-UITabBarHeight)];
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

    
    ForumVC *vc2  = [[ForumVC alloc]init];
    vc2.forumVCType = ForumVCTypeMoment;
    vc2.momentUIType = MomentUITypeList;
    vc2.momentRequestType = MomentRequestTypeNewest;
    vc2.fatherVC = self;
    [_vcItem addObject:vc2];
    
    ForumVC *vc1  = [[ForumVC alloc]init];
    vc1.forumVCType = ForumVCTypeTopic;
    vc1.fatherVC = self;
    [_vcItem addObject:vc1];
    
//    ForumVC *vc3  = [[ForumVC alloc]init];
//    vc3.forumVCType = ForumVCTypeMoment;
//    vc3.momentUIType = MomentUITypeList;
//    vc3.momentRequestType = MomentRequestTypeFollow;
//    [_vcItem addObject:vc3];
//
//    ForumVC *vc4  = [[ForumVC alloc]init];
//    vc4.forumVCType = ForumVCTypeMoment;
//    vc4.momentUIType = MomentUITypeList;
//    vc4.momentRequestType = MomentRequestTypeSkill;
//    [_vcItem addObject:vc4];
    
    
    
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
