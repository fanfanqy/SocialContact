//
//  UserFeedBackViewController.m
//  wyh
//
//  Created by bobo on 16/1/5.
//  Copyright © 2016年 HW. All rights reserved.
//

#import "UserFeedBackViewController.h"
#import "WBStatusHelper.h"
#import "TextLinePositionModifier.h"
#import "ZDropScrollView.h"
#import "ZDeleteRegionView.h"
#import "SCUploadManager.h"

#define kTextBorderColor     RGBCOLOR(227,224,216)

#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface UserFeedBackViewController ()<YYTextViewDelegate, YYTextKeyboardObserver,ZDropScrollViewDelegate,TZImagePickerControllerDelegate>

@property (strong, nonatomic) UIView *jubaoYuanYinView;

@property (strong, nonatomic) UIButton *publishButton;

@property (nonatomic, strong) YYTextView *textView;

@property (nonatomic,strong) ZDropScrollView* dropScrollView;

@property (nonatomic,strong) NSMutableArray* imageDatas;//image 类型数组
@property (strong, nonatomic) NSMutableArray *selectedAssets;// asset
@property (strong, nonatomic) NSMutableArray *pics;// url 类型

@property (nonatomic,assign) NSInteger jubaoIndex;

@property (strong, nonatomic)UILabel *juBaoLabel;

@property (strong, nonatomic) NSMutableArray *jubaoLeiXing;//

@end

@implementation UserFeedBackViewController

- (NSMutableArray *)jubaoLeiXing{

    if (!_jubaoLeiXing) {
        _jubaoLeiXing = [NSMutableArray array];
        [_jubaoLeiXing addObject:@"虚假信息"];
        [_jubaoLeiXing addObject:@"骚扰、广告"];
        [_jubaoLeiXing addObject:@"辱骂不文明行为"];
        [_jubaoLeiXing addObject:@"色情、暴力"];
        [_jubaoLeiXing addObject:@"酒托、婚托、饭"];
        [_jubaoLeiXing addObject:@"欺骗行为"];
        [_jubaoLeiXing addObject:@"其他"];
    }
    return _jubaoLeiXing;
}

- (instancetype)init {
    self = [super init];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    return self;
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
    debugMethod();
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    [self _initNavBar];
    
    if (_type == 0) {
        
        [self.view addSubview:self.jubaoYuanYinView];
        [self _initTextView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, self.jubaoYuanYinView.bottom, kScreenWidth-32, .3)];
        line.backgroundColor = Line;
        [self.view addSubview:line];
        
        [self _initDropScrollView];
        
    }else if (_type == 1) {
        
        [self _initTextView];
    }
    
    [_textView becomeFirstResponder];
}

- (void)_initNavBar {
    
    UIBarButtonItem *publishBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.publishButton];
    self.navigationItem.rightBarButtonItem = publishBtnItem;
    
}

- (UIView *)jubaoYuanYinView{
    
    if (!_jubaoYuanYinView) {
        
        _jubaoYuanYinView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _jubaoYuanYinView.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, kScreenWidth-100, 50)];
        label.textColor = Font_color333;
        label.text = @"举报原因";
        label.font = [UIFont fontWithName:@"Heiti SC" size:15];
        _juBaoLabel = label;
        [_jubaoYuanYinView addSubview:label];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-46, 0, 30, 50)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = [UIImage imageNamed:@"arrow_right"];
        [_jubaoYuanYinView addSubview:img];
        
        WEAKSELF;
        [_jubaoYuanYinView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            
            [weakSelf.view endEditing:YES];
            
            LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@"选择举报原因" cancelButtonTitle:nil clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                
                if (buttonIndex>0) {
                    weakSelf.jubaoIndex = buttonIndex;
                    weakSelf.juBaoLabel.text = weakSelf.jubaoLeiXing[buttonIndex-1];
                }
                
                 
            } otherButtonTitles:@"虚假信息",@"骚扰、广告",@"辱骂不文明行为",@"色情、暴力",@"酒托、婚托、饭",@"欺骗行为",@"其他", nil];
            
            [actionSheet show];
        }];
    }
    return _jubaoYuanYinView;
}

- (UIButton *)publishButton{
    if (!_publishButton) {
        
        _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishButton.frame = CGRectMake(0, 0, 54, 24);
        _publishButton.layer.cornerRadius = 4.0;
        _publishButton.layer.masksToBounds = YES;
        _publishButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:14];
        [_publishButton setTitle:@"提交" forState:UIControlStateNormal];
        [_publishButton setTitleColor:UIColorHex(FFFFFF) forState:UIControlStateNormal];
        [_publishButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [_publishButton setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(_publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishButton;
}

- (void)_initTextView {
    
    if (_textView) return;
    _textView = [YYTextView new];
    if (_type == 0) {
        _textView.top = _jubaoYuanYinView.bottom;
    }else if (_type == 1) {
        _textView.top = 0;
    }
    _textView.height = 128;
    _textView.width = self.view.width;
    _textView.textContainerInset = UIEdgeInsetsMake(0, 16, 0, 16);
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont fontWithName:@"Heiti SC" size:14];
    _textView.textColor = Font_color333;
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
    
    TextLinePositionModifier *modifier = [TextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:16];
    modifier.paddingTop = 12;
    modifier.paddingBottom = 12;
    modifier.lineHeightMultiple = 1.5;
    _textView.linePositionModifier = modifier;
    
    NSString *placeholderPlainText;
    if (self.type == 0) {
        placeholderPlainText = @"请详情描述您遇到的问题...";
    }else if (self.type == 1) {
        placeholderPlainText = @"请详情描述您遇到的问题...";
    }
    
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.color = UIColorHex(c4c4c4);
        atr.font = [UIFont fontWithName:@"Heiti SC" size:14];
        _textView.placeholderAttributedText = atr;
    }
    _textView.tintColor = ORANGE;

    [self.view addSubview:_textView];
    
}

- (void)_initDropScrollView{
    self.dropScrollView.top = _textView.bottom + 16;
    [self.view addSubview:self.dropScrollView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, _textView.bottom + 16, kScreenWidth-32, .3)];
    line.backgroundColor = Line;
    [self.view addSubview:line];
}

- (NSMutableArray *)imageDatas{
    if (!_imageDatas) {
        _imageDatas = [NSMutableArray array];
    }
    return _imageDatas;
}

- (NSMutableArray *)selectedAssets{
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

- (NSMutableArray *)pics{
    if (!_pics) {
        _pics = [NSMutableArray array];
    }
    return _pics;
}

- (ZDropScrollView *)dropScrollView{
    
    if (!_dropScrollView) {
        _dropScrollView = [[ZDropScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 104)];
        _dropScrollView.o_delegate = self;
        _dropScrollView.o_regionView = self.view;
        _dropScrollView.o_imageDatas = self.imageDatas;
        [_dropScrollView reloadData];
    }
    return _dropScrollView;
    
}

#pragma mark- PreDroScrollViewDelegate
-(void) addNewView:(ZDropScrollView *)scrollView
{
    [self pushImagePickerController];
}

-(void) exchangeIndex:(NSInteger)index otherIndex:(NSInteger)otherIndex
{
    NSLog(@"交换 原始数据 %ld <--> %ld",index,otherIndex);
    [self.imageDatas exchangeObjectAtIndex:index withObjectAtIndex:otherIndex];
    
    [self.selectedAssets exchangeObjectAtIndex:index withObjectAtIndex:otherIndex];
}

-(void) removeIndex:(NSInteger)index
{
    NSLog(@"删除 原始数据 %ld",index);
    [self.imageDatas removeObjectAtIndex:index];
    [self.selectedAssets removeObjectAtIndex:index];
}

-(void) didSelectWithIndex:(NSInteger)index userInfo:(id)userInfo
{
    NSLog(@"select index=%ld,userInfo=%@",(long)index,userInfo);
}

-(void) contentSizeDidChange:(CGSize)contenSize
{
    NSLog(@"content size:%@",NSStringFromCGSize(contenSize));
    
    //可以在此动态修改 ZDropScrollView的高度
    NSLog(@"ZDropScrollView height:%.2f",contenSize.height + _dropScrollView.contentInset.top + _dropScrollView.contentInset.bottom);
    _dropScrollView.height = contenSize.height + _dropScrollView.contentInset.top + _dropScrollView.contentInset.bottom;
}



#pragma mark 点击事件


- (void)_publishBtnClick{
    [self.view endEditing:YES];
    if (![self checkInputIsValid]) {
        return;
    }
    [self uploadImages];
}

- (BOOL)checkInputIsValid{
    NSString *text = _textView.text;
    if (![NSString ins_String:text]) {
        [self.view makeToast:@"不支持空白内容"];
        return NO;
    }
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (text.length < 5) {
        [self.view makeToast:@"内容太少了~"];
        return NO;
    }
    if (_jubaoIndex == 0) {
        [self.view makeToast:@"举报类型还没选择呐~"];
        return NO;
    }
    return YES;
}

- (void)uploadFriendCircle{
    
    [SVProgressHUD show];

    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]init];
    
    
    NSString *url;
    NSString *text = self.textView.text;

    if (_type == 0) {
        
        url = @"/feedback/";
        
        if ([NSString ins_String:text]) {
            [mutableDic setObject:text forKey:@"content"];
            
        }
    }else if (_type == 0) {
        
        url = @"/feedback/reports/";
        
        if ([NSString ins_String:text]) {
            [mutableDic setObject:text forKey:@"detail"];
            
        }
        
        [mutableDic setObject:[NSNumber numberWithInteger:_jubaoIndex] forKey:@"report_type"];
        
        
        if (self.pics.count > 0) {
            [mutableDic setObject:self.pics forKey:@"images"];
        }
        
        [mutableDic setObject:[NSNumber numberWithBool:_to_customer_id] forKey:@"to_customer_id"];
    }
    
    WEAKSELF;
    
    POSTRequest *request = [POSTRequest requestWithPath:@"/moments/" parameters:mutableDic?:nil completionHandler:^(InsRequest *request) {
        
        [SVProgressHUD dismiss];
        
        if (!request.error) {
            if (weakSelf.type == 0) {
                [SVProgressHUD showImage:AlertSuccessImage status:@"举报成功"];
                [SVProgressHUD dismissWithDelay:2];
            }else if (weakSelf.type == 1) {
                [SVProgressHUD showImage:AlertSuccessImage status:@"反馈成功，感谢您的反馈"];
                [SVProgressHUD dismissWithDelay:2];
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            
            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
            [SVProgressHUD dismissWithDelay:2];
            
        }
    }];
    [InsNetwork addRequest:request];
}

- (void)uploadImages{
    
    [self.pics removeAllObjects];
    
    if (_selectedAssets.count == 0) {
        
        [self uploadFriendCircle];
        
    }else{
        NSMutableArray *imageNameArray = [NSMutableArray array];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSInteger i=0; i<self.selectedAssets.count; i++) {
            
            // 占位字符
            [self.pics addObject:@""];
            
            // key
            NSString *objectKey;
            PHAsset *assetModel = self.selectedAssets[i];
            TZAssetModelMediaType mediaType = [[TZImageManager manager]getAssetType:assetModel];
            if (mediaType == TZAssetModelMediaTypePhotoGif) {
                objectKey = [NSString stringWithFormat:@"%f%d.gif",[[NSDate date] timeIntervalSince1970]*1000,arc4random()%INT_MAX];
            }
            if (mediaType == TZAssetModelMediaTypePhoto) {
                objectKey = [NSString stringWithFormat:@"%ld/feedBack/%f/%d.png",[SCUserCenter sharedCenter].currentUser.userInfo.iD,[[NSDate date] timeIntervalSince1970],arc4random()%INT_MAX];
            }
            [imageNameArray addObject:objectKey];
            
            
            // 数据
            UIImage *image = self.imageDatas[i];
            NSData *data;
            if (mediaType == TZAssetModelMediaTypePhotoGif) {
                
                NSArray *imagesFrame =  image.images;
                NSInteger count = imagesFrame.count;
                CGFloat duration = (1.0f / 10.0f) * count;
                
                YYImageEncoder *gifEncoder = [[YYImageEncoder alloc] initWithType:YYImageTypeGIF];
                gifEncoder.loopCount = count;
                for (NSInteger i=0; i<count; i++) {
                    [gifEncoder addImage:imagesFrame[i] duration:duration*i];
                }
                data = [gifEncoder encode];
            }else{
                data = [Help compressImage:image];
            }
            
            [dataArray addObject:data];
        }
        
        
        
        [self.view makeToastActivity:CSToastPositionCenter];
        
        WEAKSELF
        [[SCUploadManager manager] uploadDataToQiNiuWithUrl:@"/token/" fail:^(NSError * _Nonnull error) {
            
            [weakSelf.view hideToastActivity];
            
        } succeed:^(NSString * _Nonnull token) {
            
            FGUploadImageManager *uploadImageManager = [FGUploadImageManager new];
            [uploadImageManager upLoadImageWithImageArray:dataArray token:token onceCompletion:^(NSUInteger index, BOOL isSuccess, NSString *urlStr) {
                
                [weakSelf.pics replaceObjectAtIndex:index withObject:urlStr];
                
            } objectNameArray:imageNameArray completion:^(BOOL isSuccess) {
                [weakSelf.view hideToastActivity];
                if (isSuccess) {
                    [weakSelf uploadFriendCircle];
                }else{
                    [weakSelf.view makeToast:@"图片上传失败" duration:1 position:CSToastPositionCenter];
                }
            }];
        }];
        
        
        
    }
    
    
}

#pragma mark @protocol YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    YYTextLayout *layout = textView.textLayout;
    NSLog(@"layout.rowCount:%ld",layout.rowCount);
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark @protocol YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    //    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    //    if (transition.animationDuration == 0) {
    //        _toolbar.bottom = CGRectGetMinY(toFrame);
    //    } else {
    //        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
    //            _toolbar.bottom = CGRectGetMinY(toFrame);
    //        } completion:NULL];
    //    }
}


#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    imagePickerVc.naviBgColor = [UIColor whiteColor];
    imagePickerVc.naviTitleFont = [UIFont fontWithName:@"Heiti SC" size:17];
    imagePickerVc.naviTitleColor = Font_color333;
    imagePickerVc.oKButtonTitleColorNormal = ORANGE;
    imagePickerVc.oKButtonTitleColorDisabled = kGuaCellHightColor;
    imagePickerVc.barItemTextColor = Font_color333;
    imagePickerVc.barItemTextFont = [UIFont fontWithName:@"Heiti SC" size:15];
    imagePickerVc.iconThemeColor = ORANGE;
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.maxImagesCount = 9;
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO;//可以多选视频/gif图片
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.allowPreview = YES;
#pragma mark - 到这里为止
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
/*!
 @brief  用户点击了取消
 */
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"cancel");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    self.imageDatas = [NSMutableArray arrayWithArray:photos];
    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    _dropScrollView.o_imageDatas = self.imageDatas;
    
    [_dropScrollView reloadData];
}

#pragma mark @protocol WBStatusComposeEmoticonView
- (void)emoticonInputDidTapText:(NSString *)text {
    if (text.length) {
        [_textView replaceRange:_textView.selectedTextRange withText:text];
    }
}

- (void)emoticonInputDidTapBackspace {
    [_textView deleteBackward];
}
@end
