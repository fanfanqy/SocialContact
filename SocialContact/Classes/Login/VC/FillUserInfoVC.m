//
//  FillUserInfoVC.m
//  SocialContact
//
//  Created by EDZ on 2019/3/7.
//  Copyright © 2019 ha. All rights reserved.
//

#import "FillUserInfoVC.h"
#import "SCUploadManager.h"
@interface FillUserInfoVC ()<TOCropViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UITextField *nick;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UITextField *birthday;
@property (weak, nonatomic) IBOutlet UITextField *homeAddress;
@property (weak, nonatomic) IBOutlet UITextField *inviteCode;


INS_P_ASSIGN(NSInteger, genderInterger);

INS_P_STRONG(NSString *, avatarUrl);

@end

@implementation FillUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.fd_interactivePopDisabled = YES;
//    self.fd_prefersNavigationBarHidden = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
    
    self.avatar.userInteractionEnabled = YES;
    self.avatar.layer.cornerRadius = 35.f;
    self.avatar.layer.masksToBounds = YES;
    
    WEAKSELF;
    [self.avatar jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        
        [weakSelf modifyAvatar];
    }];
    
    [self.view jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        
        [weakSelf.view endEditing:YES];
    
    }];
    
    self.nick.delegate = self;
    self.gender.delegate = self;
    self.birthday.delegate = self;
    self.homeAddress.delegate = self;
    self.inviteCode.delegate = self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:self.gender]) {
        [self genderTouch];
        return NO;
    }else if ([textField isEqual:self.birthday]) {
        [self birthTouch];
        return NO;
    }else if ([textField isEqual:self.homeAddress]) {
        [self homeTOuch];
        return NO;
    }
    
    return YES;
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
    cropController.title = @"头像裁剪";
    cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
    cropController.aspectRatioLockEnabled = YES;
    cropController.resetAspectRatioEnabled = NO;
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
    self.avatar.image = image;
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
            
            weakSelf.avatarUrl = urlStr;
            
        } objectNameArray:imageNameArray completion:^(BOOL isSuccess) {
            
            [weakSelf.view hideToastActivity];
            if (isSuccess) {
                [weakSelf modifyUserinfo];
            }else{
                [weakSelf.view makeToast:@"头像上传失败" duration:1 position:CSToastPositionCenter];
            }
        }];
    }];
    
    
}

// 提交
- (IBAction)tiJiaoBtnClick:(id)sender {
    
    if (![NSString ins_String:self.avatarUrl]) {
        [self.view makeToast:@""];
    }
    
    [self modifyUserinfo];
}


- (void)genderTouch {
    
    [self.view endEditing:YES];
    [self pickerTitle:@"性别"];
    
}

- (void)birthTouch {
    
    [self.view endEditing:YES];
    [self pickerTitle:@"出生日期"];
}

- (void)homeTOuch {
    
    [self.view endEditing:YES];
    [self pickerTitle:@"家庭地址"];
    
}



- (void)pickerTitle:(NSString *)title{
    WEAKSELF;
    if ([title isEqualToString:@"出生日期"]) {
        NSDate *now = [NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-DDThh:mm:ss";
        NSString *nowStr = [fmt stringFromDate:now];
        
        [CGXPickerView showDatePickerWithTitle:@"出生日期" DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:@"1900-01-01T00:00:00" MaxDateStr:nowStr IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
            NSLog(@"%@",selectValue);
            weakSelf.birthday.text = selectValue;
        }];
        
    }else if ([title isEqualToString:@"性别"]){
        
        [CGXPickerView showStringPickerWithTitle:@"性别" DataSource:@[@"男",@"女"] DefaultSelValue:@"男" IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            
            NSLog(@"%@",selectValue);
            
            weakSelf.gender.text = selectValue;
            weakSelf.genderInterger = [selectRow integerValue]+1;
            
        }];
        
    }else if ([title isEqualToString:@"家庭地址"]){
        // 自定义
//        邯郸市改成邯郸市辖区，复兴区下面加上个高开区，邯郸市辖区包含，丛台区，复兴区，邯山区，高开区
        [CGXPickerView showStringPickerWithTitle:@"家庭地址" DataSource:@[@"邯郸市辖区",@"邯山区",@"丛台区",@"复兴区",@"高开区",@"峰峰矿区",@"肥乡区",@"永年区",@"临漳县",@"成安县",@"大名县",@"涉县",@"磁县",@"邱县",@"鸡泽县",@"广平县",@"馆陶县",@"魏县",@"曲周县",@"武安市"] DefaultSelValue:@"邯郸市辖区" IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            
            weakSelf.homeAddress.text = selectValue;
            
        }];
        
    }
}

- (void)modifyUserinfo{
    
//    NSDictionary *dic = @{
//                          @"avatar_url":self.avatarUrl,
//                          @"name":self.nick.text,
//                          @"gender":[NSNumber numberWithInteger:self.genderInterger],
//                          @"birthday":self.birthday.text,
//                          @"address_home":self.homeAddress.text,
//                          };
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]init];
    
    if ([NSString ins_String:self.avatarUrl]) {
        [mutableDic setObject:self.avatarUrl forKey:@"avatar_url"];
    }else{
        [self.view makeToast:@"请先设置头像"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self modifyAvatar];
        });
        return;
    }
    
    if ([NSString ins_String:self.nick.text]) {
        [mutableDic setObject:self.nick.text forKey:@"name"];
    }else{
        [self.view makeToast:@"设置昵称"];
        [self.nick becomeFirstResponder];
        return;
    }
    
    if ([NSString ins_String:self.gender.text]) {
        [mutableDic setObject:[NSNumber numberWithInteger:self.genderInterger] forKey:@"gender"];
    }else{
        [self.view makeToast:@"设置性别"];
        [self genderTouch];
        return;
    }
    
    if ([NSString ins_String:self.birthday.text]) {
        [mutableDic setObject: [NSString stringWithFormat:@"%@T20:00:00.000",self.birthday.text]  forKey:@"birthday"];
    }else{
        [self.view makeToast:@"设置生日"];
        [self birthTouch];
        return;
    }
    
    if ([NSString ins_String:self.homeAddress.text]) {
        [mutableDic setObject:self.homeAddress.text forKey:@"address_home"];
    }else{
        [self.view makeToast:@"设置家乡地址"];
        [self homeTOuch];
        return;
    }
    
    
    WEAKSELF;
    POSTRequest *request = [POSTRequest requestWithPath:@"/customer/profile/" parameters:mutableDic completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }else{
            SCUserInfo *userModel = [SCUserInfo modelWithDictionary:request.responseObject[@"data"]];
            
            // 1.
            [SCUserCenter sharedCenter].currentUser.userInfo = userModel;
            [[SCUserCenter sharedCenter].currentUser updateToDB];
            
            // 2.
            // [SCUserCenter sharedCenter].currentUser.user_id
            RCUserInfo *rcUserInfo = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",userModel.iD] name:[SCUserCenter sharedCenter].currentUser.name portrait:userModel.avatar_url] ;
            [rcUserInfo updateToDB];
            [RCIM sharedRCIM].currentUserInfo = rcUserInfo;
            [[RCIM sharedRCIM] refreshUserInfoCache:rcUserInfo withUserId:rcUserInfo.userId];
            
            [weakSelf.view makeToast:@"个人信息设置完成"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[AppDelegate sharedDelegate] configRootVC];
            });
        }
    }];
    [InsNetwork addRequest:request];
    
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
