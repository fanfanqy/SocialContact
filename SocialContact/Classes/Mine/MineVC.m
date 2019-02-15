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
#import "UserInfoTableViewCell.h"
#import "GeRenZiLiaoVC.h"
#import "LoverConditionVC.h"


#import "SettingVC.h"

@interface MineVC ()<UITableViewDelegate,UITableViewDataSource,UserInfoTableViewCellDelegate>


INS_P_STRONG(InsLoadDataTablView *, tableView);
INS_P_STRONG(SCUserInfo *, userModel);

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)setUpUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF;
    [self.tableView setLoadNewData:^{
        
        [weakSelf getUserInfo];
    }];
    
    [self showLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getUserInfo];
    });
    
}

- (void)getUserInfo{

    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/customer/profile/" parameters:nil completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        [weakSelf.tableView endRefresh];
        
        if (!request.error) {
            weakSelf.userModel = [SCUserInfo modelWithDictionary:request.responseObject[@"data"]];
            [weakSelf.tableView reloadData];
        }else{
            
        }
    }];
    
    [InsNetwork addRequest:request];
    
}

- (void)geRenZiLiao{
    GeRenZiLiaoVC *vc = [GeRenZiLiaoVC new];
    vc.userModel = self.userModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)zeOuBiaoZhun{
    LoverConditionVC *vc = [LoverConditionVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)woYaoRenZheng{
    
}
- (void)shuiKanGuoWo{
    
}
- (void)fenXiangRuanJian{
    
}
- (void)dangQianJiFen{
    
}

- (void)shezhi{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoTableViewCellReuseID"];
        
        cell.delegate = self;
        cell.userModel = self.userModel;
        return cell;
        
    }else{
        
        NSString *leftImage;
        NSString *title;
        // 个人资料，择偶标准，我要认证，谁看过我，分享软件，当前积分
        MeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeListTableViewCellReuseID"];
        if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                leftImage = @"ic_info";
                title = @"个人资料";
            }else if (indexPath.row == 1) {
                leftImage = @"ic_love";
                title = @"择偶标准";
            }else if (indexPath.row == 2) {
                leftImage = @"ic_huiyuan";
                title = @"我要认证";
            }else if (indexPath.row == 3) {
                leftImage = @"ic_scan";
                title = @"谁看过我";
            }else if (indexPath.row == 4) {
                leftImage = @"ic_huiyuan";
                title = @"分享软件";
            }else if (indexPath.row == 5) {
                leftImage = @"icon_zican";
                title = @"当前积分";
            }
            cell.leftImgV.image = [UIImage imageNamed:leftImage];
            cell.titleLB.text = title;
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                leftImage = @"ic_setting";
                title = @"设置";
            }else if (indexPath.row == 1) {
                leftImage = @"";
                title = @"";
            }
            cell.leftImgV.image = [UIImage imageNamed:leftImage];
            cell.titleLB.text = title;
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
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
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                [self shezhi];
            }else if (indexPath.row == 1) {
                
            }
        }
            break;
        
            
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    return 4;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 6;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 132;
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    return 0.000001;
}

- (InsLoadDataTablView *)tableView {
    if ( !_tableView ) {
        _tableView = [[InsLoadDataTablView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, kScreenWidth, kScreenHeight - StatusBarHeight - UITabBarHeight ) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 15, _tableView.separatorInset.bottom, 15);
        _tableView.separatorColor = Line;
        _tableView.rowHeight = 55;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:@"UserInfoTableViewCellReuseID"];
        [_tableView registerNib:[UINib nibWithNibName:@"MeListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MeListTableViewCellReuseID"];
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
