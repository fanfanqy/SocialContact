//
//  UserHomepageVC.m
//  SocialContact
//
//  Created by EDZ on 2019/1/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "UserHomepageVC.h"

#import "UserInfoHomePageCell.h"
#import "VipStatusCell.h"
#import "UserImagesCell.h"
#import "SelectConditionCell.h"
#import "NewDynamicsTableViewCell.h"

@interface UserHomepageVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,VipStatusCellDelegate>

@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;

@property(nonatomic,strong)SCUserInfo *userInfo;

@property(nonatomic,strong) InsLoadDataTablView *tableView;

@property(nonatomic,strong) NSMutableArray *momentListArray;

@property(nonatomic,assign) NSInteger page;

@end

@implementation UserHomepageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI{
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.cycleScrollView;
    
    //
    self.momentListArray = [NSMutableArray array];
    
    @weakify(self);
    [self.tableView setLoadNewData:^{
        @normalize(self);
        [self fetchData];
    }];
    
    [self.tableView setLoadMoreData:^{
        @normalize(self);
        [self fetchMomentList:NO];
    }];
    
//    [self.tableView hideFooter];
    [self showLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchData];
        [self fetchMomentList:YES];
    });
    
}

- (void)fetchMomentList:(BOOL)refresh{
    
}

- (void)fetchData{
    
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:[NSString stringWithFormat:@"customer/%ld/",_userId] parameters:nil completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        
        if (!request.error) {
            if (request.responseObject[@"data"]) {
                weakSelf.userInfo = [SCUserInfo modelWithDictionary:request.responseObject[@"data"]];
            }else{
                [weakSelf.view makeToast:request.responseObject[@"msg"]];
            }
        }else{
            if (weakSelf.userInfo) {
                [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
                [SVProgressHUD dismissWithDelay:1.5];
            } else {
                [weakSelf showError:request.error reload:nil];
            }
        }
        
    }];
    [InsNetwork addRequest:request];
    
}

- (void)refresh{
    self.cycleScrollView.imageURLStringsGroup = self.userInfo.images;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cycleScrollView adjustWhenControllerViewWillAppera];
}

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,  kScreenWidth, kScreenWidth)  delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        
        
//        //采用网络图片
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
//        });
    }
    return _cycleScrollView;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        UserInfoHomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoHomePageCell"];
        cell.userInfo = self.userInfo;
        
        return cell;
        
    }else if (indexPath.section == 1) {
        
        VipStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipStatusCell"];
        cell.delegate = self;
        
        return cell;
        
    }else if (indexPath.section == 2) {
        
        SelectConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectConditionCell"];
        cell.userInfo = self.userInfo;
        return cell;
        
    }else if (indexPath.section == 3) {
        
        UserImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserImagesCell"];
        cell.userInfo = self.userInfo;
        
    }else if (indexPath.section == 4) {
        
        
        
    }
    
    return nil;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
        
    }else if (section == 1) {
       return 1;
        
    }else if (section == 2) {
        return 1;
        
    }else if (section == 3) {
        return 1;
        
    }else if (section == 4) {
        
        return self.momentListArray.count;
        
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        return 150;
        
    }else if (indexPath.section == 1) {
        
        return 100;
        
    }else if (indexPath.section == 2) {
        
        return 200;
        
    }else if (indexPath.section == 3) {
        
        return 100;
        
    }else if (indexPath.section == 4) {
        
        return 100;
        
    }
    return 0.00001;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = BackGroundColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
