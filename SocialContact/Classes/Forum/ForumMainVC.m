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

@property(nonatomic,strong) UIImageView *topBarView;

@end

@implementation ForumMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.publishBtn];
    [self setUpViewItem];
    [self.view addSubview:self.swipeView];
    [self.swipeView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}


- (UIImageView *)topBarView{
    if (!_topBarView) {
        _topBarView = [UIImageView new];
        _topBarView.backgroundColor = Font_color333;
        _topBarView.frame = CGRectMake(0, 0, self.view.width, StatusBarHeight+50);
        _topBarView.contentMode = UIViewContentModeScaleAspectFill;
        _topBarView.image = [UIImage imageNamed:@"navbg"];
        _topBarView.layer.masksToBounds = YES;
    }
    return _topBarView;
}

- (JXCategoryTitleView *)categoryView{
    if (!_categoryView) {
       
        //1、初始化JXCategoryTitleView
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, 230, 48)];
        _categoryView.delegate = self;
//        _categoryView.titles = @[@"话题",@"最新",@"关注",@"技能"];
        _categoryView.titles = @[@"朋友圈",@"话题",@"活动"];
        //2、添加并配置指示器
        //lineView
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineViewColor = [UIColor whiteColor];
        lineView.indicatorLineWidth = 14;
        lineView.indicatorLineViewHeight = 2;
        //backgroundView
//        JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
//        backgroundView.backgroundViewColor = [UIColor redColor];
//        backgroundView.backgroundViewWidth = JXCategoryViewAutomaticDimension;
        self.categoryView.indicators = @[lineView];
        
        self.categoryView.titleColor = [UIColor whiteColor];
        self.categoryView.titleSelectedColor = [UIColor whiteColor];
        
        self.categoryView.titleSelectedFont = [[UIFont systemFontOfSize:22]fontWithBold];
        self.categoryView.titleFont = [UIFont systemFontOfSize:18];
        
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
        _swipeView = [[SwipeView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+55, kScreenWidth, kScreenHeight-55-UITabBarHeight-StatusBarHeight)];
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

//   最新动态
    ForumVC *vc2  = [[ForumVC alloc]init];
    vc2.forumVCType = ForumVCTypeMoment;
    vc2.momentUIType = MomentUITypeList;
    vc2.height = kScreenHeight-StatusBarHeight-55-UITabBarHeight;
    vc2.momentRequestType = MomentRequestTypeNewest;
    vc2.fatherVC = self;
    [_vcItem addObject:vc2];
    
//   话题
    ForumVC *vc1  = [[ForumVC alloc]init];
    vc1.forumVCType = ForumVCTypeTopic;
    vc1.height = kScreenHeight-StatusBarHeight-55-UITabBarHeight;
    vc1.fatherVC = self;
    [_vcItem addObject:vc1];
    
//    活动
    ForumVC *vc3  = [[ForumVC alloc]init];
    vc3.forumVCType = ForumVCTypeActivity;
    vc3.momentUIType = MomentUITypeActivity;
    vc3.height = kScreenHeight-StatusBarHeight-55-UITabBarHeight;
    vc3.momentRequestType = MomentRequestTypeActivity;
    vc3.fatherVC = self;
    [_vcItem addObject:vc3];
    
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
