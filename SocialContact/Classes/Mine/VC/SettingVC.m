//
//  SettingVC.m
//  GuaGua
//
//  Created by fqy on 2018/5/31.
//  Copyright © 2018年 HuangDeng. All rights reserved.
//

#import "SettingVC.h"
#import "RetrieveViewController.h"
#import "FeedBackVC.h"
#import "AbountUsVC1.h"

@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIButton *loginoutBtn;

INS_P_STRONG(InsLoadDataTablView *, tableView);

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI{
	self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingcell"];
	if (!cell) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingcell"];
		
	}
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"修改密码";
        }
        else if (indexPath.row == 1) {
            
            cell.textLabel.text = @"建议和反馈";
        }
        else if (indexPath.row == 2) {
            
            cell.textLabel.text = @"关于我们";
        }
       
    }else if (indexPath.section == 1) {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"settingcellLoginOut"];
        if (!cell1) {
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingcellLoginOut"];
            
        }
        cell1.textLabel.text = @"退出登录";
        cell1.textLabel.font = [UIFont systemFontOfSize:15];
        cell1.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell1;
    }
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            RetrieveViewController *vc = [RetrieveViewController new];
            vc.phone = [SCUserCenter sharedCenter].currentUser.userInfo.account;
            vc.phoneTF.text = [SCUserCenter sharedCenter].currentUser.userInfo.account;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 1) {
            FeedBackVC *vc = [FeedBackVC new];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 2) {
            AbountUsVC1 *vc = [[AbountUsVC1 alloc]initWithNibName:@"AbountUsVC1" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1) {
        [self loginOut];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
	return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        view.backgroundColor = BackGroundColor;
        return view;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

//- (UIButton *)loginoutBtn{
//    if (!_loginoutBtn) {
//        _loginoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _loginoutBtn.top = 30;
//        _loginoutBtn.left = 40;
//        _loginoutBtn.width = 200;
//        _loginoutBtn.height = 48;
//        _loginoutBtn.layer.cornerRadius = 8;
//        _loginoutBtn.layer.masksToBounds = YES;
//        _loginoutBtn.layer.borderWidth = 1;
//        _loginoutBtn.layer.borderColor = BLUE.CGColor;
//        _loginoutBtn.centerX = self.view.centerX;
//        [_loginoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//        [_loginoutBtn setTitleColor:BLUE forState:UIControlStateNormal];
//        _loginoutBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//        [_loginoutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _loginoutBtn;
//}

- (void)loginOut{
	
//    [[AppDelegate sharedDelegate].window makeToast:@"成功退出登录" duration:2 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
//        [[AppDelegate sharedDelegate]configRootVC];
//    }];
	
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/customer/logout/" parameters:nil completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            
            [[AppDelegate sharedDelegate].window makeToast:@"成功退出登录"];
            
            [SCUserCenter sharedCenter].currentUser = nil;
            [SCUserCenter sharedCenter].XCSRFToken = nil;
            [[SCUserCenter sharedCenter].currentUser updateToDB];
            
            [LKDBHelper clearTableData:[SCUserInfo class]];
            [LKDBHelper clearTableData:[RCUserInfo class]];
            
            // 断开融云连接
            [[RCIM sharedRCIM] logout];
            [[RCIM sharedRCIM] clearUserInfoCache];
            [[RCIM sharedRCIM] clearGroupInfoCache];
            [[RCIM sharedRCIM] clearGroupUserInfoCache];
            
            [[AppDelegate sharedDelegate] configRootVC];
        }
        
    }];
    [InsNetwork addRequest:request];
    
}

- (InsLoadDataTablView *)tableView {
    if ( !_tableView ) {
        _tableView = [[InsLoadDataTablView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - GuaTopHeight ) style:UITableViewStylePlain];
        _tableView.backgroundColor = BackGroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 0, _tableView.separatorInset.bottom, 0);
        _tableView.separatorColor = Line;
        _tableView.rowHeight = 55;
        _tableView.tableFooterView = self.loginoutBtn;
    }
    return _tableView;
}

@end
