//
//  InviteFriendVC.m
//  SocialContact
//
//  Created by EDZ on 2019/2/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import "InviteFriendVC.h"

#import "InviteListTableViewCell.h"
#import "InviteFriendHeaderView.h"

#import "InviteFriendModel.h"

#import "InviteInfoModel.h"

#import "CashingVC.h"

#import "WXApiRequestHandler.h"

@interface InviteFriendVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

INS_P_STRONG(InviteFriendHeaderView *,inviteFriendHeaderView);

INS_P_STRONG(InsLoadDataTablView *, tableView);
INS_P_STRONG(SCUserInfo *, userModel);
INS_P_STRONG(NSMutableArray *, array);

INS_P_ASSIGN(NSInteger, page);

INS_P_ASSIGN(NSInteger, showEmpty);

INS_P_STRONG(InviteInfoModel *, inviteInfoModel);

@end

@implementation InviteFriendVC

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

- (InviteFriendHeaderView *)inviteFriendHeaderView{
    if (!_inviteFriendHeaderView) {
        _inviteFriendHeaderView =  [[NSBundle mainBundle]loadNibNamed:@"InviteFriendHeaderView" owner:nil options:nil][0];
        [_inviteFriendHeaderView.cashBtn addTarget:self action:@selector(cashBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteFriendHeaderView;
}

- (void)cashBtnClicked{
    
    CashingVC *vc = [CashingVC new];
    vc.infoModel = self.inviteInfoModel;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"邀请好友" style:UIBarButtonItemStylePlain target:self action:@selector(inviteFriend)];
}

- (void)inviteFriend{
    
    if ([NSString ins_String:[SCUserCenter sharedCenter].currentUser.userInfo.invitecode]) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [SCUserCenter sharedCenter].currentUser.userInfo.invitecode;
        
//        [SVProgressHUD showImage:AlertSuccessImage status:@"邀请码已复制"];
//        [SVProgressHUD dismissWithDelay:2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self fenXiangRuanJian:[SCUserCenter sharedCenter].currentUser.userInfo.invitecode];
        });
        
    }else{
        WEAKSELF;
//        /api/customers/invitecode/
        GETRequest *request = [GETRequest requestWithPath:@"/api/customers/invitecode/" parameters:nil completionHandler:^(InsRequest *request) {
            
            if (request.error) {
                [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
                [SVProgressHUD dismissWithDelay:1.5];
            }else{
                
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = request.responseObject[@"data"][@"invitecode"];
                
//                [SVProgressHUD showImage:AlertSuccessImage status:@"邀请码已复制"];
//                [SVProgressHUD dismissWithDelay:2];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf fenXiangRuanJian:request.responseObject[@"data"][@"invitecode"]];
                });
                
            }
            
        }];
        [InsNetwork addRequest:request];
    }
    
}

- (void)fenXiangRuanJian:(NSString *)invitecode{
    
    
    //    https://www.handanxiaohongniang.com/?invitecode=PQXWVFUR&from=groupmessage
    NSString *shareUrl = [NSString stringWithFormat:@"%@?invitecode=%@&from=groupmessage",kSCShareLinkURL,invitecode];
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"邀请好友注册领取现金奖励" cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            [WXApiRequestHandler sendLinkURL:shareUrl TagName:@"邯郸小红娘" Title:kSCShareTitle Description:kSCShareDes ThumbImage:[UIImage imageNamed:@"shareIcon"] InScene:WXSceneSession];
        }else if (buttonIndex == 2) {
            
            [WXApiRequestHandler sendLinkURL:shareUrl TagName:@"邯郸小红娘" Title:kSCShareTitle Description:kSCShareDes ThumbImage:[UIImage imageNamed:@"shareIcon"] InScene:WXSceneTimeline];
        }else if (buttonIndex == 3) {
            
            [WXApiRequestHandler sendLinkURL:shareUrl TagName:@"邯郸小红娘" Title:kSCShareTitle Description:kSCShareDes ThumbImage:[UIImage imageNamed:@"shareIcon"] InScene:WXSceneFavorite];
        }
        
        
    } otherButtonTitles:@"微信好友",@"微信朋友圈",@"微信收藏", nil];
    [sheet show];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
}



- (void)setUpUI{
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.inviteFriendHeaderView;
    
    
    self.array = [NSMutableArray array];
    
    WEAKSELF;
    [self.tableView setLoadNewData:^{
        
        [weakSelf fetchData:YES];
        [weakSelf cashInfo];
    }];
    
    [self.tableView setLoadMoreData:^{
        
        [weakSelf fetchData:NO];
        
    }];
    
    [self.tableView hideFooter];
    
    
    [self.tableView beginRefresh];
    
}


- (void)cashInfo{
    
//    /api/withdraw/detail_info/
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/api/withdraw/detail_info/" parameters:nil completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
            
        }else{
         
            weakSelf.inviteInfoModel = [InviteInfoModel modelWithDictionary:request.responseObject[@"data"]];
            weakSelf.inviteFriendHeaderView.inviteInfoModel = weakSelf.inviteInfoModel;
            
        }
        
    }];
    [InsNetwork addRequest:request];
}


- (void)fetchData:(BOOL)refresh{
    
//    邀请记录
    [self showLoading];
    if (refresh) {
        _page = 1;
    }else{
        _page ++;
    }
    
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/api/invite-records/" parameters:nil completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        [weakSelf.tableView endRefresh];
        
        if (request.error) {
            
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
            
        }else{
            
            NSMutableArray *resultArray = request.responseObject[@"data"][@"results"];
            
            if (![Help canPerformLoadRequest:request.responseObject]) {
                [weakSelf.tableView endRefreshNoMoreData];
            }else{
                [weakSelf.tableView showFooter];
            }
            
            if (refresh) {
                [weakSelf.array removeAllObjects];
            }
            
            [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf.array addObject:[InviteFriendModel modelWithDictionary:obj]];
                
            }];
            [weakSelf.tableView reloadData];
            
            if (weakSelf.array.count == 0) {
                weakSelf.showEmpty = YES;
            }else{
                weakSelf.showEmpty = NO;
            }
            
            [weakSelf.tableView reloadEmptyDataSet];
        }
        
    }];
    [InsNetwork addRequest:request];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InviteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell"];
    InviteFriendModel *model = self.array[indexPath.row];
    cell.model = model;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.000001;
}

- (InsLoadDataTablView *)tableView {
    if ( !_tableView ) {
        _tableView = [[InsLoadDataTablView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - GuaTopHeight) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 15, _tableView.separatorInset.bottom, 15);
        _tableView.separatorColor = Line;
        _tableView.rowHeight = 55;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerNib:[UINib nibWithNibName:@"InviteListTableViewCell" bundle:nil] forCellReuseIdentifier:@"InviteListTableViewCell"];
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}



@end
