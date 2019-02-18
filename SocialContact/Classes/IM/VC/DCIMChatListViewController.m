//
//  DCIMChatListViewController.m
//  ChildEnd
//
//  Created by dylan on 2017/2/22.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "DCIMChatListViewController.h"

#import "ForumVC.h"

#import "BottleVC.h"

#import "DCIMChatViewController.h"

#import "DCIMGroupConversationViewController.h"

#import "IMHeaderView.h"

#import "ChartListTableViewCell.h"


@interface DCIMChatListViewController () <RCMessageCellDelegate,RCConversationCellDelegate,IMHeaderViewDelegate>

/** emptyView */
@property (strong, nonatomic) UIView *emptyView;

@property (strong, nonatomic) IMHeaderView *conversationListTableViewHeaderView;

@end

@implementation DCIMChatListViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    if ([RCIM sharedRCIM].getConnectionStatus != ConnectionStatus_Connected ) {
        [[SCIM shared] startWithAppKey:kRongYunKey];
    }
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
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 11.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
	// 设置tableView样式
	self.conversationListTableView.separatorColor =
	[UIColor colorWithHexString:@"efeff4"];
    self.conversationListTableView.backgroundColor = [UIColor whiteColor];
	self.conversationListTableView.tableFooterView = [UIView new];
	[self.conversationListTableView setTableHeaderView:self.conversationListTableViewHeaderView];
    [self.conversationListTableView registerClass:[ChartListTableViewCell class] forCellReuseIdentifier:@"ChartListTableViewCell"];
	self.definesPresentationContext = YES;

    [self.emptyConversationView addSubview:self.emptyView];

	// 设置在NavigatorBar中显示连接中的提示
	self.showConnectingStatusOnNavigatorBar = YES;

	if ([self.conversationListTableView respondsToSelector:@selector(setSeparatorInset:)]) { [self.conversationListTableView setSeparatorInset:UIEdgeInsetsZero]; }
	if ([self.conversationListTableView respondsToSelector:@selector(setLayoutMargins:)]) { [self.conversationListTableView setLayoutMargins:UIEdgeInsetsZero]; }

    DCIMButton *noticeBtn = [[DCIMButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [noticeBtn setImage:[[UIImage imageNamed:@"ic_notice"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    noticeBtn.tintColor = MAIN_COLOR;
    
    [noticeBtn addTarget:self action:@selector(noticeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:noticeBtn];

}

- (void)noticeBtnAction{
    
    ForumVC *vc = [ForumVC new];
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
    vc.forumVCType = ForumVCTypeNoticeOrNearBy;
    vc.momentRequestType = MomentRequestTypeNearby;
    vc.momentUIType = MomentUITypeNearby;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)driftingBottleCLick{
    BottleVC *vc = [BottleVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)loveSkillCLick{
    
}

- (void)inviteFriendCLick{
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.emptyConversationView.frame = CGRectMake((kScreenWidth - 180)*0.5, 100, 180, 200);
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [Ins_NodataView ins_nodataViewWithIcon:[UIImage imageNamed:@"liaotianxinxi_icon"] detail:@"暂无聊天信息，快去聊天吧"];
        _emptyView.frame = CGRectMake(-(kScreenWidth - 180)*0.5, 100, kScreenWidth, 200);
        _emptyView.backgroundColor = [UIColor whiteColor];
    }
    return _emptyView;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
