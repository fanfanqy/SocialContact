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

#import "TopicCell.h"
#import "TopicListsHeaderView.h"
//#import "BottomToolView.h"
#import "NewDynamicsTableViewCell.h"

#import "NearByUserCell.h"

#import "DCIMGroupConversationViewController.h"

#import "TopicModel.h"
#import "Notice.h"
#import "WhoLookMeModel.h"
#import "UserPointsModel.h"

#import "XHInputView.h"

@interface ForumVC ()<UITableViewDelegate,UITableViewDataSource,NearByUserCellDelegate>



@property(nonatomic,strong) TopicListsHeaderView *topicListsHeaderView;


//@property(nonatomic,strong) BottomToolView   *bottomToolView;
@property(nonatomic,strong) UIButton *participateTopicBtn;
@property(nonatomic,strong) UIButton *joinDiscussion;

@property(nonatomic,strong) UILabel *sendCommentLB;
@property(nonatomic,strong) UIButton *sendCommentButton;


@property(nonatomic,strong) NSMutableArray *array;

@property(nonatomic,strong) NSMutableArray *commentArray;

@property(nonatomic,assign) NSInteger page;

@end

@implementation ForumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}

- (void)setUpUI{
    
    [self.view addSubview:self.tableView];
    
    if (_momentRequestType == MomentRequestTypeTopicList) {
        
//        [self.view addSubview:self.bottomToolView];
        [self.view addSubview:self.participateTopicBtn];
        [self.view addSubview:self.joinDiscussion];
    }
    if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
        UIView *line = [UIView new];
        line.backgroundColor = Line;
        if (IS_IPHONEX) {
            line.frame = CGRectMake(kMomentContentInsetLeft, kScreenHeight-GuaTopHeight-iPhoneXVirtualHomeHeight-40, kScreenWidth-100, 0.3);
        }else{
            line.frame = CGRectMake(kMomentContentInsetLeft, kScreenHeight-GuaTopHeight-40, kScreenWidth-60, 0.3);
        }
        
        [self.view addSubview:self.sendCommentLB];
        [self.view addSubview:self.sendCommentButton];
        [self.view addSubview:line];
    }
    
    self.array = [NSMutableArray array];
    
    @weakify(self);
    [self.tableView setLoadNewData:^{
        @normalize(self);
        [self fetchData:YES];
        
    }];

    [self.tableView setLoadMoreData:^{
        @normalize(self);
        if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
            
            [self fetchCommentData:NO];
        }else{
            [self fetchData:NO];
        }
    }];
    
    [self.tableView hideFooter];
    [self showLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchData:YES];
    });
    
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
                    [weakSelf.view makeToast:request.error.localizedDescription];
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
            _sendCommentButton.frame = CGRectMake(kScreenWidth-80, kScreenHeight-GuaTopHeight-35-iPhoneXVirtualHomeHeight, 60, 40);
        }else{
           _sendCommentButton.frame = CGRectMake(kScreenWidth-80, kScreenHeight-GuaTopHeight-35, 60, 30);
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
    WEAKSELF;
    NSDictionary *param = nil;
    NSString *url = @"";
    if (_forumVCType ==  ForumVCTypeTopic || _forumVCType ==  ForumVCTypeTopicSelect) {
        url = @"/moments/topic/";
    }else if (_forumVCType == ForumVCTypeMoment || _forumVCType == ForumVCTypeNoticeOrNearBy) {
        if (refresh) {
            _page = 1;
        }else{
            _page ++;
        }
        // 详情页利用上层传入的模型
        if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
            
            [self.array removeAllObjects];
            if (self.momentModel) {
                NewDynamicsLayout *layout = [[NewDynamicsLayout alloc]initWithModel:self.momentModel momentUIType:self.momentUIType momentRequestType:self.momentRequestType];
                [self.array addObject:layout];
                [self.tableView reloadData];
            }
            [self fetchCommentData:YES];
            [self fetchLikeUserData];
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
                url = @"/customer/followinglist/";
                param = @{@"page": [NSNumber numberWithInteger:_page]};
                break;
                
            case MomentRequestTypeFollows:
                url = @"/customer/followerslist/";
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
            
            if (weakSelf.forumVCType ==  ForumVCTypeTopic || weakSelf.forumVCType ==  ForumVCTypeTopicSelect) {
                
                
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [weakSelf.array addObject:[TopicModel modelWithDictionary:obj]];
                    
                }];
                [weakSelf.tableView reloadData];
                
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
                    
                }
                
                [weakSelf.tableView reloadData];
                
                
            }else if (weakSelf.forumVCType == ForumVCTypeMoment) {
                
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MomentModel *momentModel = [MomentModel modelWithDictionary:obj];
                    NewDynamicsLayout *layout = [[NewDynamicsLayout alloc]initWithModel:momentModel momentUIType:weakSelf.momentUIType momentRequestType:weakSelf.momentRequestType];
                    [weakSelf.array addObject:layout];
                    
                }];
                
                if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
                    if (self.commentArray.count > 0) {
                        NewDynamicsLayout *layout = weakSelf.array[0];
                        layout.commentLayoutArr = self.commentArray;
                        [layout resetLayout];
                        [weakSelf.tableView reloadData];
                    }
                }else{
                    [weakSelf.tableView reloadData];
                }

                
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
                    [weakSelf showError:request.error reload:nil];
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
        
        if (!request.error) {
            
            NSArray *resultArray = request.responseObject[@"data"][@"results"];
        
            if ( resultArray && resultArray.count > 0 ) {
                
                if (resultArray.count == 10) {
                    [weakSelf.tableView showFooter];
                } else {
                    [weakSelf.tableView hideFooter];
                }
                
                NSMutableArray *commentArray = [NSMutableArray array];
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CommentModel *commentModel = [CommentModel modelWithDictionary:obj];
                    CommentLayout *layout = [[CommentLayout alloc]initWithModel:commentModel];
                    [commentArray addObject:layout];
                    
                }];
                
                NewDynamicsLayout *layout = weakSelf.array[0];
                layout.commentLayoutArr = commentArray;
                [layout resetLayout];
                
                [weakSelf.tableView reloadData];
            }
        }else{
            if ( weakSelf.page > 1 ) {
                weakSelf.page --;
            }
            
            if (weakSelf.commentArray.count > 0 || weakSelf.array.count > 0) {
                [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
                [SVProgressHUD dismissWithDelay:1.5];
            } else {
                [weakSelf showError:request.error reload:nil];
            }
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
        }
    }];
    [InsNetwork addRequest:request];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_forumVCType ==  ForumVCTypeTopic || _forumVCType ==  ForumVCTypeTopicSelect) {
        TopicModel *topicModel = self.array[indexPath.row];
        TopicCell *cell = (TopicCell *)[tableView dequeueReusableCellWithIdentifier:@"TopicCell"];
        [cell.imgV setImageWithURL:[NSURL URLWithString:topicModel.logo_url] placeholder:nil options:YYWebImageOptionProgressive completion:nil];
        cell.titleLB.text = topicModel.name;
        cell.contentLB.text = topicModel.desc;
        return cell;
    }else if (self.forumVCType == ForumVCTypeNoticeOrNearBy) {
        
        NearByUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearByUserCell"];
        cell.delegate = self;
        
        if (self.momentRequestType == MomentRequestTypeNotice) {
            Notice *notice = self.array[indexPath.row];
            cell.notice = notice;
            
        }else if (self.momentRequestType == MomentRequestTypeNearby) {
            SCUserInfo *userInfo = self.array[indexPath.row];
            cell.userInfo = userInfo;
            
        }else if (self.momentRequestType == MomentRequestTypeWhoLookMe){
            WhoLookMeModel *model = self.array[indexPath.row];
            cell.lookMeModel = model;
            
        }else if (self.momentRequestType == MomentRequestTypeJiFenList){
            
            
            
        }
        return cell;
        
    }else if (_forumVCType == ForumVCTypeMoment) {
        
        NewDynamicsLayout *layout = self.array[indexPath.row];
        NewDynamicsTableViewCell *cell = (NewDynamicsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"NewDynamicsTableViewCell-%ld",_momentRequestType]];
        [cell setLayout:layout];
        cell.delegate = self;
        cell.indexPath = indexPath;
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
            vc.height = kScreenHeight-StatusBarHeight-50-UITabBarHeight;
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
             vc.title = @"动态详情";
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
            if (self.fatherVC) {
                [self.fatherVC.navigationController pushViewController:vc animated:YES];
            }else{
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if (self.momentRequestType == MomentRequestTypeWhoLookMe){
            
            WhoLookMeModel *model = self.array[indexPath.row];
            UserHomepageVC *vc = [UserHomepageVC new];
            vc.userId = model.customer.iD;
            if (self.fatherVC) {
                [self.fatherVC.navigationController pushViewController:vc animated:YES];
            }else{
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if (self.momentRequestType == MomentRequestTypeJiFenList){
            
        }
        
    }else if (self.forumVCType == ForumVCTypeMoment) {
        /*
         MomentRequestTypeMyMomentDetail = 6,//他人的动态详情
         MomentRequestTypeUserMomentDetail = 7,//他人的动态详情
         */
        if ( _momentRequestType == MomentRequestTypeUserMomentDetail || _momentRequestType == MomentRequestTypeMyMomentDetail) {
            return;
        }
        
        
        
    }
}

- (void)clickAvatarImg:(NSInteger)userID{
    
    UserHomepageVC *vc = [UserHomepageVC new];
    vc.userId = userID;
    if (self.fatherVC) {
        [self.fatherVC.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

/**
 设置为已读
 */
- (void)setReadStatus:(NSInteger)iD{
    
//    /notices/<int:pk>/
    PUTRequest *request = [PUTRequest requestWithPath:[NSString stringWithFormat:@"/notices/%ld"] parameters:nil completionHandler:^(InsRequest *request) {
        
        if (!request.error) {
            
            
            
        }else{
            
        }
        
    }];
    [InsNetwork addRequest:request];
    
}

- (TopicListsHeaderView *)topicListsHeaderView{
    if (!_topicListsHeaderView) {
        _topicListsHeaderView = [[NSBundle mainBundle]loadNibNamed:@"TopicListsHeaderView" owner:nil options:nil][0];
        _topicListsHeaderView.topicModel = self.topicModel;
    }
    
    return _topicListsHeaderView;
    
}


// 立即参与
-(void)partiClick{
    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
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
            [SVProgressHUD showWithStatus:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:2];
        }
    }];
    [InsNetwork addRequest:request];
}


//- (BottomToolView *)bottomToolView {
//    
//    if (!_bottomToolView) {
//        _bottomToolView = [[NSBundle mainBundle]loadNibNamed:@"BottomToolView" owner:nil options:nil][0];
//        CGFloat top = kScreenHeight - GuaTopHeight;
//        _bottomToolView.frame = CGRectMake(0, top , kScreenWidth, 50);
//        _bottomToolView.delegate = self;
//    }
//    return _bottomToolView;
//}

- (UIButton *)participateTopicBtn{
    if (!_participateTopicBtn) {
        _participateTopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat top = kScreenHeight - GuaTopHeight - 50;
        if (IS_IPHONEX) {
            top -= iPhoneXVirtualHomeHeight;
        }
        _participateTopicBtn.frame = CGRectMake(0, top, 0.4*kScreenWidth-10, 44);
        _participateTopicBtn.centerX = 0.1*kScreenWidth+(0.2*kScreenWidth-5);
        _participateTopicBtn.layer.cornerRadius = 22.f;
        _participateTopicBtn.layer.masksToBounds = YES;
        [_participateTopicBtn setTitle:@"立即参与" forState:UIControlStateNormal];
        _participateTopicBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_participateTopicBtn setBackgroundImage:[UIImage imageWithColor:BLUE] forState:UIControlStateNormal];
        [_participateTopicBtn addTarget:self action:@selector(partiClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _participateTopicBtn;
}


- (UIButton *)joinDiscussion{
    if (!_joinDiscussion) {
        _joinDiscussion = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat top = kScreenHeight - GuaTopHeight-50;
        if (IS_IPHONEX) {
            top -= iPhoneXVirtualHomeHeight;
        }
        _joinDiscussion.frame = CGRectMake(0, top, 0.4*kScreenWidth-10, 44);
        _joinDiscussion.centerX = kScreenWidth - 0.1*kScreenWidth - (0.2*kScreenWidth-5);
        _joinDiscussion.layer.cornerRadius = 22.f;
        _joinDiscussion.layer.masksToBounds = YES;
        [_joinDiscussion setTitle:@"加入讨论" forState:UIControlStateNormal];
        _joinDiscussion.titleLabel.font = [UIFont systemFontOfSize:14];
        [_joinDiscussion setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
        [_joinDiscussion addTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinDiscussion;
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
        
        if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
            _tableView.height -= 40;
        }
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
            
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
        }else{
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            _tableView.separatorColor = Line;
        }
        [_tableView setSeparatorInset:UIEdgeInsetsMake(_tableView.separatorInset.top, 15, _tableView.separatorInset.bottom, 15)];
        _tableView.tableFooterView = [UIView new];
//        if (IS_IPHONEX) {
//            _tableView.contentInset = UIEdgeInsetsMake(0, 0, iPhoneXVirtualHomeHeight, 0);
//        }
        if (_forumVCType ==  ForumVCTypeTopic || _forumVCType ==  ForumVCTypeTopicSelect) {
            [_tableView registerNib:[UINib nibWithNibName:@"TopicCell" bundle:nil] forCellReuseIdentifier:@"TopicCell"];
        }else if (self.forumVCType == ForumVCTypeNoticeOrNearBy) {
            
            [_tableView registerNib:[UINib nibWithNibName:@"NearByUserCell" bundle:nil] forCellReuseIdentifier:@"NearByUserCell"];
            
        }else if (_forumVCType == ForumVCTypeMoment) {
            if (_momentRequestType == MomentRequestTypeTopicList) {
                _tableView.tableHeaderView = self.topicListsHeaderView;
//                // 50 高度
//                [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
            }
            [_tableView registerClass:[NewDynamicsTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"NewDynamicsTableViewCell-%ld",_momentRequestType]];
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
