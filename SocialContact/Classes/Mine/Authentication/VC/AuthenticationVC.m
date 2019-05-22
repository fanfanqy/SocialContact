//
//  AuthenticationVC.m
//  SocialContact
//
//  Created by EDZ on 2019/2/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "AuthenticationVC.h"
#import "AuthenticationConfirmVC.h"
#import "MBProgressHUD.h"
#import <MGFaceIDDetect/MGFaceIDDetect.h>

@interface AuthenticationVC ()<AuthenticationConfirmVCDelegate,UITextFieldDelegate>


@property (strong, nonatomic) AuthenticationConfirmVC *authenticationConfirmVC;

@property (nonatomic, strong) NSString* bizTokenStr;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardTF;

@property (nonatomic, strong) NSString* userName;

@property (nonatomic, strong) NSString* cardNumber;

@end

@implementation AuthenticationVC


- (IBAction)goCaijiClick:(id)sender {
    
    if (![NSString ins_String:self.userNameTF.text]) {
        [self.view makeToast:@"输入姓名"];
        return;
    }
    
    if (![NSString ins_String:self.cardTF.text]) {
        [self.view makeToast:@"输入身份证号码"];
        return;
    }
    
    [self getBizToken];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = BackGroundColor;
    self.title = @"实名认证";
    _authenticationConfirmVC =  [[AuthenticationConfirmVC alloc]initWithNibName:@"AuthenticationConfirmVC" bundle:nil];
    _authenticationConfirmVC.delegate = self;
    [self.view addSubview:_authenticationConfirmVC.view];
    
    WEAKSELF;
    [self.view jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weakSelf.view endEditing:YES];
    }];
    
    self.userNameTF.delegate = self;
    self.cardTF.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.cardTF]) {
        [self.view endEditing:YES];
    }else{
        [self.cardTF becomeFirstResponder];
    }
    return YES;
    
}

- (void)backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismiss{
    
    WEAKSELF;
    self.authenticationConfirmVC.view.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:.3 animations:^{
        
      weakSelf.authenticationConfirmVC.view.top += kScreenHeight;
    } completion:^(BOOL finished) {
        
        [weakSelf.authenticationConfirmVC.view removeFromSuperview];
    }];
    
}

#pragma mark - BizToken
- (void)getBizToken {
    NSMutableDictionary* liveInfoDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [liveInfoDict setObject:@"3" forKey:@"liveness_retry_count"];
    [liveInfoDict setObject:@"1" forKey:@"verbose"];
    [liveInfoDict setObject:@"2" forKey:@"security_level"];
    [liveInfoDict setObject:@"meglive" forKey:@"liveness_type"];
    
    NSString* userNameStr = self.userNameTF.text;
    NSString* userNumberStr = self.cardTF.text;
    
//    NSAssert(userNameStr.length != 0, @"请填写用户名称信息");
//    NSAssert(userNumberStr.length != 0, @"请填写用户身份证号码信息");
    WEAKSELF;
    [[DemoMegNetwork singleton] getBizTokenWithIdcardName:userNameStr
                                             idcardNumber:userNumberStr
                                               liveConfig:liveInfoDict
                                                  success:^(NSInteger statusCode, NSDictionary *responseObject) {
                                                      
                                                      if (statusCode == 200 && responseObject && [[responseObject allKeys] containsObject:@"biz_token"] && [responseObject objectForKey:@"biz_token"]) {
                                                          weakSelf.bizTokenStr = [responseObject objectForKey:@"biz_token"];
//                                                          [weakSelf showCheckMessage:@"获取 BizToken 成功"];
                                                          [weakSelf startDetect];
                                                      } else {
                                                          [weakSelf showCheckMessage:@"请求失败，请稍后重试"];
                                                      }
                                                  }
                                                  failure:^(NSInteger statusCode, NSError *error) {
                                                      
                                                      if (statusCode == 400) {
                                                          [weakSelf showCheckMessage:@"请检查姓名、身份号输入是否正确"];
                                                      }else{
                                                          [weakSelf showCheckMessage:@"网络请求失败"];
                                                      }
                                                  }];
}

#pragma mark - Detect
- (void)startDetect{
//    sender.userInteractionEnabled = NO;
    FaceIDDetectError* error;
    MGFaceIDDetectManager* liveDetectManager = [[MGFaceIDDetectManager alloc] initFaceIdManagerWithToken:self->_bizTokenStr
                                                                                                   error:&error];
    MGFaceIDLiveDetectCustomConfigItem *item = [MGFaceIDLiveDetectCustomConfigItem new];
    item.livenessDetectButtonSelectedBGColor = [UIColor colorWithHexString:@"4B7ADF"];
    
    [liveDetectManager setMGFaceIDLiveDetectCustomUIConfig:item];
    
    if (error && !liveDetectManager) {
        [self showCheckMessage:@"请求失败，请稍后重试"];
        return;
    }
    //  可选方法-当前使用默认值
    {
        MGFaceIDLiveDetectCustomConfigItem* customConfigItem = [[MGFaceIDLiveDetectCustomConfigItem alloc] init];
        [liveDetectManager setMGFaceIDLiveDetectCustomUIConfig:customConfigItem];
        [liveDetectManager setMGFaceIDLiveDetectPhoneVertical:MGFaceIDLiveDetectPhoneVerticalFront];
    }
    WEAKSELF;
    [liveDetectManager startDetect:self
                          callback:^(NSUInteger Code, NSString *Message) {
                              
                              // 51000 成功
                              if (Code == 51000) {
                                  [weakSelf modifyUserinfo];
                              }else{
                                  [weakSelf showCheckMessage:@"认证失败，请遵照提示要求"];
                              }
                          }];
}


- (void)modifyUserinfo{
    
    self.userModel.is_idcard_verified = YES;
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
            RCUserInfo *rcUserInfo = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",weakSelf.userModel.iD] name:[SCUserCenter sharedCenter].currentUser.name portrait:weakSelf.userModel.avatar_url];
            [rcUserInfo updateToDB];
            [RCIM sharedRCIM].currentUserInfo = rcUserInfo;
            [[RCIM sharedRCIM] refreshUserInfoCache:rcUserInfo withUserId:rcUserInfo.userId];
            
            [SVProgressHUD showImage:AlertErrorImage status:@"认证成功"];
            [SVProgressHUD dismissWithDelay:1.5];
            
        }
        
        if (weakSelf.type == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[AppDelegate sharedDelegate]configRootVC];
            });
        }else{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        }
    }];
    [InsNetwork addRequest:request];
}



#pragma mark - showCheckMessage
- (void)showCheckMessage:(NSString *)checkMessage {
    dispatch_async(dispatch_get_main_queue(), ^{

        [SVProgressHUD showImage:AlertErrorImage status:checkMessage];
        [SVProgressHUD dismissWithDelay:3];
    });
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
