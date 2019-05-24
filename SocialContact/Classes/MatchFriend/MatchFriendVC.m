//
//  MatchFriendVC.m
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "MatchFriendVC.h"
#import "MatchV2TableViewCell.h"
#import "RecommendUserCell.h"

#import "VipVC.h"
#import "UserHomepageVC.h"
#import "LoverConditionVC.h"
#import "DCIMChatViewController.h"

#import "GreetVC.h"

@interface MatchFriendVC ()<ZLSwipeableViewDelegate,ZLSwipeableViewDataSource,MatchV2TableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,LoverConditionVCDelegate>

INS_P_STRONG(ZLSwipeableView *, swipeableView);

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) NSMutableArray *recommendUserArray;

@property (nonatomic, strong) NSMutableArray *sayHiArray;

@property (nonatomic) NSUInteger currentIndex;

@property(nonatomic,strong) InsLoadDataTablView *tableView;

@property(nonatomic,strong)UIView *tableViewHeaderView;

@property(nonatomic,assign) NSInteger page;

@property(nonatomic,assign) NSInteger pageRecentUser;

@property(nonatomic,strong) UIImageView *topBarView;

@property(nonatomic,strong) UIButton *customerBtn;// 客服按钮

@property(nonatomic,strong) UIButton *conditionSelect;// 筛选按钮

@property(nonatomic,strong) UIImageView *unknowUserImg;// 陌生人图标

@property(nonatomic,strong) UIButton *userAmount;// 在线人数

@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) UIImageView *sideLineImgView;

@property(nonatomic,strong) UIButton *todayRecommend;

@property(nonatomic,strong) UIButton *wantToTop;

@property(nonatomic,strong) UIImageView *orangeRightArrowImgView;

@property(nonatomic,strong) NSDictionary *conditionDic;

@end

@implementation MatchFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.fd_prefersNavigationBarHidden = YES;
    [self setUpUI];
    
    // 3分钟换一下
    WEAKSELF;
    [NSTimer timerWithTimeInterval:3*60 block:^(NSTimer * _Nonnull timer) {
        
        [weakSelf fetchData:YES requestType:MomentRequestTypeRecentlyUser];
        
    } repeats:YES];
    
    
    NSInteger sayHiCount = [[[NSUserDefaults standardUserDefaults]objectForKey:kSayHiCount]integerValue];
    if (sayHiCount > 0) {
        if ([SCUserCenter sharedCenter].currentUser.userInfo.isOnlineSwitch) {
            [self fetchDataSayHi];
        }
    }
    
}

- (void)sayHi{
    

    GreetVC *pop = [GreetVC new];
    pop.dataArray = self.sayHiArray;
    STPopupController *popVericodeController = [[STPopupController alloc] initWithRootViewController:pop];
    popVericodeController.style = STPopupStyleFormSheet;
    [popVericodeController presentInViewController:self];
    
}

- (void)fetchDataSayHi{
    
    NSDictionary *dic = @{
                          @"page":@(1),
                          };
    WEAKSELF;
    
//      推荐用户
//    /api/customers/recommend/
    
//     最近登录用户
//    /customer/active/lists/
    
//    /api/customers/service_top/
    
    GETRequest *request = [GETRequest requestWithPath:@"/api/customers/recommend/" parameters:dic completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
            
        }else{
            
            [weakSelf.sayHiArray removeAllObjects];
            
            NSArray *resultArray = request.responseObject[@"data"][@"results"];
            
            if ( resultArray && resultArray.count > 0 ) {
                
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    SCUserInfo *model = [SCUserInfo modelWithDictionary:obj];
                    
                    model.isSelectedSayHi = YES;
                    [weakSelf.sayHiArray addObject:model];
                    
                }];
                
                
                [weakSelf sayHi];
            }
            
            
            
        }
        
    }];
    [InsNetwork addRequest:request];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}

- (void)setUpUI{
    
    self.view.backgroundColor = BackGroundColor;
    
    [self.view addSubview:self.topBarView];
    
    [self.view addSubview:self.tableView];
    
    self.array = [NSMutableArray array];
    
    self.recommendUserArray = [NSMutableArray array];
    
    self.sayHiArray = [NSMutableArray array];
    
    WEAKSELF;
    [self.tableView setLoadNewData:^{
        
        [weakSelf fetchData:YES requestType:weakSelf.momentRequestType];
    }];
    
    [self.tableView setLoadMoreData:^{
        
        [weakSelf fetchData:NO requestType:weakSelf.momentRequestType];
    }];
    
    [self.tableView hideFooter];
    
    
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
    [self showLoading];
    WEAKSELF;
    NSMutableDictionary *param = nil;
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
//            url = @"/customer/unknown/lists/";
//            url = @"/customer/active/lists/";
            url = @"/api/customers/";
            
            if (_conditionDic) {
                param = [NSMutableDictionary dictionaryWithDictionary:_conditionDic];
                [param setValue:[NSNumber numberWithInteger:_page] forKey:@"page"];
            }else{
                param = @{@"page": [NSNumber numberWithInteger:_page]};
            }
            
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
            
            if (momentRequestType == weakSelf.momentRequestType) {

                if (![Help canPerformLoadRequest:request.responseObject]) {
                    [weakSelf.tableView endRefreshNoMoreData];
                }else{
                    [weakSelf.tableView showFooter];
                }
                
                if (refresh) {
                    [weakSelf.array removeAllObjects];
                }
            }else{
                if (refresh) {
                    [weakSelf.recommendUserArray removeAllObjects];
                }else{
                    if (weakSelf.recommendUserArray.count == 0) {
                        #pragma mark TODO
                        
                    }
                }
               
            }
            
            [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SCUserInfo *model = [SCUserInfo modelWithDictionary:obj];
                if (momentRequestType == weakSelf.momentRequestType) {
                    [weakSelf.array addObject:model];
                }else{
                    [weakSelf.recommendUserArray addObject:model];
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
                [weakSelf showError:request.error reload:^{
                    [weakSelf fetchData:YES requestType:weakSelf.momentRequestType];
                    [weakSelf fetchData:YES requestType:MomentRequestTypeRecentlyUser];
                }];
            }
            
        }
        
    }];
    [InsNetwork addRequest:request];
}

- (void)heartBeat:(NSIndexPath *)indexPath{
    
#pragma mark TODO 

    // 去聊天
    SCUserInfo *userInfo = self.array[indexPath.row];
    
    NSInteger targetId = userInfo.iD;
    if (targetId == 0) {
        targetId = userInfo.user_id;
    }
    
    // 加关注
    NSDictionary *para = @{@"customer_id": [NSNumber numberWithInteger:targetId],
                           @"status":@(1),
                           };
    NSString *url = @"/customer/following/";
    WEAKSELF;
    POSTRequest *request = [POSTRequest requestWithPath:url parameters:para completionHandler:^(InsRequest *request) {
        
        if (!request.error) {
            [weakSelf.view makeToast:@"心动成功"];
        }else{
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }
        
    }];
    [InsNetwork addRequest:request];
    
}

- (void)chatClick:(NSIndexPath *)indexPath{
    
    
    // 去聊天
    SCUserInfo *userInfo = self.array[indexPath.row];
    
//    NSInteger targetId = userInfo.user_id;
//    if (targetId == 0) {
//        targetId = userInfo.iD;
//    }
    NSInteger targetId = userInfo.iD;
    if (targetId == 0) {
        targetId = userInfo.user_id;
    }
    
    DCIMChatViewController *vc = [[DCIMChatViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId: [NSString stringWithFormat:@"%ld",targetId]];
    vc.isActiveChat = YES;
    vc.title = userInfo.name;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (void)goVipVC:(NSString *)alertTitle{
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = YES;
    //    alert.iconTintColor = [UIColor purpleColor];
    [alert removeTopCircle];
    //    backgroundColor, borderWidth, borderColor, textColor
    alert.buttonFormatBlock = ^NSDictionary *{
        return @{
                 @"backgroundColor":ORANGE,
                 @"textColor":[UIColor whiteColor],
                 };
    };
    
    //Using Block
    WEAKSELF;
    SCLButton *button = [alert addButton:@"前去充值" actionBlock:^(void) {
        VipVC *vc = [VipVC new];
        vc.type = 1;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    
    [alert showNotice:self title:@"VIP 充值" subTitle:@"充值后可以嗨嗨嗨" closeButtonTitle:@"暂不" duration:0.0f]; // Notice
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCUserInfo *model = self.array[indexPath.row];
    MatchV2TableViewCell *cell = (MatchV2TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MatchV2TableViewCell"];
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
//    return 187+(kScreenWidth-20)+30;
    return kScreenWidth-180+40;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SCUserInfo *model = self.array[indexPath.row];
    UserHomepageVC *vc = [UserHomepageVC new];
    vc.userId = model.iD;
    vc.name = model.name;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    
    UIImageView *sideLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 11, 3, 22)];
    sideLineImgView.image = [UIImage imageNamed:@"side_line"];
    [view addSubview:sideLineImgView];
    
    UIButton *mayLike = [UIButton buttonWithType:UIButtonTypeCustom];
    mayLike.frame = CGRectMake(25, 0, 70, 44);
    [mayLike setTitle:@"猜你喜欢" forState:UIControlStateNormal];
    mayLike.titleLabel.font = [UIFont systemFontOfSize:16];
    [mayLike setTitleColor:Black forState:UIControlStateNormal];
//    [mayLike addTarget:self action:@selector(todayRecommendClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:mayLike];
    
    return view;
}

- (void)cellDidClick:(NSIndexPath *)indexPath{
    
    SCUserInfo *model = self.array[indexPath.row];
    UserHomepageVC *vc = [UserHomepageVC new];
    vc.userId = model.iD;
    vc.name = model.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (InsLoadDataTablView *)tableView {
    if ( !_tableView ) {
        _tableView = [[InsLoadDataTablView alloc] initWithFrame:CGRectMake(0, GuaTopHeight, self.view.width, kScreenHeight-GuaTopHeight-UITabBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(_tableView.separatorInset.top, 15, _tableView.separatorInset.bottom, 15)];
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MatchV2TableViewCell" bundle:nil] forCellReuseIdentifier:@"MatchV2TableViewCell"];
        
        _tableView.tableHeaderView = self.tableViewHeaderView;
        
    }
    return _tableView;
}

#pragma mark - LazyLoad


- (UIImageView *)topBarView{
    if (!_topBarView) {
        _topBarView = [UIImageView new];
        _topBarView.backgroundColor = Font_color333;
        _topBarView.frame = CGRectMake(0, 0, self.view.width, GuaTopHeight);
        _topBarView.contentMode = UIViewContentModeScaleAspectFill;
        _topBarView.image = [UIImage imageNamed:@"navbg"];
        _topBarView.layer.masksToBounds = YES;
        _topBarView.userInteractionEnabled = YES;
        [_topBarView addSubview:self.customerBtn];
        [_topBarView addSubview:self.conditionSelect];
#pragma mark TODO 是否删除总用户数显示
//        [_topBarView addSubview:self.userAmount];
//        [_topBarView addSubview:self.unknowUserImg];
    }
    return _topBarView;
}

- (UIButton *)customerBtn{
    if (!_customerBtn) {
        _customerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _customerBtn.frame = CGRectMake(20, 10+StatusBarHeight,  30, 30);
        UIImage *image = [UIImage imageNamed:@"icon_kefu"];
        
        [_customerBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _customerBtn.tintColor = [UIColor whiteColor];
        
//        [_customerBtn setTitle:@"客服" forState:UIControlStateNormal];
//        [_customerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_customerBtn addTarget:self action:@selector(customerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customerBtn;
}

- (UIButton *)conditionSelect{
    if (!_conditionSelect) {
        _conditionSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        _conditionSelect.frame = CGRectMake(kScreenWidth - 50, 10+StatusBarHeight, 30, 30);
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
        _userAmount.titleLabel.font = [UIFont systemFontOfSize:12];
        [_userAmount setTitle:@"1000" forState:UIControlStateNormal];
        [_userAmount setTitleColor:ORANGE forState:UIControlStateNormal];
        [_userAmount addTarget:self action:@selector(userAmountClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userAmount;
}

- (UIImageView *)unknowUserImg{
    if (!_unknowUserImg) {
        _unknowUserImg = [UIImageView new];
        _unknowUserImg.contentMode = UIViewContentModeScaleAspectFit;
        _unknowUserImg.image = [[UIImage imageNamed:@"ic_register"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _unknowUserImg.tintColor = ORANGE;
        _unknowUserImg.frame = CGRectMake(kScreenWidth - 60 - 50 -20-20, 10+StatusBarHeight, 20, 32);
    }
    return _unknowUserImg;
    
}

#pragma mark 客服按钮点击
- (void)customerBtnClick{
#pragma mark TODO
   
    NSInteger targetId = [[AppDelegate sharedDelegate].appConfigModel.kefuid integerValue];

    DCIMChatViewController *vc = [[DCIMChatViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId: [NSString stringWithFormat:@"%ld",targetId]];
    vc.isActiveChat = YES;
    vc.title = @"客服";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)conditionSelectClick{
    LoverConditionVC *vc = [LoverConditionVC new];
    vc.title = @"筛选";
    vc.delegate = self;
    vc.userModel = [SCUserInfo new];
    
#pragma mark TODO 确认传一个初始化的userModel 是不是可以
//    [SCUserCenter sharedCenter].currentUser.userInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectCondition:(NSDictionary *)conditionDic{
    
    _conditionDic = [NSMutableDictionary dictionaryWithDictionary:conditionDic];
    [self fetchData:YES requestType:MomentRequestTypeUnknow];
    
}

- (void)userAmountClick{
    
}

- (void)todayRecommendClick{
    
}

- (void)wantToTopClick{
    
    if (![SCUserCenter sharedCenter].currentUser.userInfo.isOnlineSwitch) {
        
        VipVC *vc = [VipVC new];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    VipVC *vc = [VipVC new];
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
    
//    SCLAlertView *alert = [[SCLAlertView alloc] init];
//    alert.shouldDismissOnTapOutside = YES;
//    //    alert.iconTintColor = [UIColor colorWithHexString:@"ff9f70"];
//    [alert removeTopCircle];
//    //    backgroundColor, borderWidth, borderColor, textColor
//    alert.buttonFormatBlock = ^NSDictionary *{
//        return @{
//                 @"backgroundColor":ORANGE,
//                 @"textColor":[UIColor whiteColor],
//                 };
//    };
//
//    //Using Block
//    WEAKSELF;
//    [alert addButton:@"前去充值" actionBlock:^(void) {
//        VipVC *vc = [VipVC new];
//        vc.type = 2;
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
//
//    [alert showNotice:self title:@"VIP 充值" subTitle:@"充值后可以嗨嗨嗨" closeButtonTitle:@"暂不" duration:0.0f]; // Notice
//
}


- (UIView *)tableViewHeaderView{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,64+ ((kScreenWidth-40)/3.0-16)+10+70+10)];
        _tableViewHeaderView.userInteractionEnabled = YES;
        [_tableViewHeaderView addSubview:self.sideLineImgView];
        
        [_tableViewHeaderView addSubview:self.todayRecommend];
        
        // 是否上线了
//        if ([SCUserCenter sharedCenter].currentUser.userInfo.isOnlineSwitch) {
            [_tableViewHeaderView addSubview:self.wantToTop];
//        }
        
        [_tableViewHeaderView addSubview:self.orangeRightArrowImgView];
        
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
        _collectionView.frame = CGRectMake(0, 64, self.view.frame.size.width, ((kScreenWidth-40)/3.0-16)+10+70);
        _collectionView.showsHorizontalScrollIndicator = NO;        //注册
        [_collectionView registerNib:[UINib nibWithNibName:@"RecommendUserCell" bundle:nil] forCellWithReuseIdentifier:@"RecommendUserCell"];
    }
    return _collectionView;
}

- (UIImageView *)sideLineImgView{
    if (!_sideLineImgView) {
        _sideLineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 11+10, 3, 22)];
        _sideLineImgView.image = [UIImage imageNamed:@"side_line"];
        
    }
    return _sideLineImgView;
}

- (UIButton *)todayRecommend{
    if (!_todayRecommend) {
        _todayRecommend = [UIButton buttonWithType:UIButtonTypeCustom];
        _todayRecommend.frame = CGRectMake(25, 10, 70, 44);
        [_todayRecommend setTitle:@"每日推荐" forState:UIControlStateNormal];
        _todayRecommend.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [_todayRecommend setTitleColor:Black forState:UIControlStateNormal];
        [_todayRecommend addTarget:self action:@selector(todayRecommendClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _todayRecommend;
}

- (UIButton *)wantToTop{
    if (!_wantToTop) {
        _wantToTop = [UIButton buttonWithType:UIButtonTypeCustom];
        _wantToTop.frame = CGRectMake(105, 20+10, 44, 10);
        [_wantToTop setTitle:@"我要置顶" forState:UIControlStateNormal];
        _wantToTop.titleLabel.font = [UIFont systemFontOfSize:10];
        [_wantToTop setTitleColor:m1 forState:UIControlStateNormal];
        [_wantToTop addTarget:self action:@selector(wantToTopClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wantToTop;
}

- (UIImageView *)orangeRightArrowImgView{
    if (!_orangeRightArrowImgView) {
        _orangeRightArrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(150, 20+10, 5, 10)];
        _orangeRightArrowImgView.image = [UIImage imageNamed:@"orange_arrow"];
        _orangeRightArrowImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _orangeRightArrowImgView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return self.recommendUserArray.count > 3 ? 3: self.recommendUserArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendUserCell" forIndexPath:indexPath];
    SCUserInfo *model = self.recommendUserArray[indexPath.row];
    cell.model = model;
    cell.indexPath = indexPath;
    return cell;

}

//这里我为了直观的看出每组的CGSize设置用if 后续我会用简洁的三元表示
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kScreenWidth-40)/3.0, ((kScreenWidth-40)/3.0-10)+10+70);
 
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

    SCUserInfo *model = self.recommendUserArray[indexPath.row];
    UserHomepageVC *vc = [UserHomepageVC new];
    vc.userId = model.iD;
    vc.name = model.name;
    [self.navigationController pushViewController:vc animated:YES];
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
