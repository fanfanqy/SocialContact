//
//  SettingVC.m
//  GuaGua
//
//  Created by fqy on 2018/5/31.
//  Copyright © 2018年 HuangDeng. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIButton *loginoutBtn;

INS_P_STRONG(InsLoadDataTablView *, tableView);

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)configUI{
	self.title = @"系统设置";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingcell"];
	if (!cell) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingcell"];
		
	}
	if (indexPath.row == 0) {
		
		cell.textLabel.text = @"修改密码";
	}
	if (indexPath.row == 1) {
		
		cell.textLabel.text = @"建议和反馈";
	}
	if (indexPath.row == 2) {
		
		cell.textLabel.text = @"赞助开发";
	}
    if (indexPath.row == 3) {
        
        cell.textLabel.text = @"关于我们";
    }
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.001;
}

- (UIButton *)loginoutBtn{
	if (!_loginoutBtn) {
		_loginoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_loginoutBtn.top = 30;
		_loginoutBtn.left = 40;
		_loginoutBtn.width = kScreenWidth - 80;
		_loginoutBtn.height = 48;
		_loginoutBtn.layer.cornerRadius = 8;
		_loginoutBtn.layer.masksToBounds = YES;
		_loginoutBtn.layer.borderWidth = 1;
		_loginoutBtn.layer.borderColor = UIColorHex(63D190).CGColor;
		_loginoutBtn.centerX = self.view.centerX;
		[_loginoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
		[_loginoutBtn setTitleColor:UIColorHex(63D190) forState:UIControlStateNormal];
		_loginoutBtn.titleLabel.font = [UIFont systemFontOfSize:18];
		[_loginoutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
	}
	return _loginoutBtn;
}

- (void)loginOut{
	
//    [[AppDelegate sharedDelegate].window makeToast:@"成功退出登录" duration:2 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
//        [[AppDelegate sharedDelegate]configRootVC];
//    }];
	
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
        _tableView.tableFooterView = self.loginoutBtn;
    }
    return _tableView;
}

@end
