//
//  MineVC.m
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "MineVC.h"

#import "SCUserInfo.h"

#import "MeListTableViewCell.h"
#import "UserInfoHomePageTableViewCell.h"
#import "MeV2TableViewCell.h"
#import "GFLCell.h"

#import "GeRenZiLiaoVC.h"
#import "LoverConditionVC.h"

#import "ForumVC.h"
#import "DangQianJiFenVC.h"
#import "SettingVC.h"

#import "FeedBackVC.h"

#import "AuthenticationVC.h"
#import "AskWeChatOrYueTaVC.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"

#import "VipVC.h"

@interface MineVC ()<UITableViewDelegate,UITableViewDataSource,UserInfoTableViewCellDelegate,MeV2TableViewCellDelegate,WXApiManagerDelegate,GFLCellDelegate>


INS_P_STRONG(InsLoadDataTablView *, tableView);

// 1.52 : h/w
INS_P_STRONG(UIView *, headerView);

INS_P_STRONG(GFLCell *, gflCell);

INS_P_STRONG(SCUserInfo *, userModel);

INS_P_ASSIGN(NSInteger, askWeChatUnreadCount);

INS_P_ASSIGN(NSInteger, lookMeUnreadCount);

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [WXApiManager sharedManager].delegate = self;
    
    self.fd_prefersNavigationBarHidden = YES;
    [self setUpUI];
    
    
}

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response
{
    [SVProgressHUD showImage:AlertSuccessImage status:@"分享成功"];
    [SVProgressHUD dismissWithDelay:1.5];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    
    self.userModel = [SCUserCenter sharedCenter].currentUser.userInfo;
    // 修改个人信息后刷新界面
    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}

- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/1.52)];
        _headerView.backgroundColor = [UIColor clearColor];
        
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/1.52)];
//        imgView.contentMode = UIViewContentModeScaleAspectFill;
//        imgView.image = [UIImage imageNamed:@"me_headbg"];
//        [_headerView addSubview:imgView];
        _headerView.userInteractionEnabled = YES;
        
        [_headerView.layer addSublayer:[CAGradientLayer createGradientLayerOnView:_headerView fromColor:@"Fd6767" toColor:@"ff9f70" startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)]];

//        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        settingBtn.frame = CGRectMake(kScreenWidth-50, StatusBarHeight, 44, 44);
//        [settingBtn setImage:[UIImage imageNamed:@"ic_setting"] forState:UIControlStateNormal];
//        [settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [_headerView addSubview:settingBtn];
    }
    return _headerView;
}

- (void)settingBtnClick{
    SettingVC *vc = [SettingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setUpUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.tableView];
    
//    self.tableView.tableHeaderView = self.headerView;
    
    WEAKSELF;
    [self.tableView setLoadNewData:^{
        [weakSelf demandsUnread];
        [weakSelf getUserInfo];
        [weakSelf lookMeUnreadCountRequest];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getUserInfo];
        [self demandsUnread];
        [self lookMeUnreadCountRequest];
    });
    
}

- (void)getUserInfo{

    [self showLoading];
    WEAKSELF;
    [SCUserCenter getSelfInformationAndUpdateDBWithUserId:[SCUserCenter sharedCenter].currentUser.userInfo.iD completion:^(id  _Nonnull responseObj, BOOL succeed, NSError * _Nonnull error) {
        [weakSelf hideLoading];
        [weakSelf.tableView endRefresh];
        weakSelf.userModel = [SCUserInfo modelWithDictionary:responseObj[@"data"]];
        [weakSelf.tableView reloadData];
        
    }];
    
}

- (void)lookMeUnreadCountRequest{
//    /stats/records/unread/
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/stats/records/unread/" parameters:nil completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            
        }else{
            weakSelf.lookMeUnreadCount = [request.responseObject[@"data"][@"total"] integerValue];
            [weakSelf.tableView reloadData];
        }
        
    }];
    [InsNetwork addRequest:request];
}

- (void)demandsUnread{
    
//    /api/demands/unread/
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/api/demands/unread/" parameters:nil completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            
        }else{
            weakSelf.askWeChatUnreadCount = [request.responseObject[@"data"][@"count"] integerValue];
            [weakSelf.tableView reloadData];
        }
        
    }];
    [InsNetwork addRequest:request];
    
}

- (void)gerenziliaoClicked{
    [self geRenZiLiao];
}

- (void)zeoubiaozhunClicked{
    [self zeOuBiaoZhun];
}

- (void)woyaorenzhenged{
    [self woYaoRenZheng];
}

- (void)shuikanguowoClicked{
    [self shuiKanGuoWo];
}

- (void)fenxiangRuanjianClicked{
    [self fenXiangRuanJian];
}

- (void)dangqianJifenClicked{
    [self dangQianJiFen];
}

- (void)shoudaoWeixinClicked{
    [self jiaoHuanWeiXin];
}

- (void)geRenZiLiao{
    GeRenZiLiaoVC *vc = [GeRenZiLiaoVC new];
    vc.userModel = self.userModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)zeOuBiaoZhun{
    LoverConditionVC *vc = [LoverConditionVC new];
    vc.userModel = self.userModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)woYaoRenZheng{
    
    if (self.userModel.is_idcard_verified) {
        [SVProgressHUD showImage:AlertErrorImage status:@"您已完成实名认证"];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }

    AuthenticationVC *vc = [[AuthenticationVC alloc]initWithNibName:@"AuthenticationVC" bundle:nil];
    vc.userModel = self.userModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shuiKanGuoWo{
   
}

- (void)fenXiangRuanJian{
    
    if ([NSString ins_String:[SCUserCenter sharedCenter].currentUser.userInfo.invitecode]) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [SCUserCenter sharedCenter].currentUser.userInfo.invitecode;
        
//        [SVProgressHUD showImage:AlertSuccessImage status:@"邀请码已复制"];
//        [SVProgressHUD dismissWithDelay:2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self fenXiangRuanJianAlert];
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
                    [weakSelf fenXiangRuanJianAlert];
                });
                
            }
            
        }];
        [InsNetwork addRequest:request];
    }
    
}

- (void)fenXiangRuanJianAlert{
    
//    https://www.handanxiaohongniang.com/?invitecode=PQXWVFUR&from=groupmessage
    NSString *shareUrl = [NSString stringWithFormat:@"%@?invitecode=%@&from=groupmessage",kSCShareLinkURL,self.userModel.invitecode];
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"分享软件" cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {

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

- (void)dangQianJiFen{
    DangQianJiFenVC *vc = [DangQianJiFenVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jiaoHuanWeiXin{
    AskWeChatOrYueTaVC *vc = [AskWeChatOrYueTaVC new];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openVipBtnClicked{
    
    if (![SCUserCenter sharedCenter].currentUser.userInfo.isOnlineSwitch) {
        FeedBackVC *vc = [FeedBackVC new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        VipVC *vc = [VipVC new];
        vc.type = 1;
        vc.userId = self.userModel.iD;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)yueClicked{
    
    AskWeChatOrYueTaVC *vc = [AskWeChatOrYueTaVC new];
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)shezhi{
    SettingVC *vc = [SettingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark
- (void)rightBtnClick{
    
}

- (void)setupBtnClick{
    
    [self shezhi];
}

#pragma mark GFLCellDelegate <NSObject>

- (void)kanguoWoBtnClicked{
    
    ForumVC *vc = [ForumVC new];
    vc.title = @"谁看过我";
    vc.forumVCType = ForumVCTypeNoticeOrNearBy;
    vc.momentRequestType = MomentRequestTypeWhoLookMe;
    vc.momentUIType = MomentUITypeNearby;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)guanzhuWoBtnClicked{
    
    ForumVC *vc = [ForumVC new];
    vc.forumVCType = ForumVCTypeNoticeOrNearBy;
    vc.momentUIType = MomentUITypeNearby;
    vc.momentRequestType = MomentRequestTypeFollowMe;
    vc.title = @"关注我的";
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)woguanzhuBtnClicked{
    ForumVC *vc = [ForumVC new];
    vc.forumVCType = ForumVCTypeNoticeOrNearBy;
    vc.momentUIType = MomentUITypeNearby;
    vc.momentRequestType = MomentRequestTypeFollows;
    vc.title = @"我关注的";
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)huxiangGuanZhuBtnClicked{
    
    ForumVC *vc = [ForumVC new];
    vc.forumVCType = ForumVCTypeNoticeOrNearBy;
    vc.momentUIType = MomentUITypeNearby;
    vc.momentRequestType = MomentRequestTypeBothFollowing;
    vc.title = @"互相关注";
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0 && indexPath.row == 0) {
//
//        UserInfoHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoTableViewCellReuseID"];
//
//        cell.delegate = self;
//        cell.userModel = self.userModel;
//        return cell;
//
//    }else
    if(indexPath.section == 0){
        
        if (!self.gflCell) {
            self.gflCell = [tableView dequeueReusableCellWithIdentifier:@"GFLCell"];
            [self.gflCell.settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        self.gflCell.lookMeCount = self.lookMeUnreadCount;
        self.gflCell.delegate = self;
        self.gflCell.userModel = self.userModel;
        return self.gflCell;
        
    }else if(indexPath.section == 1){
        
        MeV2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeV2TableViewCell"];
        cell.delegate = self;
        if (self.userModel.count_demand_wechat>0) {
            cell.askWeChatUnreadCountLB.text = [NSString stringWithFormat:@"%ld",self.userModel.count_demand_wechat];
        }else{
            cell.askWeChatUnreadCountLB.text = @"";
        }
//        if (self.userModel.count_demand_date_online > 0) {
//            cell.yueUnreadCount.text = [NSString stringWithFormat:@"%ld",self.userModel.count_demand_date_online];
//        }else{
//            cell.yueUnreadCount.text = @"";
//        }
        if (self.userModel.is_idcard_verified) {
            cell.renzhengT.text = @"已认证";
        }else{
            cell.renzhengT.text = @"我要认证";
        }
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
//        case 0:
//        {
//
//        }
//            break;
        case 0:
        {
            
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                [self geRenZiLiao];
            }else if (indexPath.row == 1) {
                [self zeOuBiaoZhun];
            }else if (indexPath.row == 2) {
                [self woYaoRenZheng];
            }else if (indexPath.row == 3) {
                [self shuiKanGuoWo];
            }else if (indexPath.row == 4) {
                [self fenXiangRuanJian];
            }else if (indexPath.row == 5) {
                [self dangQianJiFen];
            }else if (indexPath.row == 6) {
                [self jiaoHuanWeiXin];
            }
        }
            break;
        
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    return 4;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
//            return 7;
            return 1;
            break;
//        case 2:
//            return 1;
//            break;
        default:
            break;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
//        return 152;
        return 275;
    }else if (indexPath.section == 1) {
//        return 75;
        return 430;
    }else{
        return kScreenWidth;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 0 || section == 1) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
//        view.backgroundColor = BackGroundColor;
//        return view;
//    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (InsLoadDataTablView *)tableView {
    if ( !_tableView ) {
        _tableView = [[InsLoadDataTablView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, kScreenWidth, kScreenHeight - UITabBarHeight - StatusBarHeight ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
//        _tableView.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
//        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 15, _tableView.separatorInset.bottom, 15);
//        _tableView.separatorColor = Line;
//        _tableView.rowHeight = 55;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UserInfoHomePageTableViewCell class] forCellReuseIdentifier:@"UserInfoTableViewCellReuseID"];
        [_tableView registerNib:[UINib nibWithNibName:@"GFLCell" bundle:nil] forCellReuseIdentifier:@"GFLCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MeV2TableViewCell" bundle:nil] forCellReuseIdentifier:@"MeV2TableViewCell"];
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
