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


#define NAVBAR_COLORCHANGE_POINT -1*kScreenWidth
#define NAV_HEIGHT GuaTopHeight
#define IMAGE_HEIGHT kScreenWidth
#define SCROLL_DOWN_LIMIT 0
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

@interface UserHomepageVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,VipStatusCellDelegate>

@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;

@property(nonatomic,strong)SCUserInfo *userInfo;

//@property(nonatomic,strong) BottomToolView   *bottomToolView;

@property(nonatomic,strong) UIButton *chatBtn;
@property(nonatomic,strong) UIButton *guanZhuBtn;


@property(nonatomic,strong) InsLoadDataTablView *tableView;

//@property(nonatomic,strong) NSMutableArray *momentListArray;

@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIButton *moreBtn;

@end

@implementation UserHomepageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self setUpUI];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置状态栏背景字体颜色
    //(图片设置会导致全局白字,下面这句可以在个别界面设置成黑字)
    [self.cycleScrollView adjustWhenControllerViewWillAppera];
    
}

- (UIButton *)chatBtn{
    if (!_chatBtn) {
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat top = kScreenHeight  - 50;
        if (IS_IPHONEX) {
            top -= iPhoneXVirtualHomeHeight;
        }
        _chatBtn.frame = CGRectMake(0, top, 0.4*kScreenWidth-10, 44);
        _chatBtn.centerX = 0.1*kScreenWidth+(0.2*kScreenWidth-5);
        _chatBtn.layer.cornerRadius = 22.f;
        _chatBtn.layer.masksToBounds = YES;
        [_chatBtn setTitle:@"  会话" forState:UIControlStateNormal];
        _chatBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_chatBtn setImage:[UIImage imageNamed:@"ic_chat_white"] forState:UIControlStateNormal];
        [_chatBtn setBackgroundImage:[UIImage imageWithColor:BLUE] forState:UIControlStateNormal];
        [_chatBtn addTarget:self action:@selector(chatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}

- (void)chatBtnClick{
    
    [self showLoading];
    
    WEAKSELF;
    [Help vipIsExpired:^(BOOL expired) {
        
        [weakSelf hideLoading];
        
        if (expired) {
            VipVC *vc = [VipVC new];
            vc.type = 1;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }else{
            if (weakSelf.userInfo) {
                DCIMChatViewController *vc = [[DCIMChatViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId: [NSString stringWithFormat:@"%ld",weakSelf.userInfo.userId]];
                vc.title = weakSelf.userInfo.name;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
        
        
    } topIsExpired:nil];
    
}

- (UIButton *)guanZhuBtn{
    if (!_guanZhuBtn) {
        _guanZhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat top = kScreenHeight -50;
        if (IS_IPHONEX) {
            top -= iPhoneXVirtualHomeHeight;
        }
        _guanZhuBtn.frame = CGRectMake(0, top, 0.4*kScreenWidth-10, 44);
        _guanZhuBtn.centerX = kScreenWidth - 0.1*kScreenWidth - (0.2*kScreenWidth-5);
        _guanZhuBtn.layer.cornerRadius = 22.f;
        _guanZhuBtn.layer.masksToBounds = YES;
        _guanZhuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_guanZhuBtn setTitle:@"  加关注" forState:UIControlStateNormal];
        [_guanZhuBtn setImage:[UIImage imageNamed:@"ic_guanzhu_white"] forState:UIControlStateNormal];
        [_guanZhuBtn setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
        [_guanZhuBtn addTarget:self action:@selector(guanZhuClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _guanZhuBtn;
}

- (void)guanZhuClick{
    
//    /customer/following/
    //关注状态， -1：未关注， 0：屏蔽， 1：正在关注， 2：互相关注
    NSInteger targetStatus = self.userInfo.relation_status;
    switch (self.userInfo.relation_status) {
            
        case -1:
            // 去关注
            targetStatus = 1;
            break;
        case 0:
            // 解除屏蔽
            targetStatus = -1;
            break;
        case 1:
            // 取消关注
            targetStatus = -1;
            break;
        case 2:
            // 取消关注
            targetStatus = -1;
            break;
            
        default:
            break;
    }
    
    NSDictionary *para = @{@"customer_id": [NSNumber numberWithInteger:self.userInfo.iD],
                           @"status":[NSNumber numberWithInteger:targetStatus],
                           };
    NSString *url = @"/customer/following/";
    WEAKSELF;
    if (targetStatus == 1 || targetStatus == 0) {
        POSTRequest *request = [POSTRequest requestWithPath:url parameters:para completionHandler:^(InsRequest *request) {
            
            if (!request.error) {
                [weakSelf.view makeToast:request.responseObject[@"msg"]?:@"操作成功"];
                weakSelf.userInfo.relation_status = targetStatus;
                [weakSelf refresh];
            }else{
                
            }
            
        }];
        [InsNetwork addRequest:request];
    }else{
        DELETERequest *request = [DELETERequest requestWithPath:url parameters:para completionHandler:^(InsRequest *request) {
            
            if (!request.error) {
                [weakSelf.view makeToast:request.responseObject[@"msg"]?:@"操作成功"];
                weakSelf.userInfo.relation_status = targetStatus;
                [weakSelf refresh];
            }else{
                
            }
            
        }];
        [InsNetwork addRequest:request];
    }
    
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (IS_IPHONEX) {
            _backBtn.frame = CGRectMake(0, StatusBarHeight, 44, 44);
        }else{
            _backBtn.frame = CGRectMake(0, 0, 44, 44);
        }
        
        [_backBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
       
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IS_IPHONEX) {
            _moreBtn.frame = CGRectMake(kScreenWidth - 44, StatusBarHeight, 44, 44);
        }else{
            _moreBtn.frame = CGRectMake(kScreenWidth - 44, 0, 44, 44);
        }
        
        [_moreBtn setImage:[UIImage imageNamed:@"ic_person_more"] forState:UIControlStateNormal];
        
        [_moreBtn addTarget:self action:@selector(shezhiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (void)shezhiBtnClick{
    
}

- (void)setUpUI{
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.cycleScrollView;
    // 自己才显示
    if ([SCUserCenter sharedCenter].currentUser.userInfo.iD != self.userInfo.iD) {
        [self.view addSubview:self.chatBtn];
        [self.view addSubview:self.guanZhuBtn];
    }
    
    [self.cycleScrollView addSubview:self.backBtn];
    [self.cycleScrollView addSubview:self.moreBtn];
    
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
        [weakSelf.tableView endRefresh];
        
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
    
//    1.
    self.cycleScrollView.imageURLStringsGroup = self.userInfo.images;
    
//    2.关系
//    关注状态， -1：未关注， 0：屏蔽， 1：正在关注， 2：互相关注
    switch (self.userInfo.relation_status) {
        case 0:
            {
                [_guanZhuBtn setTitle:@"  已屏蔽" forState:UIControlStateNormal];
                [_guanZhuBtn setImage:[UIImage imageNamed:@"ic_guanzhu_white"] forState:UIControlStateNormal];
            }
            break;
        case 1:
        {
            [_guanZhuBtn setTitle:@"  已关注" forState:UIControlStateNormal];
            [_guanZhuBtn setImage:[UIImage imageNamed:@"ic_guanzhu_white"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [_guanZhuBtn setTitle:@"  互相关注" forState:UIControlStateNormal];
            [_guanZhuBtn setImage:[UIImage imageNamed:@"ic_guanzhu_white"] forState:UIControlStateNormal];
        }
            break;
            
        default:
        {
            [_guanZhuBtn setTitle:@"  加关注" forState:UIControlStateNormal];
            [_guanZhuBtn setImage:[UIImage imageNamed:@"ic_guanzhu_white"] forState:UIControlStateNormal];
        }
            break;
    }
    
    
//    3.
    [self.tableView reloadData];
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
        CGRect rect = CGRectMake(0, 0, self.view.width, kScreenHeight);
        _tableView = [[InsLoadDataTablView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.separatorColor = Line;
        // 自己才显示
        if ([SCUserCenter sharedCenter].currentUser.userInfo.iD == self.userInfo.iD) {
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        }
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
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
