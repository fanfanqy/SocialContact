//
//  DCIMChatListViewController.m
//  ChildEnd
//
//  Created by dylan on 2017/2/22.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "DCIMChatListViewController.h"

#import "ForumVC.h"

#import "XHBottleViewController.h"

#import "DCIMChatViewController.h"

#import "DCIMGroupConversationViewController.h"

#import "IMHeaderView.h"

#import "InviteFriendVC.h"

#import "ChartListTableViewCell.h"

#import "MiaiVC.h"



@interface DCIMChatListViewController () <RCMessageCellDelegate,RCConversationCellDelegate,IMHeaderViewDelegate>

/** emptyView */
@property (strong, nonatomic) UIView *emptyView;

@property (strong, nonatomic) IMHeaderView *conversationListTableViewHeaderView;

@property(nonatomic,strong) UIView *topBarView;



@end

@implementation DCIMChatListViewController
{
    DCIMButton *noticeBtn;
}

- (UIView *)topBarView{
    if (!_topBarView) {
        _topBarView = [UIView new];
        _topBarView.backgroundColor = Font_color333;
        _topBarView.frame = CGRectMake(0, 0, self.view.width, GuaTopHeight);
    }
    return _topBarView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    if ([RCIM sharedRCIM].getConnectionStatus != ConnectionStatus_Connected ) {
        [[SCIM shared] startWithAppKey:kRongYunKey];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getNoticeCount];
    
    CYLTabBarController *tabBarViewController = (CYLTabBarController *)[AppDelegate sharedDelegate].window.rootViewController;
    if ( [RCIMClient sharedRCIMClient].getTotalUnreadCount != 0 ) {
        tabBarViewController.tabBar.items[2].badgeValue = [[NSString alloc] initWithFormat:@"%d", [RCIMClient sharedRCIMClient].getTotalUnreadCount];
    } else {
        tabBarViewController.tabBar.items[2].badgeValue = nil;
    }
    
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    
}

#pragma mark - 

// 重写选中每行的方法
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
				 conversationModel:(RCConversationModel *)model
							 atIndexPath:(NSIndexPath *)indexPath {

	if ( model.conversationType == ConversationType_PRIVATE ) {
        
        DCIMChatViewController *chatVC = [[DCIMChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
        chatVC.title = model.conversationTitle;
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
        
	}else if ( model.conversationType == ConversationType_GROUP ) {
        
		DCIMGroupConversationViewController *groupVC = [[DCIMGroupConversationViewController alloc] initWithConversationType:ConversationType_GROUP targetId:model.targetId];
		groupVC.title = model.conversationTitle;
		groupVC.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:groupVC animated:YES];
        
	}else {
        
		[super onSelectedTableRow:conversationModelType conversationModel:model atIndexPath:indexPath];
	}
}

- (void)didTapCellPortrait:(RCConversationModel *)model {
    [self onSelectedTableRow:model.conversationModelType conversationModel:model atIndexPath:[NSIndexPath indexPathForRow:[self.conversationListDataSource indexOfObject:model] inSection:0]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChartListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChartListTableViewCell"];
    [cell setDataModel:self.conversationListDataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}


#pragma mark -

- (id)init {
	self = [super init];
	if (self) {
		//设置要显示的会话类型
		[self setDisplayConversationTypes:@[
                                            @(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_PUBLICSERVICE),
                                            @(ConversationType_GROUP)
                                            ]];

		//聚合会话类型
		[self setCollectionConversationType:@[ @(ConversationType_SYSTEM)]];

	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self setTitle:@"聊天"];
    
    self.cellBackgroundColor = [UIColor whiteColor];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 11.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
	// 设置tableView样式
	self.conversationListTableView.separatorColor =
	[UIColor colorWithHexString:@"efeff4"];
    self.conversationListTableView.backgroundColor = [UIColor whiteColor];
	self.conversationListTableView.tableFooterView = [UIView new];
	
    [self.conversationListTableView registerClass:[ChartListTableViewCell class] forCellReuseIdentifier:@"ChartListTableViewCell"];
	self.definesPresentationContext = YES;

    [self.emptyConversationView addSubview:self.emptyView];

	// 设置在NavigatorBar中显示连接中的提示
	self.showConnectingStatusOnNavigatorBar = YES;

	if ([self.conversationListTableView respondsToSelector:@selector(setSeparatorInset:)]) { [self.conversationListTableView setSeparatorInset:UIEdgeInsetsZero]; }
	if ([self.conversationListTableView respondsToSelector:@selector(setLayoutMargins:)]) { [self.conversationListTableView setLayoutMargins:UIEdgeInsetsZero]; }

    noticeBtn = [[DCIMButton alloc] initWithFrame:CGRectMake(0, StatusBarHeight+(GuaTopHeight-StatusBarHeight-22)/2.0, 22, 22)];
    [noticeBtn setImage:[UIImage imageNamed:@"ic_notice"] forState:UIControlStateNormal];
//    [noticeBtn setImage:[[UIImage imageNamed:@"ic_notice"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//    noticeBtn.tintColor = [UIColor whiteColor];
    
    [noticeBtn addTarget:self action:@selector(noticeBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:noticeBtn];

    
    
    [self.view addSubview:self.topBarView];
    
    noticeBtn.left = self.view.width - 40;
    [self.topBarView addSubview:noticeBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(200, StatusBarHeight, 100, GuaTopHeight-StatusBarHeight)];
    label.centerX = self.view.width/2.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"聊天";
    label.textColor = m2;
    label.font = [[UIFont fontWithName:@"Heiti SC" size:18]fontWithBold];
    [self.topBarView addSubview:label];
    
    self.conversationListTableView.top = GuaTopHeight;
    self.conversationListTableView.height = kScreenHeight - GuaTopHeight-UITabBarHeight;
    [self.conversationListTableView setTableHeaderView:self.conversationListTableViewHeaderView];
    
    
    
}


// 获取未读个数
- (void)getNoticeCount{
    /*
     获取未读个数
     Request
     LoginRequired: True
     Method: GET
     URL: /notices/status/
     */
    
    GETRequest *request = [GETRequest requestWithPath:@"/notices/status/" parameters:nil completionHandler:^(InsRequest *request) {
        
        if (!request.error) {
            NSInteger count = [request.responseObject[@"data"][@"unread_count"] integerValue];
            
            if (count) {
                [noticeBtn showDLBadgeWithStyle:DLBadgeStyleNumber value:count animationType:DLBadgeAnimTypeShake];
            }else{
                [noticeBtn clearBadge];
            }
        }
        
    }];
    [InsNetwork addRequest:request];
}



- (void)noticeBtnAction{
    
    ForumVC *vc = [ForumVC new];
    vc.title = @"消息列表";
    vc.forumVCType = ForumVCTypeNoticeOrNearBy;
    vc.momentRequestType = MomentRequestTypeNotice;
    vc.momentUIType = MomentUITypeNotice;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IMHeaderView *)conversationListTableViewHeaderView{
    if (!_conversationListTableViewHeaderView) {
        _conversationListTableViewHeaderView = [[NSBundle mainBundle]loadNibNamed:@"IMHeaderView" owner:nil options:nil][0];
        _conversationListTableViewHeaderView.height = 130;
        _conversationListTableViewHeaderView.delegate = self;
    }
    return _conversationListTableViewHeaderView;
}

- (void)nearbyUserCLick{
    ForumVC *vc = [ForumVC new];
    vc.title = @"附近的人";
    vc.forumVCType = ForumVCTypeNoticeOrNearBy;
    vc.momentRequestType = MomentRequestTypeNearby;
    vc.momentUIType = MomentUITypeNearby;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)driftingBottleCLick{

    XHBottleViewController *vc = [XHBottleViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)loveSkillCLick{
    
    MiaiVC *vc = [MiaiVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)inviteFriendCLick{
    InviteFriendVC *vc = [InviteFriendVC new];
    vc.title = @"邀请好友";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.emptyConversationView.frame = CGRectMake((kScreenWidth - 180)*0.5, 100, 180, 200);
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [Ins_NodataView ins_nodataViewWithIcon:[UIImage imageNamed:@"liaotianxinxi_icon"] detail:@"暂无聊天信息，快去聊天吧"];
        _emptyView.frame = CGRectMake(-(kScreenWidth - 180)*0.5, 100+GuaTopHeight, kScreenWidth, 200);
        _emptyView.backgroundColor = [UIColor whiteColor];
    }
    return _emptyView;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
