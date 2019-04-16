//
//  BottlesVC.m
//  
//
//  Created by EDZ on 2019/2/25.
//

#import "BottlesVC.h"
#import "BottleModel.h"
#import "BottleCell.h"
#import "DCIMChatViewController.h"

@interface BottlesVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong) InsLoadDataTablView *tableView;

@property(nonatomic,strong) NSMutableArray *array;

INS_P_ASSIGN(NSInteger, page);

INS_P_ASSIGN(NSInteger, showEmpty);

@end

@implementation BottlesVC

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
    [self setUpUI];
}

- (void)setUpUI{
    [self.view addSubview:self.tableView];
    self.array = [NSMutableArray array];
    
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
    WEAKSELF;
    NSDictionary *param = nil;
    NSString *url ;
    if (self.type == 1) {
        url =  @"/api/bottles-picked/";
    }else{
        url =  @"/api/bottles-mine/";
    }
    if (refresh) {
        _page = 1;
    }else{
        _page ++;
    }
    param = @{@"page": [NSNumber numberWithInteger:_page]};
    
    GETRequest *request = [GETRequest requestWithPath:url parameters:param completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        [weakSelf.tableView endRefresh];
        
        if (!request.error) {
            
            NSArray *resultArray = request.responseObject[@"data"][@"results"];
            
            if ( resultArray && resultArray.count > 0 ) {
                
//                if (resultArray.count < 10) {
                if (![Help canPerformLoadRequest:request.responseObject]) {
                    [weakSelf.tableView endRefreshNoMoreData];
                }else{
                    [weakSelf.tableView showFooter];
                }
                
                if (refresh) {
                    [weakSelf.array removeAllObjects];
                }
                
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    BottleModel *model = [BottleModel modelWithDictionary:obj];
                    [weakSelf.array addObject:model];
                    
                }];
                
                [weakSelf.tableView reloadData];
                
                if (weakSelf.array.count == 0) {
                    weakSelf.showEmpty = YES;
                }else{
                    weakSelf.showEmpty = NO;
                }
                
                [weakSelf.tableView reloadEmptyDataSet];
            }
        }else{
            if ( weakSelf.page > 1 ) {
                weakSelf.page --;
            }
            
            if (weakSelf.array.count > 0 || weakSelf.array.count > 0) {
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
    BottleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BottleCell"];
    BottleModel *model = self.array[indexPath.row];
    cell.model = model;
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.type == 2) {
        return;
    }
    
    // 进入聊天界面
    BottleModel *model = self.array[indexPath.row];
    DCIMChatViewController *vc = [[DCIMChatViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId: [NSString stringWithFormat:@"%ld",model.customer.iD]];
    vc.title = model.customer.name;
    if (self.fatherVC) {
        [self.fatherVC.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (InsLoadDataTablView *)tableView {
    if ( !_tableView ) {
        CGRect rect;
        
        if (_height) {
            rect = CGRectMake(0, 0, self.view.width, _height);
        }else{
            rect = CGRectMake(0, 0, self.view.width, kScreenHeight-GuaTopHeight);
        }
        
        _tableView = [[InsLoadDataTablView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = Line;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(_tableView.separatorInset.top, 15, _tableView.separatorInset.bottom, 15)];
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerNib:[UINib nibWithNibName:@"BottleCell" bundle:nil] forCellReuseIdentifier:@"BottleCell"];
        
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
    }
    return _tableView;
}



@end
