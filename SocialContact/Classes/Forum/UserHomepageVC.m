//
//  UserHomepageVC.m
//  SocialContact
//
//  Created by EDZ on 2019/1/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "UserHomepageVC.h"

#import "ForumVC.h"

#import "UserInfoHomePageCell.h"
#import "VipStatusCell.h"
#import "UserImagesCell.h"
#import "SelectConditionCell.h"
#import "MeListTableViewCell.h"

@interface UserHomepageVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,VipStatusCellDelegate>

@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;

@property(nonatomic,strong)SCUserInfo *userInfo;

@property(nonatomic,strong) InsLoadDataTablView *tableView;

//@property(nonatomic,strong) NSMutableArray *momentListArray;

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
    
   
    
    @weakify(self);
    [self.tableView setLoadNewData:^{
        @normalize(self);
        [self fetchData];
    }];
    
    
    [self.tableView hideFooter];
    [self showLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchData];
    });
    
}

- (void)fetchData{
    
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:[NSString stringWithFormat:@"customer/%ld/",_userId] parameters:nil completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        
        if (!request.error) {
            if (request.responseObject[@"data"]) {
                weakSelf.userInfo = [SCUserInfo modelWithDictionary:request.responseObject[@"data"]];
                [weakSelf refresh];
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
        return cell;
        
    }else if (indexPath.section == 4) {
        
        MeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeListTableViewCell"];
        cell.titleLB.text = @"个人动态";
        cell.leftImgV.image = [UIImage imageNamed:@"main_tab_item_icon2_selected"];
        return cell;
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
        
        return 1;
        
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        return 200;
        
    }else if (indexPath.section == 1) {
        
        return 110;
        
    }else if (indexPath.section == 2) {
        
        return 260;
        
    }else if (indexPath.section == 3) {
        
        return 100;
        
    }else if (indexPath.section == 4) {
        
        return 60;
        
    }
    return 0.00001;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 4) {
        ForumVC *vc = [ForumVC new];
        vc.momentUIType = MomentUITypeList;
        vc.momentRequestType = MomentRequestTypeUserList;
        vc.forumVCType = ForumVCTypeMoment;
        vc.uesrInfo = self.userInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = BackGroundColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (InsLoadDataTablView *)tableView {
    if ( !_tableView ) {
        CGRect rect = CGRectMake(0, 0, self.view.width, kScreenHeight-GuaTopHeight);
        _tableView = [[InsLoadDataTablView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = Line;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(_tableView.separatorInset.top, 15, _tableView.separatorInset.bottom, 15)];
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerNib:[UINib nibWithNibName:@"VipStatusCell" bundle:nil] forCellReuseIdentifier:@"VipStatusCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"UserImagesCell" bundle:nil] forCellReuseIdentifier:@"UserImagesCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"UserInfoHomePageCell" bundle:nil] forCellReuseIdentifier:@"UserInfoHomePageCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SelectConditionCell" bundle:nil] forCellReuseIdentifier:@"SelectConditionCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MeListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MeListTableViewCell"];
        
    }
    return _tableView;
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
