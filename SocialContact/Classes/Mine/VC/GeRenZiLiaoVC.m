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

#import "SCUploadManager.h"

#import "HorizontalScrollCell.h"

@interface GeRenZiLiaoVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,TOCropViewControllerDelegate,UINavigationControllerDelegate,HorizontalScrollCellDeleagte>

INS_P_STRONG(InsLoadDataTablView *, tableView);

INS_P_STRONG(NSString *, avatarUrl);

INS_P_ASSIGN(BOOL,isModifyAvatar);


@end



@implementation GeRenZiLiaoVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.title) {
        self.title = @"个人资料";
    }
    
    self.fd_interactivePopDisabled = YES;
    
    [self setUpUI];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
}

- (void)done{
    
    if ([Help checkFillAllInfo:self.userModel ignoreAvatar:NO]) {
        [self modifyUserinfo];
    }
    
}

- (void)leftBarButtonItemClick{
    
    if (self.vcType == 1) {
        if ([Help checkFillAllInfo:self.userModel ignoreAvatar:NO]) {
            [self modifyUserinfo];
        }else{
            [self.view makeToast:@"请您先完善个人信息，\n谈恋爱我们是认真的" duration:3 position:CSToastPositionCenter];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
//        [self modifyUserinfo];
        
    }
}


- (void)setUpUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    WEAKSELF;
//    [self.tableView setLoadNewData:^{
//        
//        [weakSelf getUserInfo];
//    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getUserInfo];
    });
    
}

- (void)modifyUserinfo{
    
    NSData *jsonData =  [self.userModel modelToJSONData];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

    
    NSData *jsonDataImages = [NSJSONSerialization dataWithJSONObject:self.userModel.images options:NSJSONWritingPrettyPrinted error:nil];
    NSString *imagesJsonStr = [[NSString alloc] initWithData:jsonDataImages encoding:NSUTF8StringEncoding];
    [dic setValue:imagesJsonStr forKey:@"images"];
    
    
    [self showLoading];
    WEAKSELF;
    POSTRequest *request = [POSTRequest requestWithPath:@"/customer/profile/" parameters:dic completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        
        
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            weakSelf.userModel = [SCUserInfo modelWithDictionary:request.responseObject[@"data"]];
            
            // 1.
            [SCUserCenter sharedCenter].currentUser.userInfo = weakSelf.userModel;
            [[SCUserCenter sharedCenter].currentUser updateToDB];
            
            // 2.[SCUserCenter sharedCenter].currentUser.user_id
            RCUserInfo *rcUserInfo = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",weakSelf.userModel.iD] name:[SCUserCenter sharedCenter].currentUser.name portrait:weakSelf.userModel.avatar_url] ;
            [rcUserInfo updateToDB];
            [RCIM sharedRCIM].currentUserInfo = rcUserInfo;
            [[RCIM sharedRCIM] refreshUserInfoCache:rcUserInfo withUserId:rcUserInfo.userId];
            
            
            
            [weakSelf.tableView reloadData];
            
            [weakSelf.view makeToast:@"个人信息设置完成"];
            
            if (weakSelf.vcType == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[AppDelegate sharedDelegate] configRootVC];
                });
            }
        }
        
        if (weakSelf.vcType == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
        
        
    }];
    [InsNetwork addRequest:request];
}

- (void)getUserInfo{
    
    [self showLoading];
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/customer/profile/" parameters:nil completionHandler:^(InsRequest *request) {
        
        [weakSelf hideLoading];
        [weakSelf.tableView endRefresh];
        
        if (!request.error) {
            weakSelf.userModel = [SCUserInfo modelWithDictionary:request.responseObject[@"data"]];
            [weakSelf.tableView reloadData];
        }else{
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
    
    [InsNetwork addRequest:request];
    
}

#pragma mark 头像上传
- (void)modifyAvatar{
    
    [self pushImagePickerController];
    
}

- (void)pushImagePickerController {
    
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    UIImagePickerController *standardPicker = [[UIImagePickerController alloc] init];
    standardPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    standardPicker.allowsEditing = NO;
    standardPicker.delegate = self;
    [self presentViewController:standardPicker animated:YES completion:nil];
    
}


#pragma mark - Image Picker Delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:image];
    cropController.delegate = self;
    if (_isModifyAvatar) {
        cropController.title = @"头像裁剪";
        cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
        cropController.aspectRatioLockEnabled = YES;
        cropController.resetAspectRatioEnabled = NO;
    }else{
        cropController.title = @"相册图片裁剪";
        cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetOriginal;
    }
    
    cropController.toolbarPosition = TOCropViewControllerToolbarPositionTop;
    cropController.doneButtonTitle = @"完成";
    cropController.cancelButtonTitle = @"取消";
    [picker pushViewController:cropController animated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
    [self uploadImage:image];
    
}

#pragma mark HorizontalScrollCellDeleagte
- (void)horizontalCellContentsView:(UICollectionView *)horizontalCellContentsView didSelectItemAtContentIndexPath:(NSIndexPath *)contentIndexPath inTableViewIndexPath:(NSIndexPath *)tableViewIndexPath{
    
    if (contentIndexPath.item == self.userModel.images.count) {
        // 添加图片
        _isModifyAvatar = NO;
        [self modifyAvatar];
    }
    
    
}

#pragma mark - Action handling

- (void)uploadImage:(UIImage *)image{
  
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableArray *imageNameArray = [NSMutableArray array];
    
    NSString *objectKey = [NSString stringWithFormat:@"%ld/avatar/%f/%d.png",[SCUserCenter sharedCenter].currentUser.userInfo.iD,[[NSDate date] timeIntervalSince1970],arc4random()%INT_MAX];
    [imageNameArray addObject:objectKey];
    
    NSData *data = [Help compressImage:image];
    [dataArray addObject:data];
    
    
    [self.view makeToastActivity:CSToastPositionCenter];
    WEAKSELF;
    [[SCUploadManager manager] uploadDataToQiNiuWithUrl:@"/token/" fail:^(NSError * _Nonnull error) {
        
        [weakSelf.view hideToastActivity];
        
    } succeed:^(NSString * _Nonnull token) {
        
        FGUploadImageManager *uploadImageManager = [FGUploadImageManager new];
        [uploadImageManager upLoadImageWithImageArray:dataArray token:token onceCompletion:^(NSUInteger index, BOOL isSuccess, NSString *urlStr) {
            
            if (isSuccess) {
                if (weakSelf.isModifyAvatar) {
                    weakSelf.avatarUrl = urlStr;
                    weakSelf.userModel.avatar_url = weakSelf.avatarUrl;
                }else{
                    NSMutableArray *array = [NSMutableArray arrayWithArray:weakSelf.userModel.images];
                    [array addObject:urlStr];
                    weakSelf.userModel.images = array;
                }
            }
            
        } objectNameArray:imageNameArray completion:^(BOOL isSuccess) {
            
            [weakSelf.view hideToastActivity];
            if (isSuccess) {
                
                if (weakSelf.isModifyAvatar) {
                    weakSelf.userModel.avatar_url = weakSelf.avatarUrl;
                    [weakSelf.view makeToast:@"头像上传成功" duration:1 position:CSToastPositionCenter];
                }else{
                    [weakSelf.view makeToast:@"上传成功" duration:1 position:CSToastPositionCenter];
                    [weakSelf.tableView reloadData];
                }
                
                
                [weakSelf.tableView reloadData];
            }else{
                if (weakSelf.isModifyAvatar) {
                    [weakSelf.view makeToast:@"头像上传失败" duration:1 position:CSToastPositionCenter];
                }else{
                    [weakSelf.view makeToast:@"上传失败" duration:1 position:CSToastPositionCenter];
                }
            }
        }];
    }];
    
}

- (void)clickIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                _isModifyAvatar = YES;
                [self modifyAvatar];
            }else if (indexPath.row == 1) {
                // 添加图片
                _isModifyAvatar = NO;
                [self modifyAvatar];
            }
        }
            break;
        case 1:
        {
 
            if (indexPath.row == 0) {
                
                ModifyUserInfoVC *vc = [ModifyUserInfoVC new];
                vc.modifyType = ModifyTypeNickName;
                vc.model = self.userModel;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if (indexPath.row == 1) {
                
                ModifyUserInfoVC *vc = [ModifyUserInfoVC new];
                vc.modifyType = ModifyTypeSelfIntroduce;
                vc.model = self.userModel;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if (indexPath.row == 2) {
                
                ModifyUserInfoVC *vc = [ModifyUserInfoVC new];
                vc.modifyType = ModifyTypeWeChat;
                vc.model = self.userModel;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if (indexPath.row == 3) {
                
                title = @"性别";
                if (self.vcType == 1) {
                    [SVProgressHUD showImage:AlertErrorImage status:@"填写完成后，软件内不予以更改，请认真填写"];
                    [SVProgressHUD dismissWithDelay:3];
                    
                }else{
                    [SVProgressHUD showImage:AlertErrorImage status:@"已填写，软件内不予以更改，请联系客服更改"];
                    [SVProgressHUD dismissWithDelay:3];
                    title = nil;
                }
                
            }else if (indexPath.row == 4) {
                
                title = @"出生日期";
            }
            else if (indexPath.row == 5) {
                
                title = @"年龄";
            }else if (indexPath.row == 6) {
                
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
                
                title = @"月收入";
            }else if (indexPath.row == 4) {
                
                title = @"学历";
            }else if (indexPath.row == 5) {
                
                title = @"房产";
            }else if (indexPath.row == 6) {
                
                title = @"车辆";
            }else if (indexPath.row == 7) {
                
                title = @"婚姻状况";
            }else if (indexPath.row == 8) {
                
                title = @"有无子女";
            }else if (indexPath.row == 9) {
                
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
        if ([title isEqualToString:@"出生日期"]) {
            NSDate *now = [NSDate date];
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"yyyy-MM-DDThh:mm:ss";
            NSString *nowStr = [fmt stringFromDate:now];
            
            [CGXPickerView showDatePickerWithTitle:@"出生日期" DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:@"1900-01-01T00:00:00" MaxDateStr:nowStr IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue) {
                NSLog(@"%@",selectValue);

                weakSelf.userModel.birthday = [NSString stringWithFormat:@"%@T20:00:00",selectValue];
                [weakSelf.tableView reloadData];
            }];
            
        }else if ([title isEqualToString:@"性别"]){
           
            [CGXPickerView showStringPickerWithTitle:@"性别（填写完成后，不予以更改）" DataSource:@[@"男",@"女"] DefaultSelValue:nil IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
                weakSelf.userModel.gender = [selectRow integerValue]+1;
                [weakSelf.tableView reloadData];
            }];
            
        }else if ([title isEqualToString:@"年龄"]){
            NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStyleAge] objectAtIndex:1];
            [CGXPickerView showStringPickerWithTitle:@"年龄" DefaultSelValue:defaultSelValue IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                weakSelf.userModel.age = [selectValue integerValue];
                [weakSelf.tableView reloadData];
            } Style:CGXStringPickerViewStyleAge];
        }else if ([title isEqualToString:@"身高"]){
            
            [CGXPickerView showStringPickerWithTitle:@"身高" DefaultSelValue:nil IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
                weakSelf.userModel.height = [selectRow integerValue]+150;
                [weakSelf.tableView reloadData];
                
            } Style:CGXStringPickerViewStylHeight];
        }else if ([title isEqualToString:@"工作地址"]){

            [CGXPickerView showStringPickerWithTitle:@"工作地址" DataSource:@[@"邯郸市辖区",@"邯山区",@"丛台区",@"复兴区",@"高开区",@"峰峰矿区",@"肥乡区",@"永年区",@"临漳县",@"成安县",@"大名县",@"涉县",@"磁县",@"邱县",@"鸡泽县",@"广平县",@"馆陶县",@"魏县",@"曲周县",@"武安市"] DefaultSelValue:@"邯郸市辖区" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
                weakSelf.userModel.address_company = selectValue;
                [weakSelf.tableView reloadData];
            }];
            
            
        }else if ([title isEqualToString:@"家庭地址"]){
            
            
            [CGXPickerView showStringPickerWithTitle:@"家庭地址" DataSource:@[@"邯郸市辖区",@"邯山区",@"丛台区",@"复兴区",@"高开区",@"峰峰矿区",@"肥乡区",@"永年区",@"临漳县",@"成安县",@"大名县",@"涉县",@"磁县",@"邱县",@"鸡泽县",@"广平县",@"馆陶县",@"魏县",@"曲周县",@"武安市"] DefaultSelValue:@"邯郸市辖区" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
                weakSelf.userModel.address_home = selectValue;
                [weakSelf.tableView reloadData];
            }];
            
            
        }
        else if ([title isEqualToString:@"工作职业"]){
            [CGXPickerView showStringPickerWithTitle:@"工作职业" DataSource:@[@"白领/一般职业", @"公务员/事业单位", @"自由职业/私营业主", @"暂时无业", @"退休", @"学生"] DefaultSelValue:nil IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
                weakSelf.userModel.profession = [selectRow integerValue]+1;
                [weakSelf.tableView reloadData];
                
            }];
            
        }else if ([title isEqualToString:@"月收入"]){
            
            [CGXPickerView showStringPickerWithTitle:@"月收入" DataSource:@[@"5000以下", @"5000-1万", @"1万-15000", @"15000以上"] DefaultSelValue:nil IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
                weakSelf.userModel.income = [selectRow integerValue]+1;
                [weakSelf.tableView reloadData];
                
            }];
        }else if ([title isEqualToString:@"婚姻状况"]){
            
            [CGXPickerView showStringPickerWithTitle:@"婚姻状况" DataSource:@[@"未婚", @"离异", @"丧偶"] DefaultSelValue:@"未婚" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
                weakSelf.userModel.marital_status = [selectRow integerValue]+1;
                [weakSelf.tableView reloadData];
                
            }];
        }else if ([title isEqualToString:@"有无子女"]){
            
            [CGXPickerView showStringPickerWithTitle:@"有无子女" DataSource:@[@"无子女", @"有子女，和我在一起", @"有子女，不和我在一起"] DefaultSelValue:@"无子女" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
                weakSelf.userModel.child_status = [selectRow integerValue]+1;
                [weakSelf.tableView reloadData];
                
            }];
        }else if ([title isEqualToString:@"打算几年内结婚"]){
            
            [CGXPickerView showStringPickerWithTitle:@"打算几年内结婚" DataSource:@[@"1年内", @"1-2年内", @"2-3年内", @"3年以上"] DefaultSelValue:@"1年内" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
                weakSelf.userModel.years_to_marry = [selectRow integerValue]+1;
                [weakSelf.tableView reloadData];
                
            }];
        }else if ([title isEqualToString:@"房产"]){
            
            [CGXPickerView showStringPickerWithTitle:@"房产信息" DataSource:@[@"保密",@"已购住房", @"未购住房"] DefaultSelValue:@"保密" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
                weakSelf.userModel.house_status = [selectRow integerValue];
                [weakSelf.tableView reloadData];
                
            }];
        }else if ([title isEqualToString:@"车辆"]){
            
            [CGXPickerView showStringPickerWithTitle:@"车辆信息" DataSource:@[@"保密",@"已购车辆", @"未购车辆"] DefaultSelValue:@"保密" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
                weakSelf.userModel.car_status = [selectRow integerValue];
                [weakSelf.tableView reloadData];
                
            }];
        }else if ([title isEqualToString:@"学历"]){
            
            [CGXPickerView showStringPickerWithTitle:@"学历" DataSource:@[@"初中", @"高中",@"中专",@"大专",@"大学",@"硕士",@"博士",@"院士"] DefaultSelValue:@"大学" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
                NSLog(@"%@",selectValue);
                
                weakSelf.userModel.education = [selectRow integerValue]+1;
                [weakSelf.tableView reloadData];
                
            }];
        }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            UserAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserAvatarCell"];
            [cell.avatarImg sc_setImgWithUrl:self.userModel.avatar_url placeholderImg:@"icon_default_person"];
            return cell;
        }else{
            
            HorizontalScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HorizontalScrollCell"];
            cell.delegate = self;
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.userModel.images];
            [array addObject:@"bg_add_imgshow"];
            cell.dataSource = array;
            return cell;
        }
        
        
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
                subTitle = self.userModel.name ?:@"未填写";
            }else if (indexPath.row == 1) {
                leftImage = @"";
                title = @"自我介绍";
                subTitle = self.userModel.intro?:@"未填写";
            }else if (indexPath.row == 2) {
                leftImage = @"";
                title = @"微信";
                subTitle = self.userModel.wechat_id?:@"未填写";
            }else if (indexPath.row == 3) {
                leftImage = @"";
                title = @"性别";
                subTitle = [Help gender:self.userModel.gender];
            }else if (indexPath.row == 4) {
                leftImage = @"";
                title = @"出生日期";
                
                NSDate *date = [NSDate dateWithString:self.userModel.birthday format:@"yyyy-MM-dd'T'HH:mm:ss"];
                if (date) {
                    subTitle = [date stringWithFormat:@"yyyy-MM-dd"];
                }else{
                    subTitle = self.userModel.birthday?:@"未填写";
                }
                
            }else if (indexPath.row == 5) {
                leftImage = @"";
                title = @"年龄";
                subTitle = [Help age:self.userModel.age];
            }else if (indexPath.row == 6) {
                leftImage = @"";
                title = @"身高";
                subTitle = [Help height:self.userModel.height];
            }
            
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                leftImage = @"";
                title = @"家庭地址";
                subTitle = self.userModel.address_home?:@"未填写";
            }else if (indexPath.row == 1) {
                leftImage = @"";
                title = @"工作地址";
                subTitle = self.userModel.address_company?:@"未填写";
            }else if (indexPath.row == 2) {
                leftImage = @"";
                title = @"工作职业";
                subTitle = [Help profession:self.userModel.profession];
            }else if (indexPath.row == 3) {
                leftImage = @"";
                title = @"月收入";
                subTitle = [Help income:self.userModel.income];
            }else if (indexPath.row == 4) {
                leftImage = @"";
                title = @"学历";
                subTitle = [Help education:self.userModel.education];
            }else if (indexPath.row == 5) {
                leftImage = @"";
                title = @"房产";
                subTitle = [Help house:self.userModel.house_status];
            }else if (indexPath.row == 6) {
                leftImage = @"";
                title = @"车辆";
                subTitle = [Help car:self.userModel.car_status];
            }else if (indexPath.row == 7) {
                leftImage = @"";
                title = @"婚姻状况";
                subTitle = [Help marital_status:self.userModel.marital_status];
            }else if (indexPath.row == 8) {
                leftImage = @"";
                title = @"有无子女";
                subTitle = [Help child_status:self.userModel.child_status];
            }else if (indexPath.row == 9) {
                leftImage = @"";
                title = @"几年内结婚";
                subTitle = [Help yearsToMarial:self.userModel.years_to_marry];
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
    
    [self clickIndexPath:indexPath];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 7;
            break;
        case 2:
            return 10;
            break;
        default:
            break;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            return 120;
        }else{
//            return ([UIScreen mainScreen].bounds.size.width-3.0)/4.0+40;
           return (kScreenWidth-20-6.0)/4.0 + 40;
        }
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
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
         [_tableView registerNib:[UINib nibWithNibName:@"UserAvatarCell" bundle:nil] forCellReuseIdentifier:@"UserAvatarCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MeListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MeListTableViewCellReuseID"];
        [_tableView registerClass:[HorizontalScrollCell class] forCellReuseIdentifier:@"HorizontalScrollCell"];
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
