//
//  ForumVC.m
//  SocialContact
//
//  Created by EDZ on 2019/1/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "ForumVC.h"

#import "WBStatusComposeViewController.h"
#import "UserHomepageVC.h"
#import "ModifyUserInfoVC.h"
#import "VipVC.h"
#import "ActivityDetialVC.h"

#import "TopicCell.h"
#import "TopicListsHeaderView.h"
//#import "BottomToolView.h"
#import "NewDynamicsTableViewCell.h"

#import "NearByUserCell.h"
#import "ArticleOrAdCell.h"
#import "ExchangeWeChatListCell.h"
#import "PointsSkuTableViewCell.h"
#import "PointsSkuExchangeTableViewCell.h"

#import "DCIMGroupConversationViewController.h"

#import "TopicModel.h"
#import "Notice.h"
#import "WhoLookMeModel.h"
#import "UserPointsModel.h"
#import "ArticleOrAdModel.h"
#import "PointsSkuExchange.h"
#import "FollowsModel.h"

#import "XHInputView.h"
#import "DCIMChatViewController.h"
#import "XHPopMenu.h"

#import "UserFeedBackViewController.h"

@interface ForumVC ()<UITableViewDelegate,UITableViewDataSource,NearByUserCellDelegate,ExchangeWeChatListCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,PointsSkuTableViewCellDelegate>

@property(nonatomic,strong) TopicListsHeaderView *topicListsHeaderView;


//@property(nonatomic,strong) BottomToolView   *bottomToolView;
@property(nonatomic,strong) UIButton *participateTopicBtn;
@property(nonatomic,strong) UIButton *joinDiscussion;

@property(nonatomic,strong) UILabel *sendCommentLB;
@property(nonatomic,strong) UIButton *sendCommentButton;


@property(nonatomic,strong) NSMutableArray *array;

@property(nonatomic,strong) NSMutableArray *commentArray;

@property(nonatomic,assign) NSInteger page;

INS_P_ASSIGN(NSInteger, showEmpty);

@property(nonatomic,strong) UIButton *moreBtn;

@property(nonatomic,strong) XHPopMenu *popMenu;

@end

@implementation ForumVC

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshOrNot:) name:kPublishSuccess object:nil];
    
}

- (void)refreshOrNot:(NSNotification *)noti{
    
//    NSLog(@"%@ === %@ === %@", noti.object, noti.userInfo, noti.name);
//    
//    id responseObject = noti.object;
//    
//    MomentModel *model =  [MomentModel modelWithDictionary:responseObject];
//    
//    if (model) {
//        NewDynamicsLayout *layout = [[NewDynamicsLayout alloc]initWithModel:model momentUIType:self.momentUIType momentRequestType:self.momentRequestType];
//        
//        [self.array insertObject:layout atIndex:0];
//        
//        [self.tableView reloadData];
//    }
    
    [self fetchData:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.momentRequestType == MomentRequestTypeNearby || self.momentRequestType == MomentRequestTypeNotice || self.momentRequestType == MomentRequestTypeFollowMe || self.momentRequestType == MomentRequestTypeFollows || self.momentRequestType == MomentRequestTypeBothFollowing ) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.popMenu dissMissPopMenuAnimatedOnMenuSelected:NO];
    
}

- (void)setUpUI{
    
    [self.view addSubview:self.tableView];
    
    if (_momentRequestType == MomentRequestTypeTopicList) {
        
//        [self.view addSubview:self.bottomToolView];
        self.fd_prefersNavigationBarHidden = YES;
        [self.view addSubview:self.participateTopicBtn];
        [self.view addSubview:self.joinDiscussion];
    }
    if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
        UIView *line = [UIView new];
        line.backgroundColor = Line;
        if (IS_IPHONEX) {
            line.frame = CGRectMake(0, kScreenHeight-GuaTopHeight-iPhoneXVirtualHomeHeight-40, kScreenWidth, 0.3);
        }else{
            line.frame = CGRectMake(0, kScreenHeight-GuaTopHeight-40, kScreenWidth, 0.3);
        }
        
        [self.view addSubview:self.sendCommentLB];
        [self.view addSubview:self.sendCommentButton];
        [self.view addSubview:line];
        
        //
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.moreBtn];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
        
    }
    
    self.array = [NSMutableArray array];
    
    WEAKSELF;
    [self.tableView setLoadNewData:^{
        
        [weakSelf fetchData:YES];
        
    }];

    [self.tableView setLoadMoreData:^{
        
        if (weakSelf.momentRequestType == MomentRequestTypeUserMomentDetail || weakSelf.momentRequestType == MomentRequestTypeMyMomentDetail) {
            
            [weakSelf fetchCommentData:NO];
        }else{
            [weakSelf fetchData:NO];
        }
    }];
    
    [self.tableView hideFooter];
    
    [self.tableView beginRefresh];
    
}

- (UILabel *)sendCommentLB{
    if (!_sendCommentLB) {
        _sendCommentLB = [UILabel new];
        if (IS_IPHONEX) {
            _sendCommentLB.frame = CGRectMake(kMomentContentInsetLeft, kScreenHeight-GuaTopHeight-iPhoneXVirtualHomeHeight-40, kScreenWidth-100, 40);
        }else{
            _sendCommentLB.frame = CGRectMake(kMomentContentInsetLeft, kScreenHeight-GuaTopHeight-40, kScreenWidth-60, 40);
        }
        _sendCommentLB.backgroundColor = [UIColor clearColor];
        _sendCommentLB.text = @"请输入评论文字...";
        _sendCommentLB.textColor = YD_Color999;
        _sendCommentLB.font = [UIFont systemFontOfSize:15];
        
        _sendCommentLB.userInteractionEnabled = YES;
        WEAKSELF;
        [_sendCommentLB jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            if (weakSelf.array.count > 0) {
                NewDynamicsLayout *layout = weakSelf.array[0];
                [weakSelf  clickComment:layout];
            }
        }];
    }
    return _sendCommentLB;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(kScreenWidth - 44, 0, 44, 44);
        
        [_moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        
        [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (void)moreBtnClick{
    [self.popMenu showMenuOnView:self.navigationController.view atPoint:CGPointMake(kScreenWidth-70, StatusBarHeight)];
}

#pragma mark - Propertys

- (XHPopMenu *)popMenu {
    if (!_popMenu) {
        _popMenu.backgroundColor = Black;
        //        [UIColor whiteColor];
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < 3; i ++) {
            NSString *title;
            switch (i) {
                case 0: {
                    title = @"举报";
                    break;
                }
                case 1: {
                    
                    title = @"屏蔽";
                    break;
                }
                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:nil title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        WEAKSELF;
        _popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
        _popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems) {
            if (index == 0) {
                [weakSelf jubao];
            }else if (index == 1 ) {
                [weakSelf lahei];
            }
        };
    }
    return _popMenu;
}


- (void)jubao{
    
    UserFeedBackViewController *vc = [UserFeedBackViewController new];
    vc.type = 0;
    vc.title = @"举报";
    vc.to_customer_id = self.uesrInfo.iD;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)lahei{
    
    WEAKSELF;
    
    NSDictionary *dic = @{
                          @"customer_id":[NSNumber numberWithInteger:self.uesrInfo.iD],
                          @"status":@(0),
                          };
    POSTRequest *request = [POSTRequest requestWithPath:@"/customer/following/" parameters:dic completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            [weakSelf.view makeToast:@"已拉黑此人"];
        }
        
    }];
    [InsNetwork addRequest:request];
    
}

#pragma mark 点击了评论
- (void)clickComment:(NewDynamicsLayout *)layout{
    // /moments/<int:pk>/comment/
    NSString *url;
    NSString *placeholder;
    
    url = [NSString stringWithFormat:@"/moments/%ld/comment/",layout.model.iD];
    placeholder = @"请输入评论文字...";
    
    WEAKSELF;
    //支持InputViewStyleDefault 与 InputViewStyleLarge 两种样式
    [XHInputView showWithStyle:InputViewStyleDefault configurationBlock:^(XHInputView *inputView) {
        /** 占位符文字 */
        inputView.placeholder = placeholder;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
        
        /** 更多属性设置,详见XHInputView.h文件 */
        
    } sendBlock:^BOOL(NSString *text) {
        
        
        if(text.length){
            NSLog(@"输入为信息为:%@",text);
            
            NSDictionary *para = @{@"pk":[NSNumber numberWithInteger:layout.model.iD],
                                   @"text":text};
            POSTRequest *request = [POSTRequest requestWithPath:url parameters:para completionHandler:^(InsRequest *request) {
                
                if (request.error) {
                    
                    [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
                    [SVProgressHUD dismissWithDelay:1.5];
                }else{
                    [weakSelf.view makeToast:request.responseObject[@"msg"]];
                    [weakSelf fetchData:YES];
                }
                
            }];
            [InsNetwork addRequest:request];
            
            return YES;//return YES,收起键盘
        }else{
            NSLog(@"显示提示框-你输入的内容为空");
            [weakSelf.view makeToast:@"内容不能为空"];
            return NO;//return NO,不收键盘
        }
    }];
}

- (UIButton *)sendCommentButton{
    if (!_sendCommentButton) {
        _sendCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IS_IPHONEX) {
            _sendCommentButton.frame = CGRectMake(kScreenWidth-65, kScreenHeight-GuaTopHeight-35-iPhoneXVirtualHomeHeight, 60, 40);
        }else{
           _sendCommentButton.frame = CGRectMake(kScreenWidth-65, kScreenHeight-GuaTopHeight-35, 60, 30);
        }
        _sendCommentButton.backgroundColor = [UIColor clearColor];
        _sendCommentButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendCommentButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendCommentButton setTitleColor:YD_Color666 forState:UIControlStateNormal];
        _sendCommentButton.layer.cornerRadius = 4;
        _sendCommentButton.layer.borderColor = YD_Color666.CGColor;
        _sendCommentButton.layer.borderWidth = .5f;
    }
    return _sendCommentButton;
}


- (void)fetchData:(BOOL)refresh{
    
    [self showLoading];
    WEAKSELF;
    NSDictionary *param = nil;
    NSString *url = @"";
    if (refresh) {
        _page = 1;
    }else{
        _page ++;
    }
    if (_forumVCType ==  ForumVCTypeTopic || _forumVCType ==  ForumVCTypeTopicSelect) {
        url = @"/moments/topic/";
        param = @{@"page": [NSNumber numberWithInteger:_page]};
    }else {
        // 详情页利用上层传入的模型
        if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
            
            [self.array removeAllObjects];
            if (self.momentModel) {
                NewDynamicsLayout *layout = [[NewDynamicsLayout alloc]initWithModel:self.momentModel momentUIType:self.momentUIType momentRequestType:self.momentRequestType];
                [self.array addObject:layout];
                [self fetchCommentData:YES];
                [self fetchLikeUserData];
                [self.tableView endRefresh];
                [self.tableView reloadData];
                return;
            }
        }
        
        /*
         MomentRequestTypeNewest = 1,// 最新动态
         MomentRequestTypeSearch = 2,// 搜索动态
         MomentRequestTypeFollow = 3,// 关注的动态列表
         MomentRequestTypeMyList = 4,// 我的动态详情
         MomentRequestTypeUserList = 5,//他人的动态列表
         MomentRequestTypeMyMomentDetail = 6,//他人的动态详情
         MomentRequestTypeUserMomentDetail = 7,//他人的动态详情
         MomentRequestTypeNearby = 8,//附近的人
         MomentRequestTypeVisitors = 9,//谁看过我
         
         */
        
        switch (_momentRequestType) {
            case MomentRequestTypeNewest:
                url = @"/moments/latest/lists/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeSearch:
                url = @"/moments/search/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeFollow:
                url = @"/moments/following/lists/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeMyList:
//                我的动态列表
                url = @"/moments/lists/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeUserList:
//                /moments/customer/<int:pk>/lists/
                url = [NSString stringWithFormat:@"/moments/customer/%ld/lists/",_uesrInfo.iD];
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeMyMomentDetail:
                
                if (self.momentModel) {
                    url = [NSString stringWithFormat:@"/moments/%ld/",_momentModel.iD];
                }else{
                    url = [NSString stringWithFormat:@"/moments/%ld/",_momentId];
                }
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeUserMomentDetail:
                
                if (self.momentModel) {
                    url = [NSString stringWithFormat:@"/moments/detail/%ld/",_momentModel.iD];
                }else{
                    url = [NSString stringWithFormat:@"/moments/detail/%ld/",_momentId];
                }
                param = nil;
                break;
                
            case MomentRequestTypeNearby:
                // TODO
                url = @"/customer/around/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeVisitors:
                // TODO
                url = @"/customer/unknown/lists/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeSkill:
                url = @"/customer/unknown/lists/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeTopicList:
                url = @"/moments/search/";
                param = @{@"page": [NSNumber numberWithInteger:_page],
                          @"topic_id":[NSNumber numberWithInteger:_topicModel.iD],
                          };
                break;
                
            case MomentRequestTypeRecentlyUser:
                url = @"/customer/active/lists/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeFollowMe:
                url = @"/customer/followerslist/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeFollows:
                url = @"/customer/followinglist/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeBothFollowing:
                url = @"/customer/bothfolowinglist/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeNotice:
                url = @"/notices/lists/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeWhoLookMe:
                url = @"/stats/visitors/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeJiFenList:
                url = @"/api/points/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeActivity:
#pragma mark TODO
                url = @"/api/articles/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
//                MomentRequestTypeAskWeChatSend = 21, // 发出 交换微信
//                MomentRequestTypeAskWeChatReceived = 22, // 收到 交换微信
//                MomentRequestTypeYueTaSend = 23, // 发出 约她
//                MomentRequestTypeYueTaReceived = 24, // 收到 约她
//                demand_type    int    0：申请微信； 1：请求微信； 2：线下约她；
                
            case MomentRequestTypeAskWeChatSend:
                url = @"/api/demands/mine/";
                param = @{@"page": [NSNumber numberWithInteger:_page],
                          @"demand_type":@(0),
                          };
                break;
                
            case MomentRequestTypeAskWeChatReceived:
                url = @"/api/demands/received/";
//                url = @"/api/demands/mine/";
                param = @{@"page": [NSNumber numberWithInteger:_page],
//                        @"demand_type":@(1),
                          @"demand_type":@(0),
                          };
                break;
                
            case MomentRequestTypeAskWeChatCard:
                url = @"/api/wechatcards/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeYueTaSend:
                url = @"/api/demands/mine/";
                param = @{@"page": [NSNumber numberWithInteger:_page],
                          @"demand_type":@(1),
                          };
                break;
                
            case MomentRequestTypeYueTaReceived:

                url = @"/api/demands/received/";
                param = @{@"page": [NSNumber numberWithInteger:_page],
                          @"demand_type":@(1),
                          };
                          
                break;
            case MomentRequestTypePointSkus:
                url = @"/api/skus/";
                param = @{@"page": [NSNumber numberWithInteger:_page]
                          };
                break;
            case MomentRequestTypePointSkusExchages:
                url = @"/api/sku-exchages/";
                param = @{@"page": [NSNumber numberWithInteger:_page]
                          };
                break;
                
            default:
                break;
        }
        
    }
    
    GETRequest *request = [GETRequest requestWithPath:url parameters:param completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        [weakSelf.tableView endRefresh];
        
        if (!request.error) {
            
            NSMutableArray *resultArray = [NSMutableArray array];
            
            
            if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
                [resultArray addObject:request.responseObject[@"data"]];
            }else{
                resultArray = request.responseObject[@"data"][@"results"];
            }
            

            if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
                
            }else{
                if (![Help canPerformLoadRequest:request.responseObject]) {
                    [weakSelf.tableView endRefreshNoMoreData];
                }else{
                    [weakSelf.tableView showFooter];
                }
            }
            
            if (refresh) {
                [weakSelf.array removeAllObjects];
            }
            
            if (weakSelf.forumVCType ==  ForumVCTypeTopic || weakSelf.forumVCType ==  ForumVCTypeTopicSelect) {
                            
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [weakSelf.array addObject:[TopicModel modelWithDictionary:obj]];
                    
                }];
                if (weakSelf.array.count == 0) {
                    
                    weakSelf.showEmpty = YES;
                }else{
                    weakSelf.showEmpty = NO;
                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView reloadEmptyDataSet];
                
            }else if (weakSelf.forumVCType == ForumVCTypeNoticeOrNearBy) {
                
                
                if (weakSelf.momentRequestType == MomentRequestTypeNotice) {
                    [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [weakSelf.array addObject:[Notice modelWithDictionary:obj]];
                        
                    }];
                    
                }else if (weakSelf.momentRequestType == MomentRequestTypeNearby) {
                    [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [weakSelf.array addObject:[SCUserInfo modelWithDictionary:obj]];
                        
                    }];
                }else if (weakSelf.momentRequestType == MomentRequestTypeWhoLookMe){
                    [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [weakSelf.array addObject:[WhoLookMeModel modelWithDictionary:obj]];
                        
                    }];
                    
                }else if (weakSelf.momentRequestType == MomentRequestTypeJiFenList){
                    [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [weakSelf.array addObject:[UserPointsModel modelWithDictionary:obj]];
                        
                    }];
                    
                }else if (weakSelf.momentRequestType == MomentRequestTypeFollows || weakSelf.momentRequestType == MomentRequestTypeFollowMe || weakSelf.momentRequestType == MomentRequestTypeBothFollowing) {
                    
                    [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [weakSelf.array addObject:[FollowsModel modelWithDictionary:obj]];
                        
                    }];
                    
                }
                if (weakSelf.array.count == 0) {
                    
                    weakSelf.showEmpty = YES;
                }else{
                    weakSelf.showEmpty = NO;
                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView reloadEmptyDataSet];
                
            }else if (weakSelf.forumVCType == ForumVCTypeMoment) {
                
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MomentModel *momentModel = [MomentModel modelWithDictionary:obj];
                    NewDynamicsLayout *layout = [[NewDynamicsLayout alloc]initWithModel:momentModel momentUIType:weakSelf.momentUIType momentRequestType:weakSelf.momentRequestType];
                    [weakSelf.array addObject:layout];
                    
                }];
                
                if (weakSelf.momentRequestType == MomentRequestTypeUserMomentDetail || weakSelf.momentRequestType == MomentRequestTypeMyMomentDetail) {
                    
                    if (weakSelf.commentArray.count > 0) {
                        NewDynamicsLayout *layout = weakSelf.array[0];
                        layout.commentLayoutArr = weakSelf.commentArray;
                        [layout resetLayout];
                        [weakSelf.tableView reloadData];
                    }else{
                        
                        [weakSelf fetchCommentData:YES];
                        [weakSelf fetchLikeUserData];
                    }
                    
                    
                }else{
                    if (weakSelf.array.count == 0) {
                        
                        weakSelf.showEmpty = YES;
                    }else{
                        weakSelf.showEmpty = NO;
                    }
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView reloadEmptyDataSet];
                }

                
            }else if(weakSelf.forumVCType == ForumVCTypeActivity){
                
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ArticleOrAdModel *articleOrAdModel = [ArticleOrAdModel modelWithDictionary:obj];
                    [weakSelf.array addObject:articleOrAdModel];
                    
                }];
                if (weakSelf.array.count == 0) {
                    
                    weakSelf.showEmpty = YES;
                }else{
                    weakSelf.showEmpty = NO;
                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView reloadEmptyDataSet];
                
            }else if(weakSelf.forumVCType == ForumVCTypeAskWeChatOrYueTa){
                
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ApplyModel *model = [ApplyModel modelWithDictionary:obj];
                    [weakSelf.array addObject:model];
                    
                }];
                
                [weakSelf.tableView reloadData];
                
                if (weakSelf.array.count == 0) {
                    
                    weakSelf.showEmpty = YES;
                }else{
                    weakSelf.showEmpty = NO;
                }
                
                [weakSelf.tableView reloadEmptyDataSet];
                
            }else if(weakSelf.forumVCType == ForumVCTypePointsStore){
                
                if (weakSelf.momentRequestType == MomentRequestTypePointSkus) {
                    
                    [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        PointsSkuModel *model = [PointsSkuModel modelWithDictionary:obj];
                        [weakSelf.array addObject:model];
                        
                    }];
                    
                }else if (weakSelf.momentRequestType == MomentRequestTypePointSkusExchages) {
                    
                    [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        PointsSkuExchange *model = [PointsSkuExchange modelWithDictionary:obj];
                        [weakSelf.array addObject:model];
                        
                    }];
                }
                
                if (weakSelf.array.count == 0) {
                    
                    weakSelf.showEmpty = YES;
                }else{
                    weakSelf.showEmpty = NO;
                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView reloadEmptyDataSet];
            }
        }else{
            if ( weakSelf.page > 1 ) {
                weakSelf.page --;
            }
            
            if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
                
                
            }else{
                if (weakSelf.array.count > 0) {
                    [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
                    [SVProgressHUD dismissWithDelay:1.5];
                } else {
                    [weakSelf showError:request.error reload:^{
                        [weakSelf fetchData:YES];
                    }];
                }
            }
        }
        
    }];
    [InsNetwork addRequest:request];
}

- (void)fetchCommentData:(BOOL)refresh{
    
    WEAKSELF;
    NSDictionary *param = nil;
    NSString *url ;
    if (self.momentModel) {
        url =  [NSString stringWithFormat:@"/moments/%ld/comment/",_momentModel.iD];
    }else{
        url =  [NSString stringWithFormat:@"/moments/%ld/comment/",_momentId];
    }
    if (refresh) {
        _page = 1;
    }else{
        _page ++;
    }
    param = @{@"page": [NSNumber numberWithInteger:_page]};
    
    GETRequest *request = [GETRequest requestWithPath:url parameters:param completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        
        if (!request.error) {
            
            NSArray *resultArray = request.responseObject[@"data"][@"results"];
        
            
//            if (resultArray.count < 10) {
            if (![Help canPerformLoadRequest:request.responseObject]) {
                [weakSelf.tableView endRefreshNoMoreData];
            }else{
                [weakSelf.tableView showFooter];
            }
            
            NSMutableArray *commentArray = [NSMutableArray array];
            [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CommentModel *commentModel = [CommentModel modelWithDictionary:obj];
                CommentLayout *layout = [[CommentLayout alloc]initWithModel:commentModel];
                [commentArray addObject:layout];
                
            }];
            
            NewDynamicsLayout *layout = weakSelf.array[0];
            if (refresh) {
                layout.commentLayoutArr = commentArray;
            }else{
                [layout.commentLayoutArr addObjectsFromArray:resultArray];
            }
            [layout resetLayout];
            
            [weakSelf.tableView reloadData];
            
            
        }else{
            if ( weakSelf.page > 1 ) {
                weakSelf.page --;
            }
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
            
        }
    }];
    [InsNetwork addRequest:request];
    
}

- (void)fetchLikeUserData{
    
    WEAKSELF;
    NSString *url;
    if (self.momentModel) {
       url =  [NSString stringWithFormat:@"/moments/%ld/likes/",_momentModel.iD];
    }else{
        url =  [NSString stringWithFormat:@"/moments/%ld/likes/",_momentId];
    }
    
    GETRequest *request = [GETRequest requestWithPath:url parameters:nil completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        
        if (!request.error) {
            
            NSArray *resultArray = request.responseObject[@"data"][@"results"];
            
            if ( resultArray && resultArray.count > 0 ) {
                NSMutableArray *likeArray = [NSMutableArray array];
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    LikeModel *likeModel = [LikeModel modelWithDictionary:obj];
                    [likeArray addObject:likeModel];
                    
                }];
                
                NewDynamicsLayout *layout = weakSelf.array[0];
                layout.zanUsers = likeArray;
                [layout resetLayout];
                
                [weakSelf.tableView reloadData];
            }
        }else{
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:2];
        }
    }];
    [InsNetwork addRequest:request];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_forumVCType ==  ForumVCTypeTopic || _forumVCType ==  ForumVCTypeTopicSelect) {
        TopicModel *topicModel = self.array[indexPath.row];
        TopicCell *cell = (TopicCell *)[tableView dequeueReusableCellWithIdentifier:@"TopicCell"];
        [cell.imgV setImageWithURL:[NSURL URLWithString:topicModel.logo_url] placeholder:nil options:YYWebImageOptionProgressive completion:nil];
        cell.titleLB.text = [NSString stringWithFormat:@"#%@#",topicModel.name];
        cell.contentLB.text = topicModel.desc;
        if (indexPath.row == 0) {
            cell.titleLB.textColor = m1;
        }else if (indexPath.row == 0) {
            cell.titleLB.textColor = m2;
        }else{
            cell.titleLB.textColor = Font_color333;
        }
        return cell;
    }else if (self.forumVCType == ForumVCTypeNoticeOrNearBy) {
        
        NearByUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearByUserCell"];
        cell.delegate = self;
        
        if (self.momentRequestType == MomentRequestTypeNotice) {
            Notice *notice = self.array[indexPath.row];
            cell.notice = notice;
            cell.userId = notice.from_customer.iD;
            
        }else if (self.momentRequestType == MomentRequestTypeNearby) {
            SCUserInfo *userInfo = self.array[indexPath.row];
            cell.userInfo = userInfo;
            cell.userId = userInfo.iD;
            
        }else if (self.momentRequestType == MomentRequestTypeWhoLookMe){
            WhoLookMeModel *model = self.array[indexPath.row];
            cell.lookMeModel = model;
            cell.userId = model.customer.iD;
            
        }else if (self.momentRequestType == MomentRequestTypeJiFenList){
            
            
            
        }else if (self.momentRequestType == MomentRequestTypeFollows || self.momentRequestType == MomentRequestTypeFollowMe || self.momentRequestType == MomentRequestTypeBothFollowing) {
            
            FollowsModel *model = self.array[indexPath.row];
            cell.followsModel = model;
            cell.userId = model.customer.iD;
            
        }
        return cell;
        
    }else if (_forumVCType == ForumVCTypeMoment) {
        
        NewDynamicsLayout *layout = self.array[indexPath.row];
        NewDynamicsTableViewCell *cell = (NewDynamicsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"NewDynamicsTableViewCell-%ld",_momentRequestType]];
        [cell setLayout:layout];
        if (self.momentRequestType == MomentRequestTypeTopicList) {
            cell.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    }else if (_forumVCType == ForumVCTypeActivity) {
        
        ArticleOrAdCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"ArticleOrAdCell"];
        ArticleOrAdModel *model = self.array[indexPath.row];
        [cell setModel:model];
        return cell;
        
    }else if (_forumVCType == ForumVCTypeAskWeChatOrYueTa) {
        
        ExchangeWeChatListCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"ExchangeWeChatListCell"];
        
        if (self.momentRequestType == MomentRequestTypeAskWeChatSend) {
            cell.type = 0;
        }else if (self.momentRequestType == MomentRequestTypeAskWeChatReceived) {
            cell.type = 1;
        }else if (self.momentRequestType == MomentRequestTypeYueTaSend) {
            cell.type = 2;
        }else if (self.momentRequestType == MomentRequestTypeYueTaReceived) {
            cell.type = 3;
        }else if (self.momentRequestType == MomentRequestTypeAskWeChatCard) {
            cell.type = 4;
        }
        
        cell.delegate = self;
        cell.indexPath = indexPath;
        ApplyModel *model = self.array[indexPath.row];
        [cell setModel:model];
        return cell;
        
    }else if (_forumVCType == ForumVCTypePointsStore) {
        NSString *identifier = @"PointsSkuTableViewCell";
        if (self.momentRequestType == MomentRequestTypePointSkus ) {
            
        }else{
            identifier = @"PointsSkuTableViewCell1";
        }
        PointsSkuTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.delegate = self;
        cell.indexPath = indexPath;
        if (self.momentRequestType == MomentRequestTypePointSkus ) {
            PointsSkuModel *model = self.array[indexPath.row];
            [cell setPointsSkuModel:model];
        }else if (self.momentRequestType == MomentRequestTypePointSkusExchages) {
            PointsSkuExchange *model = self.array[indexPath.row];
            [cell setPointsSkuExchangeModel:model];
        }
        return cell;

    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.forumVCType ==  ForumVCTypeTopic || _forumVCType ==  ForumVCTypeTopicSelect) {
        return 100;
    }else if (self.forumVCType == ForumVCTypeNoticeOrNearBy) {
        
        return 85.f;
        
    }else if (self.forumVCType == ForumVCTypeMoment) {
        NewDynamicsLayout *layout = self.array[indexPath.row];
        return layout.height;
        
    }else if (self.forumVCType == ForumVCTypeActivity) {
        return (kScreenWidth-40)/1.5;
        
    }else if (_forumVCType == ForumVCTypeAskWeChatOrYueTa) {
        return 100;
        
    }else if (_forumVCType == ForumVCTypePointsStore) {
        
        if (self.momentRequestType == MomentRequestTypePointSkus) {
            
            return 80;
            
        }else if (self.momentRequestType == MomentRequestTypePointSkusExchages) {
            return 80;
        }
        
    }
    
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.forumVCType ==  ForumVCTypeTopic || _forumVCType ==  ForumVCTypeTopicSelect) {
        TopicModel *topicModel = self.array[indexPath.row];
        
        if (_delegate && [_delegate respondsToSelector:@selector(topicSelected:)]) {
            
            [_delegate topicSelected:topicModel];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            ForumVC *vc = [ForumVC new];
            vc.title = topicModel.name;
            vc.forumVCType = ForumVCTypeMoment;
            vc.momentUIType = MomentUITypeList;
            vc.momentRequestType = MomentRequestTypeTopicList;
            vc.height = kScreenHeight;
            vc.topicModel = topicModel;
            [self.fatherVC.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (self.forumVCType == ForumVCTypeNoticeOrNearBy) {
        
        
         if (self.momentRequestType == MomentRequestTypeNotice) {
            
             // 进入帖子主页
             Notice *model = self.array[indexPath.row];
             // 未读的消息设置为已读
             if (model.status == 0) {
                 [self setReadStatus:model.iD];
             }
             ForumVC *vc = [ForumVC new];
             vc.title = @"动态";
             vc.forumVCType = ForumVCTypeMoment;
             vc.momentUIType = MomentUITypeDetail;
             vc.momentRequestType = MomentRequestTypeUserMomentDetail;
             vc.momentId = model.object_id;
             
             if (self.fatherVC) {
                 [self.fatherVC.navigationController pushViewController:vc animated:YES];
             }else{
                 [self.navigationController pushViewController:vc animated:YES];
             }
            
        }else if (self.momentRequestType == MomentRequestTypeNearby) {
            // 进入用户主页
            SCUserInfo *userInfo = self.array[indexPath.row];
            UserHomepageVC *vc = [UserHomepageVC new];
            vc.userId = userInfo.iD;
            vc.name = userInfo.name;
            if (self.fatherVC) {
                [self.fatherVC.navigationController pushViewController:vc animated:YES];
            }else{
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if (self.momentRequestType == MomentRequestTypeWhoLookMe){
            
            WhoLookMeModel *model = self.array[indexPath.row];
            UserHomepageVC *vc = [UserHomepageVC new];
            vc.userId = model.customer.iD;
            vc.name = model.customer.name;
            if (self.fatherVC) {
                [self.fatherVC.navigationController pushViewController:vc animated:YES];
            }else{
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if (self.momentRequestType == MomentRequestTypeJiFenList){
            
        }else if (self.momentRequestType == MomentRequestTypeFollows || self.momentRequestType == MomentRequestTypeFollowMe || self.momentRequestType == MomentRequestTypeBothFollowing) {
            
            FollowsModel *model = self.array[indexPath.row];
            UserHomepageVC *vc = [UserHomepageVC new];
            vc.userId = model.customer.iD;
            vc.name = model.customer.name;
            if (self.fatherVC) {
                [self.fatherVC.navigationController pushViewController:vc animated:YES];
            }else{
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        
    }else if (self.forumVCType == ForumVCTypeMoment) {
        /*
         MomentRequestTypeMyMomentDetail = 6,//他人的动态详情
         MomentRequestTypeUserMomentDetail = 7,//他人的动态详情
         */
        if ( _momentRequestType == MomentRequestTypeUserMomentDetail || _momentRequestType == MomentRequestTypeMyMomentDetail) {
            return;
        }
    }else if (self.forumVCType == ForumVCTypeActivity) {
        
        ArticleOrAdModel *model = self.array[indexPath.row];
        
        ActivityDetialVC *vc = [[ActivityDetialVC alloc]init];
        vc.articleModel = model;
        
//        AXWebViewController *webVC = [[AXWebViewController alloc]initWithAddress:@"https://www.baidu.com/"];
//        webVC.showsToolBar = YES;
//        webVC.reviewsAppInAppStore = YES;
//        webVC.navigationType = AXWebViewControllerNavigationToolItem;
        if (self.fatherVC) {
            [self.fatherVC.navigationController pushViewController:vc animated:YES];
        }else{
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (_forumVCType == ForumVCTypeAskWeChatOrYueTa) {
        
        
        ApplyModel *model = self.array[indexPath.row];
        
        NSInteger targetId;
        NSString *nameTitle;
        // 线上约去聊天
        if (self.momentRequestType == MomentRequestTypeYueTaReceived) {
            
            targetId = model.customer.iD;
            if (targetId == 0) {
                targetId = model.customer.user_id;
            }
            nameTitle = model.customer.name;
            
        }else if (self.momentRequestType == MomentRequestTypeYueTaSend) {
            
            targetId = model.to_customer.iD;
            if (targetId == 0) {
                targetId = model.to_customer.user_id;
            }
            nameTitle = model.to_customer.name;
        }else{
//            targetId = model.to_customer.user_id;
            targetId = model.to_customer.iD;
            nameTitle = model.to_customer.name;
        }
        
        // 已接受的进聊天
        if (model.status == 1) {
            
            DCIMChatViewController *vc = [[DCIMChatViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId: [NSString stringWithFormat:@"%ld",targetId]];
            
            vc.title = nameTitle;
            if (self.fatherVC) {
                [self.fatherVC.navigationController pushViewController:vc animated:YES];
            }else{
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
        
            UserHomepageVC *vc = [UserHomepageVC new];
            vc.userId = targetId;
            if (self.fatherVC) {
                [self.fatherVC.navigationController pushViewController:vc animated:YES];
            }else{
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark NearByUserCellDelegate
- (void)clickAvatarImg:(NSInteger)userID{
    
    UserHomepageVC *vc = [UserHomepageVC new];
    vc.userId = userID;
    if (self.fatherVC) {
        [self.fatherVC.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark ExchangeWeChatListCellDelegate

- (void)refuseBtnClicked:(NSIndexPath *)indexPath type:(NSInteger)type{
    ApplyModel *model = self.array[indexPath.row];
    [self replyWithModel:model refuse:YES agree:NO type:type];
}

- (void)agreeBtnClicked:(NSIndexPath *)indexPath type:(NSInteger)type{
    
    
    ApplyModel *model = self.array[indexPath.row];
    if (type == 0 || type == 1) {
        if ([NSString ins_String:[SCUserCenter sharedCenter].currentUser.userInfo.wechat_id]) {
            [self replyWithModel:model refuse:NO agree:YES type:type];
        }else{
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.shouldDismissOnTapOutside = YES;
            alert.buttonFormatBlock = ^NSDictionary *{
                return @{
                         @"backgroundColor":ORANGE,
                         @"textColor":[UIColor whiteColor],
                         };
            };
            //Using Block
            WEAKSELF;
            [alert addButton:@"去完善" actionBlock:^(void) {
                ModifyUserInfoVC *vc = [ModifyUserInfoVC new];
                vc.modifyType = ModifyTypeWeChat;
                vc.model = [SCUserCenter sharedCenter].currentUser.userInfo;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            [alert showInfo:self title:@"请完善个人微信" subTitle:@"交换微信需要个人真实微信号" closeButtonTitle:nil duration:0.0f]; // Notice
        }
    }else{
        [self replyWithModel:model refuse:NO agree:YES type:type];
    }
    

}

#pragma mark 交换微信回复
- (void)replyWithModel:(ApplyModel *)model refuse:(BOOL)refuse agree:(BOOL)agree type:(NSInteger)type{
    
//    /api/demands/<int:pk>/reply/
    NSInteger reply = 1;
    if (agree) {
        reply = 1;
    }
    if (refuse) {
        reply = 2;
    }
    NSDictionary *dic = @{
                          @"status":[NSNumber numberWithInteger:reply],
                          @"pk":[NSNumber numberWithInteger:model.iD],
                          };
    
    WEAKSELF;
    [self showLoading];
    PUTRequest *request = [PUTRequest requestWithPath:[NSString stringWithFormat:@"/api/demands/%ld/reply/",model.iD] parameters:dic completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            
            if (agree) {
                model.status = 1;
                
                if (type == 0 || type == 1) {
                    [weakSelf.view makeToast:@"交换成功"];
                }else{
                    
                    if (type == 2 || type == 3) {
                        
                        NSString *content = [NSString stringWithFormat:@"您好"];
                        NSInteger targetId;
                        NSString *chatName;
                        
                        // 线上约去聊天
                        if (weakSelf.momentRequestType == MomentRequestTypeYueTaReceived) {
                            content = [NSString stringWithFormat:@"Hi，我已同意您的邀约，我们来聊天吧"];
                            targetId = model.customer.iD;
                            if (targetId == 0) {
                                targetId = model.customer.user_id;
                            }
                            chatName = model.customer.name;
                        }else if (weakSelf.momentRequestType == MomentRequestTypeYueTaSend) {
                            content = [NSString stringWithFormat:@"Hi，您已同意我的邀约，我们来聊天吧"];
                            targetId = model.to_customer.iD;
                            if (targetId == 0) {
                                targetId = model.to_customer.user_id;
                            }
                            chatName = model.to_customer.name;
                        }
                        
                        [weakSelf addChatrecord:targetId];
                        [[AppDelegate sharedDelegate].isBottleCharts addObject:@(targetId)];
                        
                        
                        // 自动打招呼
                        RCTextMessage *rcMC = [RCTextMessage messageWithContent:content];
                        [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId: [NSString stringWithFormat:@"%ld",targetId] content:rcMC pushContent:content pushData:content success:^(long messageId) {
                            NSLog(@"打招呼成功");
                        } error:^(RCErrorCode nErrorCode, long messageId) {
                            NSLog(@"打招呼失败");
                        }];
                        
                        // 进入聊天界面
                        DCIMChatViewController *vc = [[DCIMChatViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId: [NSString stringWithFormat:@"%ld",targetId]];
                        vc.title = chatName;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    
                }
                
            }else{
                
                [weakSelf.view makeToast:@"拒绝成功"];
                model.status = 2;
            }
            [weakSelf.tableView reloadData];
        }
        
    }];
    [InsNetwork addRequest:request];
    
}

- (void)addChatrecord:(NSInteger)user_id{
    
    
    NSDictionary *dic = @{
                          @"user_id":@(user_id),
                          };
    POSTRequest *request = [POSTRequest requestWithPath:@"/api/chatrecord/upload_record/" parameters:dic completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            
        }else{
            [SVProgressHUD showImage:AlertSuccessImage status:@"你们2个人可以无限制聊天了"];
            [SVProgressHUD dismissWithDelay:1.5];
        }
        
    }];
    [InsNetwork addRequest:request];
    
}

#pragma mark 消息设置为已读
/**
 设置为已读
 */
- (void)setReadStatus:(NSInteger)iD{
    
//    /notices/<int:pk>/
    PUTRequest *request = [PUTRequest requestWithPath:[NSString stringWithFormat:@"/notices/%ld",iD] parameters:nil completionHandler:^(InsRequest *request) {
        
        if (!request.error) {
            
        }else{
            
        }
        
    }];
    [InsNetwork addRequest:request];
    
}


- (void)goVip{
    VipVC *vc = [VipVC new];
    vc.type = 1;
    vc.userId = [SCUserCenter sharedCenter].currentUser.userInfo.iD;
    if (self.fatherVC) {
        [self.fatherVC.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 申请兑换商品
- (void)exchangeBtnClicked:(NSIndexPath *)indexPath{
    
//
    if ([SCUserCenter sharedCenter].currentUser.userInfo.service_vip_expired_at) {
        
        NSDate *date = [[SCUserCenter sharedCenter].currentUser.userInfo.service_vip_expired_at sc_dateWithUTCString];
        if (date) {
            NSTimeInterval interval = [date timeIntervalSinceNow];
            if (interval <=  0) {
                [self goVip];
                return;
            }
        }
    }else{
        [self goVip];
        return;
    }
    
    
    PointsSkuModel *skuModel = self.array[indexPath.row];
    NSDictionary *dic = @{
                          @"pk":[NSNumber numberWithInteger:skuModel.iD],
                              };
    WEAKSELF;
    POSTRequest *request = [POSTRequest requestWithPath:[NSString stringWithFormat:@"/api/skus/%ld/exchage/",skuModel.iD] parameters:dic completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            
            [weakSelf.view makeToast:@"申请兑换成功，稍后客服会联系您"];
        }
        
    }];
    [InsNetwork addRequest:request];
}


#pragma mark 立即参与，加入讨论
// 立即参与
-(void)partiClick{
    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
    vc.topicModel = self.topicModel;
    [self.navigationController pushViewController:vc animated:YES];
}

// 加入讨论
- (void)joinClick{
    
    [self.view makeToastActivity:CSToastPositionCenter];
    
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:[NSString stringWithFormat:@"/moments/topic/%ld/chatgroup/",self.topicModel.iD] parameters:nil completionHandler:^(InsRequest *request) {
        
        [weakSelf.view hideToastActivity];
        if (!request.error) {
            
            RCGroup *group = [[RCGroup alloc]initWithGroupId:[NSString stringWithFormat:@"%ld",weakSelf.topicModel.iD] groupName:weakSelf.topicModel.name portraitUri:weakSelf.topicModel.logo_url];
            [group updateToDB];
            
            [weakSelf.view makeToast:request.responseObject[@"msg"]?:@"加群成功" duration:1 position:CSToastPositionCenter];
            DCIMGroupConversationViewController *groupVC = [[DCIMGroupConversationViewController alloc] initWithConversationType:ConversationType_GROUP targetId:[NSString stringWithFormat:@"%ld",weakSelf.topicModel.iD]];
            groupVC.title = weakSelf.topicModel.name;
            groupVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:groupVC animated:YES];
            
        }else{
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
    [InsNetwork addRequest:request];
}

- (UIButton *)participateTopicBtn{
    if (!_participateTopicBtn) {
        _participateTopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat top = kScreenHeight - 50;
        if (IS_IPHONEX) {
            top -= iPhoneXVirtualHomeHeight;
        }
        _participateTopicBtn.frame = CGRectMake(0, top, 106, 44);
        _participateTopicBtn.centerX = kScreenWidth/2.0 - 15 - (53);;
        _participateTopicBtn.layer.cornerRadius = 22.f;
        _participateTopicBtn.layer.masksToBounds = YES;
        [_participateTopicBtn setTitle:@"立即参与" forState:UIControlStateNormal];
        _participateTopicBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_participateTopicBtn setBackgroundImage:[UIImage imageWithColor:BLUE] forState:UIControlStateNormal];
        [_participateTopicBtn setBackgroundImage:[UIImage imageNamed:@"rectangle_bg"] forState:UIControlStateNormal];
        [_participateTopicBtn addTarget:self action:@selector(partiClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _participateTopicBtn;
}


- (UIButton *)joinDiscussion{
    if (!_joinDiscussion) {
        _joinDiscussion = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat top = kScreenHeight -50;
        if (IS_IPHONEX) {
            top -= iPhoneXVirtualHomeHeight;
        }
        _joinDiscussion.frame = CGRectMake(0, top, 106, 44);
        _joinDiscussion.centerX = kScreenWidth/2.0 + 15 + 53;
        _joinDiscussion.layer.cornerRadius = 22.f;
        _joinDiscussion.layer.masksToBounds = YES;
        [_joinDiscussion setTitle:@"加入讨论" forState:UIControlStateNormal];
        _joinDiscussion.titleLabel.font = [UIFont systemFontOfSize:15];
        [_joinDiscussion setBackgroundImage:[UIImage imageNamed:@"rectangle_bg"] forState:UIControlStateNormal];
        [_joinDiscussion addTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinDiscussion;
}

- (TopicListsHeaderView *)topicListsHeaderView{
    if (!_topicListsHeaderView) {
        _topicListsHeaderView = [[NSBundle mainBundle]loadNibNamed:@"TopicListsHeaderView" owner:nil options:nil][0];
        _topicListsHeaderView.topicModel = self.topicModel;
    }
    
    return _topicListsHeaderView;
    
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
        
        if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
            _tableView.height -= 40;
        }
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
            
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
        }else if (self.momentRequestType == MomentRequestTypeNewest || self.momentRequestType == MomentRequestTypeTopicList) {
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            _tableView.emptyDataSetSource = self;
            _tableView.emptyDataSetDelegate = self;
        }else{
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            _tableView.separatorColor = Line;
            
            _tableView.emptyDataSetSource = self;
            _tableView.emptyDataSetDelegate = self;
        }
        [_tableView setSeparatorInset:UIEdgeInsetsMake(_tableView.separatorInset.top, 15, _tableView.separatorInset.bottom, 15)];
        _tableView.tableFooterView = [UIView new];

        if (_forumVCType ==  ForumVCTypeTopic || _forumVCType ==  ForumVCTypeTopicSelect) {
            [_tableView registerNib:[UINib nibWithNibName:@"TopicCell" bundle:nil] forCellReuseIdentifier:@"TopicCell"];
        }else if (self.forumVCType == ForumVCTypeNoticeOrNearBy) {
            
            [_tableView registerNib:[UINib nibWithNibName:@"NearByUserCell" bundle:nil] forCellReuseIdentifier:@"NearByUserCell"];
            
        }else if (_forumVCType == ForumVCTypeMoment) {
            if (_momentRequestType == MomentRequestTypeTopicList) {
                _tableView.tableHeaderView = self.topicListsHeaderView;
//                // 50 高度
                [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
                _tableView.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
            }
            [_tableView registerClass:[NewDynamicsTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"NewDynamicsTableViewCell-%ld",_momentRequestType]];
        }else if (_forumVCType == ForumVCTypeActivity) {
            
            [_tableView registerNib:[UINib nibWithNibName:@"ArticleOrAdCell" bundle:nil] forCellReuseIdentifier:@"ArticleOrAdCell"];
            
        }else if (_forumVCType == ForumVCTypeAskWeChatOrYueTa) {
            
            [_tableView registerNib:[UINib nibWithNibName:@"ExchangeWeChatListCell" bundle:nil] forCellReuseIdentifier:@"ExchangeWeChatListCell"];
        }else if (_forumVCType == ForumVCTypePointsStore) {
            
             [_tableView registerNib:[UINib nibWithNibName:@"PointsSkuTableViewCell" bundle:nil] forCellReuseIdentifier:@"PointsSkuTableViewCell"];
            [_tableView registerNib:[UINib nibWithNibName:@"PointsSkuTableViewCell" bundle:nil] forCellReuseIdentifier:@"PointsSkuTableViewCell1"];
//            if (_momentRequestType == MomentRequestTypePointSkus) {
//                 [_tableView registerNib:[UINib nibWithNibName:@"PointsSkuTableViewCell" bundle:nil] forCellReuseIdentifier:@"PointsSkuTableViewCell"];
//
//            }else if (_momentRequestType == MomentRequestTypePointSkusExchages) {
//
//                [_tableView registerNib:[UINib nibWithNibName:@"PointsSkuExchangeTableViewCell" bundle:nil] forCellReuseIdentifier:@"PointsSkuExchangeTableViewCell"];
//            }
            
        }
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
