//
//  GeRenZiLiaoVC.m
//  SocialContact
//
//  Created by EDZ on 2019/1/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import "LoverConditionVC.h"
#import "SCUserInfo.h"
#import "MeListTableViewCell.h"
#import "UserAvatarCell.h"

#import "ModifyUserInfoVC.h"
#import "CGXStringPickerView.h"

@interface LoverConditionVC()<UITableViewDelegate,UITableViewDataSource>

INS_P_STRONG(InsLoadDataTablView *, tableView);

INS_P_STRONG(UIView *, footerView);

INS_P_STRONG(UIButton *, resetBtn);

INS_P_STRONG(UIButton *, doneBtn);

@end

@implementation LoverConditionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!self.title) {
        self.title = @"择偶标准";
    }
    
    if (self.title) {
        self.userModel = [SCUserInfo new];
    }
    
    [self setUpUI];
    
    if (![self.title isEqualToString:@"筛选"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    }
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)done{
//    /customer/profile/
    WEAKSELF;
    
#pragma mark TODO 增加type
    
    // 择偶标准是我的界面，筛选是首页
    if ([self.title isEqualToString:@"筛选"]) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(selectCondition:)]) {
            [_delegate selectCondition:self.userModel.condition];
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    
    // 没用到，但是后端返回了，这里补上
    NSMutableDictionary *dicTemp = [NSMutableDictionary dictionaryWithDictionary:self.userModel.condition];
    [dicTemp setObject:@(0) forKey:@"education"];
    self.userModel.condition = dicTemp;
    NSString *str = [self dictionaryToJson:self.userModel.condition];
    NSDictionary *dic = @{
                          @"condition":str,
                          };
    
    
    POSTRequest *request = [POSTRequest requestWithPath:@"/customer/profile/" parameters:dic completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            weakSelf.userModel = [SCUserInfo modelWithDictionary:request.responseObject[@"data"]];
            
            
            [weakSelf.userModel updateToDB];
            [SCUserCenter sharedCenter].currentUser.userInfo = weakSelf.userModel;
            [[SCUserCenter sharedCenter].currentUser updateToDB];
            
            
            [weakSelf.view makeToast:@"设置完成"];
            [weakSelf.tableView reloadData];
            
            
        }
    }];
    [InsNetwork addRequest:request];
    
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView new];
        _footerView.frame = CGRectMake(0, 0, kScreenWidth, 54);
        [_footerView addSubview:self.resetBtn];
        [_footerView addSubview:self.doneBtn];
    }
    return _footerView;
}

- (UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetBtn.frame = CGRectMake(0, 10, 106, 44);
        _resetBtn.centerX = kScreenWidth/2.0 - 15 - (53);
        _resetBtn.layer.cornerRadius = 22.f;
        _resetBtn.layer.masksToBounds = YES;
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn setBackgroundImage:[UIImage imageNamed:@"rectangle_bg"] forState:UIControlStateNormal];
        [_resetBtn addTarget:self action:@selector(resetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

- (void)resetBtnClick{
    self.userModel = [SCUserInfo new];
    [self.tableView reloadData];
}

- (UIButton *)doneBtn{
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneBtn.frame = CGRectMake(0, 10, 106, 44);
        _doneBtn.centerX = kScreenWidth/2.0 + 15 + (53);
        _doneBtn.layer.cornerRadius = 22.f;
        _doneBtn.layer.masksToBounds = YES;
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setBackgroundImage:[UIImage imageNamed:@"rectangle_bg"] forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

- (void)setUpUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = self.footerView;
    
    if ([self.title isEqualToString:@"择偶标准"]) {
        WEAKSELF;
        [self.tableView setLoadNewData:^{
            
            [weakSelf getUserInfo];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getUserInfo];
        });
    }
}

- (void)saveUserInfo{
    
}

- (void)getUserInfo{
    
    [self showLoading];
    WEAKSELF;
    [SCUserCenter getSelfInformationAndUpdateDBWithUserId:[SCUserCenter sharedCenter].currentUser.userInfo.iD completion:^(id  _Nonnull responseObj, BOOL succeed, NSError * _Nonnull error) {
       
        [weakSelf hideLoading];
        [weakSelf.tableView endRefresh];
        weakSelf.userModel = [SCUserCenter sharedCenter].currentUser.userInfo;
        [weakSelf.tableView reloadData];
        
    }];
    
}

- (void)clickIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title;
    switch (indexPath.section) {
        case 0:
        {
            
             if (indexPath.row == 0) {
                
                title = @"年龄";
            }else if (indexPath.row == 1) {
                
                title = @"身高";
            }else if (indexPath.row == 2) {
                
                title = @"房产";
            }else if (indexPath.row == 3) {
                
                title = @"车辆";
            }
            
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                
                title = @"学历";
            }else if (indexPath.row == 1) {
                
                title = @"工作职业";
            }else if (indexPath.row == 2) {
                
                title = @"月收入";
            }else if (indexPath.row == 3) {
                
                title = @"婚姻状况";
            }else if (indexPath.row == 4) {
                
                title = @"有无子女";
            }else if (indexPath.row == 5) {
                
                title = @"打算几年内结婚";
            }
        }
            break;
            
            
        default:
            break;
    }
    
    if (title) {
        [self pickerTitle:title];
    }
}


- (void)pickerTitle:(NSString *)title{
    WEAKSELF;
    if ([title isEqualToString:@"年龄"]){
    
        [CGXPickerView showStringPickerWithTitle:@"年龄" DataSource:@[[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStyleAge],[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStyleAge]] DefaultSelValue:nil IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {

            NSString *ageStart = selectValue[0];
            NSString *ageEnd = selectValue[1];

            if (![ageStart containsString:@"不限"] && ![ageEnd containsString:@"不限"]) {
                NSInteger age1;
                NSInteger age2;
                age1 = [selectRow[0] integerValue] + 18;
                age2 = [selectRow[1] integerValue] + 18;
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.userModel.condition];
                [dic setObject:@[@(age1),@(age2)] forKey:@"age_range"];
                
                weakSelf.userModel.condition = dic;
                [weakSelf.tableView reloadData];
            }else{
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.userModel.condition];
                [dic setObject:@[] forKey:@"age_range"];

                weakSelf.userModel.condition = dic;
                [weakSelf.tableView reloadData];
            }

        }];
        
    }else if ([title isEqualToString:@"身高"]){
        
        [CGXPickerView showStringPickerWithTitle:@"身高" DataSource:@[[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylHeight],[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylHeight]] DefaultSelValue:nil IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            
            NSString *heightStart = selectValue[0];
            NSString *heightEnd = selectValue[1];
            
            if (![heightStart containsString:@"--"] && ![heightEnd containsString:@"--"]) {
                NSInteger height1;
                NSInteger height2;
                height1 = [selectRow[0] integerValue] + 150;
                height2 = [selectRow[1] integerValue] + 150;
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.userModel.condition];
                [dic setObject:@[@(height1),@(height2)] forKey:@"height_range"];
                
                weakSelf.userModel.condition = dic;
                [weakSelf.tableView reloadData];
            }else{
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.userModel.condition];
                [dic setObject:@[] forKey:@"height_range"];
                
                weakSelf.userModel.condition = dic;
                [weakSelf.tableView reloadData];
            }
            
            
            
        }];
        
    }else if ([title isEqualToString:@"车辆"]){
        [CGXPickerView showStringPickerWithTitle:@"车辆" DataSource:@[@"不限",@"已购车辆", @"未购车辆"] DefaultSelValue:@"--" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.userModel.condition];
            [dic setObject:[NSNumber numberWithInteger:[selectRow integerValue]]  forKey:@"car_status"];
            
            weakSelf.userModel.condition = dic;
            [weakSelf.tableView reloadData];
            
        }];
        
    }else if ([title isEqualToString:@"房产"]){
        [CGXPickerView showStringPickerWithTitle:@"房产" DataSource:@[@"不限",@"已购住房", @"未购住房"] DefaultSelValue:@"--" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.userModel.condition];
            [dic setObject:[NSNumber numberWithInteger:[selectRow integerValue]]  forKey:@"house_status"];
            
            weakSelf.userModel.condition = dic;
            [weakSelf.tableView reloadData];
            
        }];
        
    }else if ([title isEqualToString:@"工作职业"]){
        [CGXPickerView showStringPickerWithTitle:@"工作职业" DataSource:@[@"不限",@"白领/一般职业", @"公务员/事业单位", @"自由职业/私营业主", @"暂时无业", @"退休", @"学生"] DefaultSelValue:@"--" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.userModel.condition];
            [dic setObject:[NSNumber numberWithInteger:[selectRow integerValue]]  forKey:@"profession"];
            
            weakSelf.userModel.condition = dic;
            [weakSelf.tableView reloadData];
            
        }];
       
    }else if ([title isEqualToString:@"月收入"]){
        
        [CGXPickerView showStringPickerWithTitle:@"月收入" DataSource:@[@"不限",@"5000以下", @"5000-1万", @"1万-15000", @"15000以上"] DefaultSelValue:nil IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.userModel.condition];
            [dic setObject:[NSNumber numberWithInteger:[selectRow integerValue]]  forKey:@"income"];
            
            weakSelf.userModel.condition = dic;
            [weakSelf.tableView reloadData];
            
        }];
    }else if ([title isEqualToString:@"婚姻状况"]){
        
        [CGXPickerView showStringPickerWithTitle:@"婚姻状况" DataSource:@[@"不限",@"未婚", @"离异", @"丧偶"] DefaultSelValue:@"未婚" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.userModel.condition];
            [dic setObject:[NSNumber numberWithInteger:[selectRow integerValue]]  forKey:@"marital_status"];
            
            weakSelf.userModel.condition = dic;
            [weakSelf.tableView reloadData];
            
        }];
    }else if ([title isEqualToString:@"有无子女"]){
        
        [CGXPickerView showStringPickerWithTitle:@"有无子女" DataSource:@[@"不限",@"无", @"有，和我在一起", @"有，不和我在一起"] DefaultSelValue:@"无" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.userModel.condition];
            [dic setObject:[NSNumber numberWithInteger:[selectRow integerValue]]  forKey:@"child_status"];
            
            weakSelf.userModel.condition = dic;
            [weakSelf.tableView reloadData];
            
        }];
    }else if ([title isEqualToString:@"打算几年内结婚"]){
        
        [CGXPickerView showStringPickerWithTitle:@"打算几年内结婚" DataSource:@[@"不限",@"1年内", @"1-2年内", @"2-3年内", @"3年以上"] DefaultSelValue:@"1年内" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.userModel.condition];
            [dic setObject:[NSNumber numberWithInteger:[selectRow integerValue]]  forKey:@"years_to_marry"];
            
            weakSelf.userModel.condition = dic;
            [weakSelf.tableView reloadData];
            
        }];
    }else if ([title isEqualToString:@"学历"]){
        
        [CGXPickerView showStringPickerWithTitle:@"学历" DataSource:@[@"不限",@"初中", @"高中", @"大学",@"硕士",@"博士",@"院士"] DefaultSelValue:@"不限" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.userModel.condition];
            [dic setObject:[NSNumber numberWithInteger:[selectRow integerValue]]  forKey:@"education"];
            
            weakSelf.userModel.condition = dic;
            [weakSelf.tableView reloadData];
            
        }];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        /*
             condition 格式说明 字段值对用相应中文意思的key
         
             {
             "age_range": [10, 20],
             "height_range": [180, 190],
             "profession": 1,
             "education": 1,
             "income": 1,
             "marital_status": 1,
             "child_status": 1,
             "years_to_marry": 1,
             }
         */
        NSString *leftImage;
        NSString *title;
        NSString *subTitle;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.userModel.condition];
        // 个人资料，择偶标准，我要认证，谁看过我，分享软件，当前积分
        MeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeListTableViewCellReuseID"];
        cell.titleLBLeading.constant = -20;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                leftImage = @"";
                title = @"年龄";
                NSArray *ageRange = self.userModel.condition[@"age_range"];
                if (ageRange.count == 2) {
                    subTitle = [NSString stringWithFormat:@"%ld岁-%ld岁",[ageRange[0] integerValue],[ageRange[1] integerValue]];
                }else{
                    
                    if ([self.title isEqualToString:@"择偶标准"]) {
                        subTitle = @"18岁-30岁";
                        
                        [dic setObject:@[@(18),@(30)] forKey:@"age_range"];
                        self.userModel.condition = dic;
                    }else {
                        subTitle = @"不限";
                    }
                    
                }
                
            }else if (indexPath.row == 1) {
                leftImage = @"";
                title = @"身高";
                NSArray *heightRange = self.userModel.condition[@"height_range"];
                if (heightRange.count == 2) {
                    subTitle = [NSString stringWithFormat:@"%ldcm-%ldcm",[heightRange[0] integerValue],[heightRange[1] integerValue]];
                }else{
                    if ([self.title isEqualToString:@"择偶标准"]) {
                        subTitle = @"150cm-180cm";
                        [dic setObject:@[@(150),@(180)] forKey:@"height_range"];
                        self.userModel.condition = dic;
                    }else {
                        subTitle = @"不限";
                    }
                }
            }else if (indexPath.row == 2) {
                leftImage = @"";
                title = @"房产";
                NSInteger house_status = [self.userModel.condition[@"house_status"] integerValue];
                if (house_status == 0) {
                    subTitle = @"不限";
                    [dic setObject:@(0) forKey:@"house_status"];
                    self.userModel.condition = dic;
                }else{
                    subTitle = [Help house:house_status];
                }
            }else if (indexPath.row == 3) {
                leftImage = @"";
                title = @"车辆";
                NSInteger car_status = [self.userModel.condition[@"car_status"] integerValue];
                if (car_status == 0) {
                    subTitle = @"不限";
                    [dic setObject:@(0) forKey:@"car_status"];
                    self.userModel.condition = dic;
                }else{
                    subTitle = [Help car:car_status];
                }
            }
            
        }else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                leftImage = @"";
                title = @"学历";
                NSInteger profession = [self.userModel.condition[@"education"] integerValue];
                if (profession == 0) {
                    subTitle = @"不限";
                    [dic setObject:@(0) forKey:@"education"];
                    self.userModel.condition = dic;
                }else{
                    subTitle = [Help education:profession];
                }
            }else if (indexPath.row == 1) {
                leftImage = @"";
                title = @"工作职业";
                NSInteger profession = [self.userModel.condition[@"profession"] integerValue];
                if (profession == 0) {
                    subTitle = @"不限";
                    [dic setObject:@(0) forKey:@"profession"];
                    self.userModel.condition = dic;
                }else{
                    subTitle = [Help profession:profession];
                }
            }else if (indexPath.row == 2) {
                leftImage = @"";
                title = @"月收入";
                NSInteger income = [self.userModel.condition[@"income"] integerValue];
                if (income == 0) {
                    subTitle = @"不限";
                    [dic setObject:@(0) forKey:@"income"];
                    self.userModel.condition = dic;
                }else{
                    subTitle = [Help income:income];
                }
            }else if (indexPath.row == 3) {
                leftImage = @"";
                title = @"婚姻状况";
                NSInteger marital_status = [self.userModel.condition[@"marital_status"] integerValue];
                if (marital_status == 0) {
                    subTitle = @"不限";
                    [dic setObject:@(0) forKey:@"marital_status"];
                    self.userModel.condition = dic;
                }else{
                    subTitle = [Help marital_status:marital_status];
                }
            }else if (indexPath.row == 4) {
                leftImage = @"";
                title = @"有无子女";
            
                NSInteger child_status = [self.userModel.condition[@"child_status"] integerValue];
                if (child_status == 0) {
                    subTitle = @"不限";
                    [dic setObject:@(0) forKey:@"child_status"];
                    self.userModel.condition = dic;
                }else{
                    subTitle = [Help child_status:child_status];
                }
                
                
            }else if (indexPath.row == 5) {
                leftImage = @"";
                title = @"打算几年内结婚";
                NSInteger years_to_marry = [self.userModel.condition[@"years_to_marry"] integerValue];
                if (years_to_marry == 0) {
                    subTitle = @"不限";
                    [dic setObject:@(0) forKey:@"years_to_marry"];
                    self.userModel.condition = dic;
                }else{
                    subTitle = [Help yearsToMarial:years_to_marry];
                }
            }
            
        }
        cell.leftImgV.image = [UIImage imageNamed:leftImage];
        cell.titleLB.text = title;
        cell.subTitleLB.text = subTitle;
        return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self clickIndexPath:indexPath];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 6;
            break;
        default:
            break;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = BackGroundColor;
    return view;
    
}

- (InsLoadDataTablView *)tableView {
    if ( !_tableView ) {
        _tableView = [[InsLoadDataTablView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - UITabBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 15, _tableView.separatorInset.bottom, 15);
        _tableView.separatorColor = Line;
//        _tableView.rowHeight = 55;
        _tableView.tableFooterView = [UIView new];
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
