//
//  MatchFriendVC.m
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "MatchFriendVC.h"
#import "MatchTableViewCell.h"
#import "RecommendUserCell.h"

#import "VipVC.h"

@interface MatchFriendVC ()<ZLSwipeableViewDelegate,ZLSwipeableViewDataSource,MatchTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

INS_P_STRONG(ZLSwipeableView *, swipeableView);

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) NSMutableArray *recommendUserArray;

@property (nonatomic) NSUInteger currentIndex;

@property(nonatomic,strong) InsLoadDataTablView *tableView;

@property(nonatomic,strong)UIView *tableViewHeaderView;

@property(nonatomic,assign) NSInteger page;

@property(nonatomic,assign) NSInteger pageRecentUser;

@property(nonatomic,strong) UIView *topBarView;

@property(nonatomic,strong) UIButton *customerBtn;// 客服按钮

@property(nonatomic,strong) UIButton *conditionSelect;// 筛选按钮

@property(nonatomic,strong) UIImageView *unknowUserImg;// 陌生人图标

@property(nonatomic,strong) UIButton *userAmount;// 在线人数




@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) UIButton *todayRecommend;

@property(nonatomic,strong) UIButton *wantToTop;

@end

@implementation MatchFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setUpUI];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

/*
- (void)setUpUI{
    ZLSwipeableView *swipeableView = [[ZLSwipeableView alloc] initWithFrame:CGRectZero];
    self.swipeableView = swipeableView;
    [self.view addSubview:self.swipeableView];
    
    // Required Data Source
    self.swipeableView.dataSource = self;
    
    // Optional Delegate
    self.swipeableView.delegate = self;
    
    self.swipeableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *metrics = @{};
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"|-50-[swipeableView]-50-|"
                               options:0
                               metrics:metrics
                               views:NSDictionaryOfVariableBindings(
                                                                    swipeableView)]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-120-[swipeableView]-100-|"
                               options:0
                               metrics:metrics
                               views:NSDictionaryOfVariableBindings(
                                                                    swipeableView)]];
}

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView{
    return nil;
}

- (void)viewDidLayoutSubviews {
    [self.swipeableView loadViewsIfNeeded];
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    NSLog(@"did swipe in direction: %zd", direction);
}

*/

- (void)setUpUI{
    
    self.view.backgroundColor = BackGroundColor;
    
    [self.view addSubview:self.topBarView];
    
    [self.view addSubview:self.tableView];
    
    self.array = [NSMutableArray array];
    
    self.recommendUserArray = [NSMutableArray array];
    
    @weakify(self);
    [self.tableView setLoadNewData:^{
        @normalize(self);
        [self fetchData:YES requestType:self.momentRequestType];
    }];
    
    [self.tableView setLoadMoreData:^{
        @normalize(self);
        [self fetchData:NO requestType:self.momentRequestType];
    }];
    
    [self.tableView hideFooter];
    [self showLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchData:YES requestType:self.momentRequestType];
        [self fetchData:YES requestType:MomentRequestTypeRecentlyUser];
    });
    
}

- (void)recommendUser{
//   /api/customers/recommend/
//    新用户推荐
}

- (void)fetchData:(BOOL)refresh requestType:(MomentRequestType)momentRequestType{
    WEAKSELF;
    NSDictionary *param = nil;
    NSString *url = @"";
    if (momentRequestType == MomentRequestTypeUnknow) {
        if (refresh) {
            _page = 1;
        }else{
            _page ++;
        }
    }else if (momentRequestType == MomentRequestTypeRecentlyUser) {
        if (refresh) {
            _pageRecentUser = 1;
        }else{
            _pageRecentUser ++;
        }
    }
    
    switch (momentRequestType) {
        case MomentRequestTypeUnknow:
            url = @"/customer/unknown/lists/";
            param = @{@"page": [NSNumber numberWithInteger:_page]};
            break;
            
        case MomentRequestTypeRecentlyUser:
            url = @"/customer/unknown/lists/";
            param = @{@"page": [NSNumber numberWithInteger:_page]};
            break;
            
        case MomentRequestTypeTop:
            url = @"/api/customers/service_top/";
            param = @{@"page": [NSNumber numberWithInteger:_page]};
            break;
            
        default:
            break;
    }
        
    GETRequest *request = [GETRequest requestWithPath:url parameters:param completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        [weakSelf.tableView endRefresh];
        
        if (!request.error) {
            
            NSArray *resultArray = request.responseObject[@"data"][@"results"];
            
            if ( resultArray && resultArray.count > 0 ) {
                
                if (resultArray.count == 10) {
                    [weakSelf.tableView showFooter];
                } else {
                    [weakSelf.tableView hideFooter];
                }
            } else {
//                [weakSelf.tableView hideFooter];
            }
            
            
            if (momentRequestType == weakSelf.momentRequestType) {
                if (refresh) {
                    [weakSelf.array removeAllObjects];
                }else{
                    if (resultArray.count == 0) {
                        [weakSelf.tableView endRefreshNoMoreData];
                    }
                }
            }else{
                if (refresh) {
                    [weakSelf.recommendUserArray removeAllObjects];
                }else{
                    if (weakSelf.recommendUserArray.count == 0) {
                        [weakSelf.tableView endRefreshNoMoreData];
                    }
                }
            }
            
            [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MomentModel *momentModel = [MomentModel modelWithDictionary:obj];
                if (momentRequestType == weakSelf.momentRequestType) {
                    [weakSelf.array addObject:momentModel];
                }else{
                    [weakSelf.recommendUserArray addObject:momentModel];
                }
                
            }];
            if (momentRequestType == weakSelf.momentRequestType) {
                [weakSelf.tableView reloadData];
            }else{
                [weakSelf.collectionView reloadData];
            }
            
        }else{
            if ( weakSelf.page > 1 ) {
                weakSelf.page --;
            }
            if (weakSelf.array.count > 0) {
                [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
                [SVProgressHUD dismissWithDelay:1.5];
            } else {
                [weakSelf showError:request.error reload:nil];
            }
            
        }
        
    }];
    [InsNetwork addRequest:request];
}

- (void)heartBeat:(NSIndexPath *)indexPath{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
//    alert.iconTintColor = [UIColor colorWithHexString:@"F57C00"];
    [alert removeTopCircle];
    //    backgroundColor, borderWidth, borderColor, textColor
    alert.buttonFormatBlock = ^NSDictionary *{
        return @{
                 @"backgroundColor":[UIColor colorWithHexString:@"F57C00"],
                 @"textColor":[UIColor whiteColor],
                 };
    };
    
    //Using Block
    WEAKSELF;
    [alert addButton:@"前去充值" actionBlock:^(void) {
        VipVC *vc = [[VipVC alloc]initWithNibName:@"VipVC" bundle:nil];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [alert showNotice:self title:@"VIP 充值" subTitle:@"充值后可以嗨嗨嗨" closeButtonTitle:@"暂不" duration:0.0f]; // Notice
    
}

- (void)chatClick:(NSIndexPath *)indexPath{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
//    alert.iconTintColor = [UIColor purpleColor];
    [alert removeTopCircle];
    //    backgroundColor, borderWidth, borderColor, textColor
    alert.buttonFormatBlock = ^NSDictionary *{
        return @{
                 @"backgroundColor":[UIColor colorWithHexString:@"F57C00"],
                 @"textColor":[UIColor whiteColor],
                 };
    };
    
    //Using Block
    SCLButton *button = [alert addButton:@"前去充值" actionBlock:^(void) {
        
    }];
    
    
    [alert showNotice:self title:@"VIP 充值" subTitle:@"充值后可以嗨嗨嗨" closeButtonTitle:@"暂不" duration:0.0f]; // Notice
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MomentModel *model = self.array[indexPath.row];
    MatchTableViewCell *cell = (MatchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MatchTableViewCell"];
    [cell setModel:model];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 187+kScreenWidth-20+20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (InsLoadDataTablView *)tableView {
    if ( !_tableView ) {
        _tableView = [[InsLoadDataTablView alloc] initWithFrame:CGRectMake(0, GuaTopHeight, self.view.width, kScreenHeight-GuaTopHeight-UITabBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = Line;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(_tableView.separatorInset.top, 15, _tableView.separatorInset.bottom, 15)];
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:@"MatchTableViewCell"];
        
        _tableView.tableHeaderView = self.tableViewHeaderView;
        
    }
    return _tableView;
}

#pragma mark - LazyLoad


- (UIView *)topBarView{
    if (!_topBarView) {
        _topBarView = [UIView new];
        _topBarView.backgroundColor = YD_ColorBlack_1F2124;
        _topBarView.frame = CGRectMake(0, 0, self.view.width, GuaTopHeight);
        [_topBarView addSubview:self.customerBtn];
        [_topBarView addSubview:self.conditionSelect];
        [_topBarView addSubview:self.userAmount];
        [_topBarView addSubview:self.unknowUserImg];
    }
    return _topBarView;
}

- (UIButton *)customerBtn{
    if (!_customerBtn) {
        _customerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _customerBtn.frame = CGRectMake(20, 10+StatusBarHeight,  30, 30);
        [_customerBtn setImage:[UIImage imageNamed:@"icon_kefu"] forState:UIControlStateNormal];
        
        [_customerBtn setTitle:@"客服" forState:UIControlStateNormal];
        [_customerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_customerBtn addTarget:self action:@selector(customerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customerBtn;
}

- (UIButton *)conditionSelect{
    if (!_conditionSelect) {
        _conditionSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        _conditionSelect.frame = CGRectMake(kScreenWidth - 60, 10+StatusBarHeight, 30, 30);
        [_conditionSelect setImage:[UIImage imageNamed:@"icon_shaixuan"] forState:UIControlStateNormal];
        
//        [_conditionSelect setTitle:@"筛选" forState:UIControlStateNormal];
//        [_conditionSelect setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_conditionSelect addTarget:self action:@selector(conditionSelectClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conditionSelect;
}

- (UIButton *)userAmount{
    if (!_userAmount) {
        _userAmount = [UIButton buttonWithType:UIButtonTypeCustom];
        _userAmount.frame = CGRectMake(kScreenWidth - 60 - 50 -20, 10+StatusBarHeight, 60, 32);
//        [_userAmount setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        [_userAmount setTitle:@"1000" forState:UIControlStateNormal];
        [_userAmount setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_userAmount addTarget:self action:@selector(userAmountClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userAmount;
}

- (UIImageView *)unknowUserImg{
    if (!_unknowUserImg) {
        _unknowUserImg = [UIImageView new];
        _unknowUserImg.contentMode = UIViewContentModeScaleAspectFit;
        _unknowUserImg.image = [UIImage imageNamed:@"ic_register"];
        _unknowUserImg.frame = CGRectMake(kScreenWidth - 60 - 50 -20-20, 10+StatusBarHeight, 20, 32);
    }
    return _unknowUserImg;
    
}

- (void)customerBtnClick{
    
}

- (void)conditionSelectClick{
    
}

- (void)userAmountClick{
    
}

- (void)todayRecommendClick{
    
}

- (void)wantToTopClick{
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    //    alert.iconTintColor = [UIColor colorWithHexString:@"F57C00"];
    [alert removeTopCircle];
    //    backgroundColor, borderWidth, borderColor, textColor
    alert.buttonFormatBlock = ^NSDictionary *{
        return @{
                 @"backgroundColor":[UIColor colorWithHexString:@"F57C00"],
                 @"textColor":[UIColor whiteColor],
                 };
    };
    
    //Using Block
    WEAKSELF;
    [alert addButton:@"前去充值" actionBlock:^(void) {
        VipVC *vc = [[VipVC alloc]initWithNibName:@"VipVC" bundle:nil];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [alert showNotice:self title:@"VIP 充值" subTitle:@"充值后可以嗨嗨嗨" closeButtonTitle:@"暂不" duration:0.0f]; // Notice
    
}


- (UIView *)tableViewHeaderView{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
        [_tableViewHeaderView addSubview:self.todayRecommend];
        [_tableViewHeaderView addSubview:self.wantToTop];
        [_tableViewHeaderView addSubview:self.collectionView];
    }
    return _tableViewHeaderView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.frame = CGRectMake(0, 40, self.view.frame.size.width, 150);
//        _collectionView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0);
        _collectionView.showsHorizontalScrollIndicator = NO;        //注册
        [_collectionView registerNib:[UINib nibWithNibName:@"RecommendUserCell" bundle:nil] forCellWithReuseIdentifier:@"RecommendUserCell"];
//        [self.view addSubview:_collectionView];
//        [_collectionView addSubview:self.todayRecommend];
//        [_collectionView addSubview:self.wantToTop];
    }
    return _collectionView;
}


- (UIButton *)todayRecommend{
    if (!_todayRecommend) {
        _todayRecommend = [UIButton buttonWithType:UIButtonTypeCustom];
        _todayRecommend.frame = CGRectMake(10, 0, 65, 40);
        [_todayRecommend setTitle:@"今日推荐" forState:UIControlStateNormal];
        _todayRecommend.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_todayRecommend sizeToFit];
        [_todayRecommend setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_todayRecommend addTarget:self action:@selector(todayRecommendClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _todayRecommend;
}

- (UIButton *)wantToTop{
    if (!_wantToTop) {
        _wantToTop = [UIButton buttonWithType:UIButtonTypeCustom];
        _wantToTop.frame = CGRectMake(kScreenWidth - 75, 0, 65, 40);
        [_wantToTop setTitle:@"我要置顶" forState:UIControlStateNormal];
        _wantToTop.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_wantToTop sizeToFit];
        [_wantToTop setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_wantToTop addTarget:self action:@selector(wantToTopClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wantToTop;
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return self.recommendUserArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendUserCell" forIndexPath:indexPath];
    MomentModel *model = self.recommendUserArray[indexPath.row];
    cell.model = model;
    cell.indexPath = indexPath;
    return cell;

}

//这里我为了直观的看出每组的CGSize设置用if 后续我会用简洁的三元表示
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kScreenWidth-50)/4.0, 150);
 
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
#pragma mark TODO
    
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
