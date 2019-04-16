//
//  AskWeChatOrYueTaVC.m
//  SocialContact
//
//  Created by EDZ on 2019/2/27.
//  Copyright © 2019 ha. All rights reserved.
//

#import "AskWeChatOrYueTaVC.h"
#import "ForumVC.h"

@interface AskWeChatOrYueTaVC()<JXCategoryViewDelegate,SwipeViewDelegate,SwipeViewDataSource>

@property(nonatomic,strong) JXCategoryTitleView *categoryView;

@property(nonatomic,strong) SwipeView *swipeView;

@property(nonatomic,strong) NSMutableArray *vcItem;

@end

@implementation AskWeChatOrYueTaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_type == 1) {
        self.title = @"交换微信";
    }else if (_type == 2) {
        self.title = @"帮我约";
    }else if (_type == 2) {
        self.title = @"积分商城";
    }
    
    [self.view addSubview:self.categoryView];
    [self setUpViewItem];
    [self.view addSubview:self.swipeView];
    [self.swipeView reloadData];
    
}

- (JXCategoryTitleView *)categoryView{
    if (!_categoryView) {
        
        //1、初始化JXCategoryTitleView
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _categoryView.delegate = self;
        if (_type == 1) {
            _categoryView.titles = @[@"我发出的",@"我收到的"];
        }else if (_type == 2) {
            _categoryView.titles = @[@"我约的",@"约我的"];
        }else if (_type == 3) {
            _categoryView.titles = @[@"商品列表",@"兑换记录"];
        }
        
        _categoryView.backgroundColor = BackGroundColor;
//        [UIColor whiteColor];
        //2、添加并配置指示器
        //lineView
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineViewColor = m1;
        //        lineView.indicatorLineWidth = 10;
        lineView.indicatorLineViewHeight = 2;
        self.categoryView.indicators = @[lineView];
        
        self.categoryView.titleColor = m2;
        self.categoryView.titleSelectedColor = m1;
        
        self.categoryView.titleFont = [UIFont fontWithName:@"Heiti SC" size:15];
        
    }
    return _categoryView;
}

- (SwipeView *)swipeView{
    if (!_swipeView) {
        _swipeView = [[SwipeView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-GuaTopHeight-44)];
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
     1: 交换微信
     2: 约人
     */
    
    ForumVC *vc1 = [[ForumVC alloc]init];
    vc1.fatherVC = self;
    if (_type == 1 || _type == 2) {
        vc1.forumVCType = ForumVCTypeAskWeChatOrYueTa;
        vc1.momentUIType = MomentUITypeAskWeChatOrYueTa;
    }else if (_type == 3) {
        vc1.forumVCType = ForumVCTypePointsStore;
        vc1.momentUIType = MomentUITypePointsStore;
    }
    
    
    if (_type == 1) {
        vc1.momentRequestType = MomentRequestTypeAskWeChatSend;
    }else if (_type == 2) {
        vc1.momentRequestType = MomentRequestTypeYueTaSend;
    }else if (_type == 3) {
        vc1.momentRequestType = MomentRequestTypePointSkus;
    }
    vc1.height = kScreenHeight-GuaTopHeight-44;
    [_vcItem addObject:vc1];
    
    
    ForumVC *vc2 = [[ForumVC alloc]init];
    vc2.fatherVC = self;
    if (_type == 1 || _type == 2) {
        vc2.forumVCType = ForumVCTypeAskWeChatOrYueTa;
        vc2.momentUIType = MomentUITypeAskWeChatOrYueTa;
    }else if (_type == 3) {
        vc2.forumVCType = ForumVCTypePointsStore;
        vc2.momentUIType = MomentUITypePointsStore;
    }
    if (_type == 1) {
        vc2.momentRequestType = MomentRequestTypeAskWeChatReceived;
    }else if (_type == 2) {
        vc2.momentRequestType = MomentRequestTypeYueTaReceived;
    }else if (_type == 3) {
        vc2.momentRequestType = MomentRequestTypePointSkusExchages;
    }
    vc2.height = kScreenHeight-GuaTopHeight-44;
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
