//
//  DangQianJiFenVC.m
//  SocialContact
//
//  Created by EDZ on 2019/2/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import "DangQianJiFenVC.h"
#import "JiFenCell.h"
#import "UserPointsModel.h"
#import "LiPinTableViewCell.h"

#import "ForumVC.h"

@interface DangQianJiFenVC()<UITableViewDelegate,UITableViewDataSource>

INS_P_STRONG(InsLoadDataTablView *, tableView);

@property(nonatomic,strong) NSMutableArray *array;

@property(nonatomic,assign) NSInteger page;

@end

@implementation DangQianJiFenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    DCIMButton *rightBtn = [[DCIMButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [rightBtn setImage:[[UIImage imageNamed:@"icon_task"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    rightBtn.tintColor = MAIN_COLOR;
    
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
}

- (void)rightBtnAction{
    
    ForumVC *vc = [ForumVC new];
    vc.forumVCType = ForumVCTypeNoticeOrNearBy;
    vc.momentRequestType = MomentRequestTypeJiFenList;
    vc.momentUIType = MomentUITypeNotice;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)setUpUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF;
    [self.tableView setLoadNewData:^{
        [weakSelf dangQianJiFen:YES];
    }];
    
    [self.tableView setLoadMoreData:^{
        [weakSelf dangQianJiFen:NO];
    }];
    
    [self showLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dangQianJiFen:YES];
    });
    
    
    
}

- (void)dangQianJiFen:(BOOL)refresh{
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
            
            
            if ( resultArray && resultArray.count > 0 ) {
                if (resultArray.count == 10) {
                    [weakSelf.tableView showFooter];
                } else {
                    [weakSelf.tableView hideFooter];
                }
            } else {
                //                [weakSelf.tableView hideFooter];
            }
            
            if (refresh) {
                [weakSelf.array removeAllObjects];
            }else{
                if (resultArray.count < 10) {
                    [weakSelf.tableView endRefreshNoMoreData];
                }
            }

            [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf.array addObject:[UserPointsModel modelWithDictionary:obj]];
                
            }];
            [weakSelf.tableView reloadData];
            
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ) {
        
        JiFenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JiFenCell"];
//        cell.avatar = self;
//        cell.name.text = self.userModel;
//        cell.jifen.text =
        
        return cell;
        
    }else if (indexPath.section == 1 ) {
        
        LiPinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiPinTableViewCell"];
        
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
            return 1;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 116;
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
    return 10.0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
        
    }
    return _tableView;
}
@end
