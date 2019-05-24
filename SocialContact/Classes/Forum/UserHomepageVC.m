//
//  UserHomepageVC.m
//  SocialContact
//
//  Created by EDZ on 2019/1/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "UserHomepageVC.h"

#import "ForumVC.h"
#import "VipVC.h"
#import "DCIMChatViewController.h"
#import "UserFeedBackViewController.h"
#import "AuthenticationVC.h"

#import "UserInfoHomePageV2Cell.h"
#import "UserInfoHomePageCell.h"
#import "VipStatusCell.h"
#import "UserImagesCell.h"
#import "HorizontalScrollCell.h"
#import "SelectConditionCell.h"
#import "MeListTableViewCell.h"

#import "YYPhotoGroupView.h"
//#import "YYControl.h"

#import "ModifyUserInfoVC.h"

#import "XHPopMenu.h"
#import "WXApiRequestHandler.h"

#define NAVBAR_COLORCHANGE_POINT -1*kScreenWidth
#define NAV_HEIGHT GuaTopHeight
#define IMAGE_HEIGHT kScreenWidth
#define SCROLL_DOWN_LIMIT 0
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

@interface UserHomepageVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,VipStatusCellDelegate,HorizontalScrollCellDeleagte,KSPhotoBrowserDelegate>

@property (nonatomic, strong) XHPopMenu *popMenu;

@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;

@property(nonatomic,strong)SCUserInfo *userInfo;

//@property(nonatomic,strong) BottomToolView   *bottomToolView;

@property(nonatomic,strong) UIButton *chatBtn;
@property(nonatomic,strong) UIButton *guanZhuBtn;


@property(nonatomic,strong) InsLoadDataTablView *tableView;

//@property(nonatomic,strong) NSMutableArray *momentListArray;

@property(nonatomic,assign) NSInteger page;

//@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIButton *moreBtn;

@property(nonatomic,strong) NSMutableArray *showImagesArray;

INS_P_ASSIGN(CGFloat, introduceHeight);

INS_P_ASSIGN(BOOL, isSelf);

@end

@implementation UserHomepageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    
    // 自己才显示
    if ( (self.userInfo && [SCUserCenter sharedCenter].currentUser.userInfo.iD != self.userInfo.iD) || [SCUserCenter sharedCenter].currentUser.userInfo.iD != self.userId) {
        _isSelf = NO;
    }else{
        _isSelf = YES;
    }
    
    // UI 在后面判断
    
    [self setUpUI];
    
    if (_isSelf) {
        [self createCustomTitleView:nil  backgroundColor:nil  rightItem:nil backContainAlpha:YES];
    }else{
        [self createCustomTitleView:nil  backgroundColor:nil  rightItem:self.moreBtn backContainAlpha:YES];
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置状态栏背景字体颜色
    //(图片设置会导致全局白字,下面这句可以在个别界面设置成黑字)
    [self.cycleScrollView adjustWhenControllerViewWillAppera];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (UIButton *)chatBtn{
    if (!_chatBtn) {
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat top = kScreenHeight  - 50;
        if (IS_IPHONEX) {
            top -= iPhoneXVirtualHomeHeight;
        }
        _chatBtn.frame = CGRectMake(0, top, 106, 44);
        _chatBtn.centerX = kScreenWidth/2.0 - 15 - (53);
        _chatBtn.layer.cornerRadius = 22.f;
        _chatBtn.layer.masksToBounds = YES;
        [_chatBtn setTitle:@"对话" forState:UIControlStateNormal];
        _chatBtn.titleLabel.font = [UIFont systemFontOfSize:15];

        [_chatBtn setBackgroundImage:[UIImage imageNamed:@"rectangle_bg"] forState:UIControlStateNormal];
        [_chatBtn addTarget:self action:@selector(chatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}

- (void)chatBtnClick{
    
    
    
    if (self.userInfo) {
//        NSInteger userId = self.userInfo.user_id;
        
//        NSInteger targetId = _userInfo.user_id;
//        if (targetId == 0) {
//            targetId = _userInfo.iD;
//        }
        
        NSInteger targetId = _userInfo.iD;
        if (targetId == 0) {
            targetId = _userInfo.user_id;
        }
        
        DCIMChatViewController *vc = [[DCIMChatViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId: [NSString stringWithFormat:@"%ld",targetId]];
        vc.isActiveChat = YES;
        vc.title = self.userInfo.name;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self fetchData];
    }
    
    
}

- (UIButton *)guanZhuBtn{
    if (!_guanZhuBtn) {
        _guanZhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat top = kScreenHeight -50;
        if (IS_IPHONEX) {
            top -= iPhoneXVirtualHomeHeight;
        }
        _guanZhuBtn.frame = CGRectMake(0, top, 106, 44);
        _guanZhuBtn.centerX = kScreenWidth/2.0 + 15 + (53);
        _guanZhuBtn.layer.cornerRadius = 22.f;
        _guanZhuBtn.layer.masksToBounds = YES;
        _guanZhuBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_guanZhuBtn setTitle:@"加关注" forState:UIControlStateNormal];

        [_guanZhuBtn setBackgroundImage:[UIImage imageNamed:@"rectangle_bg"] forState:UIControlStateNormal];
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
            // 正在关注
            targetStatus = 1;
            break;
        case 0:
            // 未关注
            targetStatus = -1;
            break;
        case 1:
            // 去关注
            targetStatus = -1;
            break;
        case 2:
            // 去关注
            targetStatus = -1;
            break;
       
        default:
            break;
    }
    
    
    NSString *url = @"/customer/following/";
    WEAKSELF;
    if (self.userInfo.relation_status == -1){
        NSDictionary *para = @{@"customer_id": [NSNumber numberWithInteger:self.userInfo.iD],
                               @"status":@(targetStatus),
                               };
        POSTRequest *request = [POSTRequest requestWithPath:url parameters:para completionHandler:^(InsRequest *request) {
            
            if (!request.error) {
                
                [weakSelf.view makeToast:@"完成"];
//                [weakSelf.view makeToast:request.responseObject[@"msg"]?:@"操作成功"];
                weakSelf.userInfo.relation_status = targetStatus;
                [weakSelf refresh];
            }else{
                [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
                [SVProgressHUD dismissWithDelay:1.5];
            }
            
        }];
        [InsNetwork addRequest:request];
    }else{
        
        NSDictionary *para = @{@"customer_id": [NSNumber numberWithInteger:self.userInfo.iD],
                               };
        url = [NSString stringWithFormat:@"/customer/following/?customer_id=%ld",self.userInfo.iD];
        DELETERequest *request = [DELETERequest requestWithPath:url parameters:para completionHandler:^(InsRequest *request) {
            
            if (!request.error) {
                
                [weakSelf.view makeToast:@"完成"];
//                [weakSelf.view makeToast:request.responseObject[@"msg"]?:@"操作成功"];
                weakSelf.userInfo.relation_status = targetStatus;
                [weakSelf refresh];
                
                if (weakSelf.userInfo.relation_status == 0) {
                    [[RCIMClient sharedRCIMClient]removeFromBlacklist:[NSString stringWithFormat:@"%ld",weakSelf.userInfo.iD] success:^{
                        
                    } error:^(RCErrorCode status) {
                        
                    }];
                }
                
                
            }else{
                [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
                [SVProgressHUD dismissWithDelay:1.5];
            }
            
        }];
        [InsNetwork addRequest:request];
    }
    
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
        
        [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (void)moreBtnClick{
    [self.popMenu showMenuOnView:self.view atPoint:CGPointZero];
}

#pragma mark - Propertys

- (XHPopMenu *)popMenu {
    if (!_popMenu) {
        _popMenu.backgroundColor = Black;

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
                case 2: {
                    
                    title = @"分享";
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
            
            if (weakSelf.userInfo.iD) {
                
                if (index == 0) {
                    [weakSelf jubao];
                }else if (index == 1 ) {
                    [weakSelf lahei];
                }else if (index == 2 ) {
                    [weakSelf fenxiang];
                }
                
            }else{
                
                [weakSelf.view makeToast:@"请稍后重试"];
            }
            
        };
    }
    return _popMenu;
}

- (void)jubao{
    
    UserFeedBackViewController *vc = [UserFeedBackViewController new];
    vc.type = 0;
    vc.title = @"举报";
    vc.to_customer_id = self.userInfo.iD;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)lahei{
    
    WEAKSELF;
    

    NSDictionary *dic = @{
                          @"customer_id":[NSNumber numberWithInteger:self.userInfo.iD],
                          @"status":@(0),
                          };
    POSTRequest *request = [POSTRequest requestWithPath:@"/customer/following/" parameters:dic completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            
            [weakSelf.view makeToast:@"已屏蔽，不会再看到此人信息"];
            weakSelf.userInfo.relation_status = 0;
            [weakSelf refresh];
            
            [[RCIMClient sharedRCIMClient]addToBlacklist:[NSString stringWithFormat:@"%ld",weakSelf.userInfo.iD] success:^{
                
            } error:^(RCErrorCode status) {
                
            }];
        }
    }];
    [InsNetwork addRequest:request];
    
    
}

- (void)fenxiang{
    
    
    //    https://www.handanxiaohongniang.com/?invitecode=PQXWVFUR&from=groupmessage
    NSString *shareUrl = [NSString stringWithFormat:@"%@?invitecode=%@&from=groupmessage",kSCShareLinkURL,self.userInfo.invitecode];
    
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


- (void)setUpUI{
    
    self.showImagesArray = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.cycleScrollView;
    // 自己才显示
    if (!_isSelf) {
        [self.view addSubview:self.chatBtn];
        [self.view addSubview:self.guanZhuBtn];
    }
    
    WEAKSELF;
    [self.tableView setLoadNewData:^{
        
        [weakSelf fetchData];
    }];
    
    
    [self.tableView hideFooter];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchData];
    });
    
}

- (void)fetchData{
    
    [self showLoading];
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:[NSString stringWithFormat:@"customer/%ld/",_userId] parameters:nil completionHandler:^(InsRequest *request) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
      
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
                    [weakSelf showError:request.error reload:^{
                        [weakSelf fetchData];
                    }];
                }
            }
          });
    }];
    [InsNetwork addRequest:request];
    
}

- (void)refresh{
    
//    1.
    [self.showImagesArray removeAllObjects];
    
    if (self.userInfo.intro.length > 0) {
        self.introduceHeight = [[self.userInfo.intro stringByAppendingString:@"自我介绍："] heightForFont:[UIFont systemFontOfSize:15] width:kScreenWidth-40];
    }else{
        self.introduceHeight = 0;
    }

    for (NSInteger i=0; i<self.userInfo.images.count; i++) {
        NSString *tempUrl = self.userInfo.images[i];
        [self.showImagesArray addObject:tempUrl];
    }
    
    if (self.userInfo.images.count == 0) {
        NSString *avatar = self.userInfo.avatar_url;
        if (![avatar containsString:@"http"]) {
            avatar = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,avatar];
        }
        [self.showImagesArray addObject:avatar];
    }
    self.cycleScrollView.imageURLStringsGroup = self.showImagesArray;
    
    
//    2.关系
//    关注状态， -1：未关注， 0：屏蔽， 1：正在关注， 2：互相关注
    switch (self.userInfo.relation_status) {
        case 0:
            {
                [_guanZhuBtn setTitle:@"解除屏蔽" forState:UIControlStateNormal];
//                [_guanZhuBtn setImage:[UIImage imageNamed:@"ic_guanzhu_white"] forState:UIControlStateNormal];
            }
            break;
        case 1:
        {
            [_guanZhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
//            [_guanZhuBtn setImage:[UIImage imageNamed:@"ic_guanzhu_white"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [_guanZhuBtn setTitle:@"互相关注" forState:UIControlStateNormal];
//            [_guanZhuBtn setImage:[UIImage imageNamed:@"ic_guanzhu_white"] forState:UIControlStateNormal];
        }
            break;
            
        default:
        {
            [_guanZhuBtn setTitle:@"加关注" forState:UIControlStateNormal];
//            [_guanZhuBtn setImage:[UIImage imageNamed:@"ic_guanzhu_white"] forState:UIControlStateNormal];
        }
            break;
    }
    
//    3.
    [self.tableView reloadData];
}

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,  kScreenWidth, kScreenWidth)  delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.backgroundColor = BackGroundColor;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.currentPageDotColor = BLUE; // 自定义分页控件小圆标颜色
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 5;
//        //采用网络图片
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
//        });
    }
    return _cycleScrollView;
}

#pragma mark HorizontalScrollCellDeleagte
- (void)horizontalCellContentsView:(UICollectionView *)horizontalCellContentsView didSelectItemAtContentIndexPath:(NSIndexPath *)contentIndexPath inTableViewIndexPath:(NSIndexPath *)tableViewIndexPath{
    
    [self showImagesWithImg:contentIndexPath.item view:horizontalCellContentsView];
    
}

- (void)showImagesWithImg:(NSInteger)idx view:(UICollectionView *)collectionView{
    
    NSMutableArray *items = @[].mutableCopy;
    
    for (NSInteger i = 0; i < self.userInfo.images.count; i++) {
        // Get the large image url
        NSString *url = self.userInfo.images[i];
        if (![url containsString:@"http"]) {
            url = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,url];
        }
        UICollectionViewCell *fromView = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        UIImageView *imageV = fromView.contentView.subviews[0];
        
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageV imageUrl:[NSURL URLWithString:url]];
        [items addObject:item];
    }
    
    if (items.count > 0) {
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:idx];
        browser.delegate = self;
        browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
        browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
        browser.loadingStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
        [browser showFromViewController:[AppDelegate sharedDelegate].window.rootViewController];
    }
}

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index{
    
}

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didLongPressItem:(KSPhotoItem *)item atIndex:(NSUInteger)index{
    
    UIImage *image = [browser imageAtIndex:index];
    
    if (!image) {
        return;
    }
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    
    activityViewController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
        if (completed && !activityError) {
//            [SVProgressHUD showImage:AlertSuccessImage status:@"成功"];
//            [SVProgressHUD dismissWithDelay:1.5];
            [browser.view makeToast:@"操作完成" duration:2 position:CSToastPositionCenter];
        }
        
    };
    [browser presentViewController:activityViewController animated:YES completion:nil];
    
}


#pragma mark SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    

}

#pragma mark VipStatusCellDelegate
- (void)vipClicked{
    
 
    VipVC *vc = [[VipVC alloc]init];
    vc.userId = [SCUserCenter sharedCenter].currentUser.userInfo.iD;
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)goVip{
    VipVC *vc = [VipVC new];
    vc.type = 1;
    vc.userId = [SCUserCenter sharedCenter].currentUser.userInfo.iD;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)exchangeWechatClicked{
    
    if (_isSelf) {
        
        return;
    }
    
    if (![SCUserCenter sharedCenter].currentUser.userInfo.is_idcard_verified){
        
        [SVProgressHUD showImage:AlertErrorImage status:@"请先进行实名认证"];
        [SVProgressHUD dismissWithDelay:1.5];
        
        AuthenticationVC *vc = [[AuthenticationVC alloc]initWithNibName:@"AuthenticationVC" bundle:nil];
        vc.userModel = [SCUserCenter sharedCenter].currentUser.userInfo;
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    
    if ([NSString ins_String:[SCUserCenter sharedCenter].currentUser.userInfo.wechat_id]) {
        
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
        
        [self ask_wechat];
        
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
}

- (void)yueTaClicked{
    
    if (_isSelf) {
        
        return;
    }
    
    if (![SCUserCenter sharedCenter].currentUser.userInfo.isOnlineSwitch) {
        [self goVip];
        return;
    }
    

    
    if ([SCUserCenter sharedCenter].currentUser.userInfo.iD == self.userId) {
        return;
    }
    VipVC *vc = [VipVC new];
    vc.type = 3;
    vc.userId = self.userId;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)ask_wechat{
    
    if (_isSelf) {
        
        return;
    }
    
    //    /api/demands/ask_wechat/
    /*
     0    请求微信
     1    线上约她
     2    线下约她
     */
    [self showLoading];
    NSDictionary *dic = @{
                          @"to_customer_id":[NSNumber numberWithInteger:self.userId],
                          @"demand_type":@(0),
                          };
    WEAKSELF;
    POSTRequest *request = [POSTRequest requestWithPath:@"/api/demands/add_ask/" parameters:dic completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            [weakSelf.view makeToast:@"交换微信申请已发送"];
        }

    }];
    [InsNetwork addRequest:request];
}

- (void)yueTa{
    //    /api/demands/ask_date/
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y<StatusBarHeight) {
//        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    }else if (scrollView.contentOffset.y<kScreenWidth) {
//        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    }else{
//        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
//        UserInfoHomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoHomePageCell"];
//        cell.userInfo = self.userInfo;
//        return cell;
        
        UserInfoHomePageV2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoHomePageV2Cell"];
        cell.userInfo = self.userInfo;
        return cell;
        
    }else if (indexPath.section == 1) {
        
        HorizontalScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HorizontalScrollCell"];
        cell.delegate = self;
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.userInfo.images];
        cell.dataSource = array;
        cell.labelT.text = [NSString stringWithFormat:@"相册（共%ld张）",self.userInfo.images.count];
        cell.labelT.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        return cell;
        
    }else if (indexPath.section == 2) {
                UserInfoHomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoHomePageCell"];
                cell.userInfo = self.userInfo;
                return cell;
    
    }else if (indexPath.section == 3) {
        
        VipStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipStatusCell"];
        cell.delegate = self;
        
        if (self.userInfo.service_vip_expired_at) {
            
            NSDate *date = [self.userInfo.service_vip_expired_at sc_dateWithUTCString];
            NSTimeInterval interval = [date timeIntervalSinceNow];
            if (interval <= 0) {
                cell.vipDayCount.hidden = YES;
            }else{
                cell.vipDayCount.hidden = NO;
                if (interval < 3600*24) {
                    cell.vipDayCount.text = @"1天";
                }else{
                    
                    NSInteger count = interval/(3600*24) + 1;
                    cell.vipDayCount.text = [NSString stringWithFormat:@"%ld天",count];
                }
                
            }
        }
    
        return cell;
        
    }else if (indexPath.section == 4) {
        
        SelectConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectConditionCell"];
        cell.userInfo = self.userInfo;
        return cell;
        
    }else if (indexPath.section == 5) {
        
        MeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeListTableViewCell"];
        cell.titleLB.text = @"个人动态";
        cell.titleLB.textColor = Font_color333;
        cell.titleLB.font = [[UIFont systemFontOfSize:16]fontWithBold];
        cell.titleLBLeading.constant = -20;
        cell.rightImg.image = [UIImage imageNamed:@"homepage_rightArrow"];
        cell.rightImg.hidden = NO;
        return cell;
    }
    
    return nil;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
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
        
    }else if (section == 5) {
        
        return 1;
        
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        return 85;
        
    }else if (indexPath.section == 1) {
        
        return (kScreenWidth-20-6.0)/4.0 + 40;
        
    }else if (indexPath.section == 2) {
        
        if(kScreenWidth>375){
            return 220+self.introduceHeight;
        }else{
            return 260+self.introduceHeight;
        }
        
    }else if (indexPath.section == 3) {
        return 110;
        
    }else if (indexPath.section == 4) {
        
        return 500;
        
    }else if (indexPath.section == 5) {
        
        return 60;
        
    }
    return 0.00001;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 5) {
        ForumVC *vc = [ForumVC new];
        vc.title = [NSString stringWithFormat:@"%@的动态",self.userInfo.name];
        vc.momentUIType = MomentUITypeList;
        vc.momentRequestType = MomentRequestTypeUserList;
        vc.forumVCType = ForumVCTypeMoment;
        vc.uesrInfo = self.userInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 5) {
        return [UIView new];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 6)];
    view.backgroundColor = BackGroundColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 5) {
        return 0.0001;
    }
    return 6;
}

- (InsLoadDataTablView *)tableView {
    if ( !_tableView ) {
        CGRect rect = CGRectMake(0, 0, self.view.width, kScreenHeight);
        _tableView = [[InsLoadDataTablView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        if (!_isSelf) {
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, 90, 0);
            
        }
        
    
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"UserInfoHomePageV2Cell" bundle:nil] forCellReuseIdentifier:@"UserInfoHomePageV2Cell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"VipStatusCell" bundle:nil] forCellReuseIdentifier:@"VipStatusCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"UserImagesCell" bundle:nil] forCellReuseIdentifier:@"UserImagesCell"];
        
        [_tableView registerClass:[HorizontalScrollCell class] forCellReuseIdentifier:@"HorizontalScrollCell"];
        
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
