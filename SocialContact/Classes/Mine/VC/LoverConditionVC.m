//
//  LoverConditionVC.m
//  SocialContact
//
//  Created by EDZ on 2019/1/19.
//  Copyright © 2019 ha. All rights reserved.
//

#import "LoverConditionVC.h"

@interface LoverConditionVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView *tableFooterView;

@property (strong, nonatomic) UIButton *okBtn;

@property (strong, nonatomic) UIButton *resetBtn;

INS_P_STRONG(InsLoadDataTablView *, tableView);

@property (assign, nonatomic) NSInteger age;

@property (assign, nonatomic) NSInteger gender;

@property (assign, nonatomic) NSInteger height;

@property (assign, nonatomic) NSInteger weight;

@property (assign, nonatomic) NSInteger education;


@end

@implementation LoverConditionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)configUI{
    self.title = @"择偶标准";
    [self.view addSubview:self.tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingcell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingcell"];
        
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"年龄";
        }
        if (indexPath.row == 1) {
            
            cell.textLabel.text = @"身高";
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"工作职业";
        }
        if (indexPath.row == 1) {
            
            cell.textLabel.text = @"年龄收入";
        }
        if (indexPath.row == 2) {
            
            cell.textLabel.text = @"婚姻状况";
        }
        if (indexPath.row == 3) {
            
            cell.textLabel.text = @"有无子女";
        }
        if (indexPath.row == 4) {
            
            cell.textLabel.text = @"打算几年内结婚";
        }
    }
    
    
    return cell;
}

- (void)pickerTitle:(NSString *)title{
    
    if ([title isEqualToString:@"出生日期"]) {
        NSDate *now = [NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *nowStr = [fmt stringFromDate:now];
        
        [CGXPickerView showDatePickerWithTitle:@"出生日期" DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:@"1900-01-01 00:00:00" MaxDateStr:nowStr IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
            NSLog(@"%@",selectValue);
            
        }];
        
    }else if ([title isEqualToString:@"性别"]){
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStyleGender] objectAtIndex:1];
        [CGXPickerView showStringPickerWithTitle:@"性别" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
        } Style:CGXStringPickerViewStyleGender];
    }else if ([title isEqualToString:@"身高"]){
        
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylHeight] objectAtIndex:3];
        [CGXPickerView showStringPickerWithTitle:@"身高" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            
        } Style:CGXStringPickerViewStylHeight];
    }else if ([title isEqualToString:@"体重"]){
        
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylWeight] objectAtIndex:3];
        [CGXPickerView showStringPickerWithTitle:@"体重" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            
        } Style:CGXStringPickerViewStylWeight];
    }else if ([title isEqualToString:@"教育"]){
        
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStyleEducation] objectAtIndex:1];
        [CGXPickerView showStringPickerWithTitle:@"教育" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@--%@",selectValue,selectRow);
            
        } Style:CGXStringPickerViewStyleEducation];
    }else if ([title isEqualToString:@"工作地址"]){
        [CGXPickerView showAddressPickerWithTitle:@"请选择你的城市" DefaultSelected:@[@4, @0,@0] IsAutoSelect:YES Manager:nil ResultBlock:^(NSArray *selectAddressArr, NSArray *selectAddressRow) {
            NSLog(@"%@-%@",selectAddressArr,selectAddressRow);
            
        }];
    }else if ([title isEqualToString:@"家庭地址"]){
        [CGXPickerView showAddressPickerWithTitle:@"请选择你的城市" DefaultSelected:@[@0,@0] IsAutoSelect:YES Manager:nil ResultBlock:^(NSArray *selectAddressArr, NSArray *selectAddressRow) {
            NSLog(@"%@-%@",selectAddressArr,selectAddressRow);
            
        }];
    }
    else if ([title isEqualToString:@"工作职业"]){
        [CGXPickerView showStringPickerWithTitle:@"工作职业" DataSource:@[@"未知", @"事业单位", @"政府机关", @"私营企业", @"自由职业", @"其他"] DefaultSelValue:@"未知" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
        }];
    }else if ([title isEqualToString:@"收入描述"]){
        [CGXPickerView showStringPickerWithTitle:@"红豆" DataSource:@[@"很好的", @"干干", @"高度", @"打的", @"都怪怪的", @"博对"] DefaultSelValue:@"高度" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
        }];
    }else if ([title isEqualToString:@"婚姻状况"]){
        [CGXPickerView showStringPickerWithTitle:@"红豆" DataSource:@[@"很好的", @"干干", @"高度", @"打的", @"都怪怪的", @"博对"] DefaultSelValue:@"高度" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
        }];
    }else if ([title isEqualToString:@"有无子女"]){
        [CGXPickerView showStringPickerWithTitle:@"红豆" DataSource:@[@"很好的", @"干干", @"高度", @"打的", @"都怪怪的", @"博对"] DefaultSelValue:@"高度" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
        }];
    }else if ([title isEqualToString:@"打算几年内结婚"]){
        [CGXPickerView showStringPickerWithTitle:@"红豆" DataSource:@[@"很好的", @"干干", @"高度", @"打的", @"都怪怪的", @"博对"] DefaultSelValue:@"高度" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
        }];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            [self pickerTitle:@"出生日期"];
        }
        if (indexPath.row == 1) {
            
            [self pickerTitle:@"身高"];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            [self pickerTitle:@"工作职业"];
        }
        if (indexPath.row == 1) {
            
            [self pickerTitle:@"收入描述"];
        }
        if (indexPath.row == 2) {
            
            [self pickerTitle:@"婚姻状况"];
            
        }
        if (indexPath.row == 3) {
            
            [self pickerTitle:@"有无子女"];
        }
        if (indexPath.row == 4) {
            
            [self pickerTitle:@"打算几年内结婚"];
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 10;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableFooterView{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        [_tableFooterView addSubview:self.okBtn];
        [_tableFooterView addSubview:self.resetBtn];
    }
   
    return _tableFooterView;
}

- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBtn.top = 30;
        _okBtn.left = 20;
        _okBtn.width = (kScreenWidth - 80)/2.0;
        _okBtn.height = 48;
        _okBtn.layer.cornerRadius = 8;
        _okBtn.layer.masksToBounds = YES;
        _okBtn.layer.borderWidth = 1;
        _okBtn.layer.borderColor = UIColorHex(63D190).CGColor;
        _okBtn.centerX = self.view.centerX;
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_okBtn setTitleColor:UIColorHex(63D190) forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

- (UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetBtn.top = 30;
        _resetBtn.width = (kScreenWidth - 80)/2.0;
        _resetBtn.right = kScreenWidth-20;
        _resetBtn.height = 48;
        _resetBtn.layer.cornerRadius = 8;
        _resetBtn.layer.masksToBounds = YES;
        _resetBtn.layer.borderWidth = 1;
        _resetBtn.layer.borderColor = UIColorHex(63D190).CGColor;
        _resetBtn.centerX = self.view.centerX;
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn setTitleColor:UIColorHex(63D190) forState:UIControlStateNormal];
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_resetBtn addTarget:self action:@selector(resetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

- (void)okBtnClick{

}

- (void)resetBtnClick{
    
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
        _tableView.tableFooterView = self.tableFooterView;
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
