//
//  DangQianJiFenVC.m
//  SocialContact
//
//  Created by EDZ on 2019/2/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import "DangQianJiFenVC.h"
#import "JiFenCell.h"
#import "LiPinTableViewCell.h"

#import "ForumVC.h"
#import "AskWeChatOrYueTaVC.h"

#import "UserPointsModel.h"

@interface DangQianJiFenVC()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

INS_P_STRONG(InsLoadDataTablView *, tableView);

@property(nonatomic,strong) NSMutableArray *array;

@property(nonatomic,assign) NSInteger page;

INS_P_ASSIGN(NSInteger, showEmpty);

@end

@implementation DangQianJiFenVC

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"base_data_empty"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    
    return _showEmpty;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    if (self.tableView.tableHeaderView) {
        CGFloat height = self.tableView.tableHeaderView.height - (kScreenHeight-GuaTopHeight)/2.0;
        return -height + 100;
    }else{
        return -GuaTopHeight;
    }
    
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    
    [self fetchData:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([SCUserCenter sharedCenter].currentUser.userInfo.isOnlineSwitch) {
        self.title = @"当前积分";
        UIBarButtonItem *pointsStore = [[UIBarButtonItem alloc]initWithTitle:@"积分商城" style:UIBarButtonItemStylePlain target:self action:@selector(goPointsStore)];
        self.navigationItem.rightBarButtonItem = pointsStore;
    }else{
        self.title = @"当前记录";
    }
    
    [self setUpUI];
    
   
    
//    DCIMButton *rightBtn = [[DCIMButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
//    [rightBtn setImage:[UIImage imageNamed:@"icon_task"] forState:UIControlStateNormal];
//    rightBtn.tintColor = MAIN_COLOR;
//
//    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItems = @[pointsStore,rightBtnItem];
    
    
    
}

- (void)goPointsStore{
    
    AskWeChatOrYueTaVC *vc = [AskWeChatOrYueTaVC new];
    vc.title = @"积分商城";
    vc.type = 3;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightBtnAction{
    
    
    AskWeChatOrYueTaVC *vc = [AskWeChatOrYueTaVC new];
    vc.title = @"积分商城";
    vc.type = 3;
    [self.navigationController pushViewController:vc animated:YES];
    
//    ForumVC *vc = [ForumVC new];
//    vc.title = @"积分列表";
//    vc.forumVCType = ForumVCTypeNoticeOrNearBy;
//    vc.momentRequestType = MomentRequestTypeJiFenList;
//    vc.momentUIType = MomentUITypeNotice;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)setUpUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.array = [NSMutableArray array];
    
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF;
    [self.tableView setLoadNewData:^{
        [weakSelf fetchData:YES];
    }];
    
    [self.tableView setLoadMoreData:^{
        [weakSelf fetchData:NO];
    }];
    
    [self.tableView hideFooter];
        
    [self.tableView beginRefresh];
    
}

- (void)fetchData:(BOOL)refresh{
    
    [self showLoading];
//    /api/points/
    if (refresh) {
        _page = 1;
    }else{
        _page ++;
    }
    WEAKSELF;
    NSDictionary *param = @{@"page": [NSNumber numberWithInteger:_page]};
    GETRequest *request = [GETRequest requestWithPath:@"/api/points/" parameters:param completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        [weakSelf.tableView endRefresh];
        
        if (!request.error) {
            
            NSMutableArray *resultArray = [NSMutableArray array];
            
            resultArray = request.responseObject[@"data"][@"results"];
            
//            if (resultArray.count < 10 ) {
            if (![Help canPerformLoadRequest:request.responseObject]) {
                [weakSelf.tableView endRefreshNoMoreData];
            }else{
                [weakSelf.tableView showFooter];
            }
            
            if (refresh) {
                [weakSelf.array removeAllObjects];
            }

            [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf.array addObject:[UserPointsModel modelWithDictionary:obj]];
                
            }];
            [weakSelf.tableView reloadData];
            
            if (weakSelf.array.count == 0) {
                weakSelf.showEmpty = YES;
            }else{
                weakSelf.showEmpty = NO;
            }
            
            [weakSelf.tableView reloadEmptyDataSet];
        }else{
            
            if ( weakSelf.page > 1 ) {
                weakSelf.page --;
            }
            
            if (weakSelf.array.count > 0) {
                [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
                [SVProgressHUD dismissWithDelay:1.5];
            } else {
                [weakSelf showError:request.error reload:^{
                    [weakSelf fetchData:YES];
                }];
            }
            
        }
        
    }];
    [InsNetwork addRequest:request];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ) {
        
        JiFenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JiFenCell"];
        UserPointsModel *model = self.array[0];
        
        [cell.avatar sc_setImgWithUrl:[SCUserCenter sharedCenter].currentUser.userInfo.avatar_url placeholderImg:@""];
        cell.name.text = [SCUserCenter sharedCenter].currentUser.userInfo.name;
        cell.jifen.text = [NSString stringWithFormat:@"%ld",model.total_left];
        return cell;
        
    }else if (indexPath.section == 1 ) {
        
        LiPinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiPinTableViewCell"];
        cell.model = self.array[indexPath.row];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
        }
            break;
        case 1:
        {
        }
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.array.count>0 ? 1 : 0;
            break;
        case 1:
            return self.array.count;
            break;
        default:
            break;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 160;
    }
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return 50.0;
    }
    return 10.0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        sectionView.backgroundColor = BackGroundColor;
        [view addSubview:sectionView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreenWidth, 40)];
        label.font = [UIFont fontWithName:@"Heiti SC" size:15];
        label.text = @"积分明细";
        label.textColor = Font_color333;
        [view addSubview:label];
        
        return view;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = BackGroundColor;
    return view;
}

- (InsLoadDataTablView *)tableView {
    if ( !_tableView ) {
        _tableView = [[InsLoadDataTablView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -  GuaTopHeight ) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 15, _tableView.separatorInset.bottom, 15);
        _tableView.separatorColor = Line;
        _tableView.rowHeight = 55;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"LiPinTableViewCell" bundle:nil] forCellReuseIdentifier:@"LiPinTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"JiFenCell" bundle:nil] forCellReuseIdentifier:@"JiFenCell"];
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}
@end
