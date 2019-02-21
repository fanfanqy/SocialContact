//
//  GeRenZiLiaoVC.m
//  SocialContact
//
//  Created by EDZ on 2019/1/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import "GeRenZiLiaoVC.h"
#import "SCUserInfo.h"
#import "MeListTableViewCell.h"
#import "UserAvatarCell.h"

#import "ModifyUserInfoVC.h"

@interface GeRenZiLiaoVC ()<UITableViewDelegate,UITableViewDataSource>

INS_P_STRONG(InsLoadDataTablView *, tableView);

@end

@implementation GeRenZiLiaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    
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

- (void)saveUserInfo{
    
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

- (void)clickIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title;
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
 
            if (indexPath.row == 0) {
                
//                title = @"昵称";
                ModifyUserInfoVC *vc = [ModifyUserInfoVC new];
                vc.modifyType = ModifyTypeNickName;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if (indexPath.row == 1) {
                
                title = @"性别";
            }else if (indexPath.row == 2) {
                
                title = @"出生日期";
            }else if (indexPath.row == 3) {
                
                title = @"身高";
            }
            
        }
            break;
        case 2:
        {
            
            
            if (indexPath.row == 0) {
             
                title = @"家庭地址";
            }else if (indexPath.row == 1) {
                
                title = @"工作地址";
            }else if (indexPath.row == 2) {
                
                title = @"工作职业";
            }else if (indexPath.row == 3) {
                
                title = @"收入描述";
            }else if (indexPath.row == 4) {
                
                title = @"婚姻状况";
            }else if (indexPath.row == 5) {
                
                title = @"有无子女";
            }else if (indexPath.row == 6) {
                
                title = @"打算几年内结婚";
            }else if (indexPath.row == 7) {
                
//                title = @"用户签名";
                ModifyUserInfoVC *vc = [ModifyUserInfoVC new];
                vc.modifyType = ModifyTypeSelfIntroduce;
                [self.navigationController pushViewController:vc animated:YES];
                
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
                NSLog(@"%@",selectValue); ;
                
            } Style:CGXStringPickerViewStyleGender];
        }else if ([title isEqualToString:@"年龄"]){
            NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStyleAge] objectAtIndex:1];
            [CGXPickerView showStringPickerWithTitle:@"年龄" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue); ;
                
            } Style:CGXStringPickerViewStyleAge];
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
            
        }else if ([title isEqualToString:@"年收入"]){
            
            [CGXPickerView showStringPickerWithTitle:@"年收入" DataSource:@[ @"10万以下", @"10万~20万", @"20万~50万", @"50万以上"] DefaultSelValue:@"10万以下" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
            }];
        }else if ([title isEqualToString:@"婚姻状况"]){
            
            [CGXPickerView showStringPickerWithTitle:@"婚姻状况" DataSource:@[@"未婚", @"离异", @"丧偶"] DefaultSelValue:@"未婚" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
            }];
        }else if ([title isEqualToString:@"有无子女"]){
            
            [CGXPickerView showStringPickerWithTitle:@"有无子女" DataSource:@[@"无", @"有，和我在一起", @"有，不和我在一起"] DefaultSelValue:@"无" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
            }];
        }else if ([title isEqualToString:@"打算几年内结婚"]){
            
            [CGXPickerView showStringPickerWithTitle:@"打算几年内结婚" DataSource:@[@"1年内", @"1-2年内", @"2-3年内", @"3年以上"] DefaultSelValue:@"1年内" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
            }];
        }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UserAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserAvatarCell"];
        [cell.avatarImg sd_setImageWithURL:[NSURL URLWithString:self.userModel.avatar_url] placeholderImage:[UIImage imageNamed:@""]];
        return cell;
        
    }else{
        
        NSString *leftImage;
        NSString *title;
        NSString *subTitle;
        // 个人资料，择偶标准，我要认证，谁看过我，分享软件，当前积分
        MeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeListTableViewCellReuseID"];
        cell.titleLBLeading.constant = -20;
        if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                leftImage = @"";
                title = @"昵称";
                subTitle = self.userModel.name;
            }else if (indexPath.row == 1) {
                leftImage = @"";
                title = @"性别";
                subTitle = [Help gender:self.userModel.gender];
            }else if (indexPath.row == 2) {
                leftImage = @"";
                title = @"出生日期";
                subTitle = self.userModel.birthday;
            }else if (indexPath.row == 3) {
                leftImage = @"";
                title = @"身高";
                subTitle = [Help height:self.userModel.height];
            }
            
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                leftImage = @"";
                title = @"家庭地址";
                subTitle = self.userModel.address_home;
            }else if (indexPath.row == 1) {
                leftImage = @"";
                title = @"工作地址";
                subTitle = self.userModel.address_company;
            }else if (indexPath.row == 2) {
                leftImage = @"";
                title = @"工作职业";
                subTitle = [Help profession:self.userModel.profession];
            }else if (indexPath.row == 3) {
                leftImage = @"";
                title = @"收入描述";
                subTitle = [Help income:self.userModel.income];
            }else if (indexPath.row == 4) {
                leftImage = @"";
                title = @"婚姻状况";
                subTitle = [Help marital_status:self.userModel.marital_status];
            }else if (indexPath.row == 5) {
                leftImage = @"";
                title = @"有无子女";
                subTitle = [Help child_status:self.userModel.child_status];
            }else if (indexPath.row == 6) {
                leftImage = @"";
                title = @"打算几年内结婚";
                subTitle = [Help yearsToMarial:self.userModel.years_to_marry];
            }else if (indexPath.row == 7) {
                leftImage = @"";
                title = @"用户签名";
                subTitle = self.userModel.intro;
            }
            
        }
        cell.leftImgV.image = [UIImage imageNamed:leftImage];
        cell.titleLB.text = title;
        cell.subTitleLB.text = subTitle;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [self clickIndexPath:indexPath];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 8;
            break;
        default:
            break;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 68;
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        view.backgroundColor = BackGroundColor;
        return view;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.000001;
}

- (InsLoadDataTablView *)tableView {
    if ( !_tableView ) {
        _tableView = [[InsLoadDataTablView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - GuaTopHeight ) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(_tableView.separatorInset.top, 15, _tableView.separatorInset.bottom, 15);
        _tableView.separatorColor = Line;
        _tableView.rowHeight = 55;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UserAvatarCell class] forCellReuseIdentifier:@"UserAvatarCell"];
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
