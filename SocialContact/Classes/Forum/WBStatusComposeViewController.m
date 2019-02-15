//
//  WBStatusComposeViewController.m
//  YYKitExample
//
//  Created by ibireme on 15/9/8.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "WBStatusComposeViewController.h"
//#import "WBEmoticonInputView.h"
//#import "WBStatusComposeTextParser.h"
#import "WBStatusHelper.h"
#import "TextLinePositionModifier.h"
#import "ZDropScrollView.h"
#import "ZDeleteRegionView.h"

// 选择话题
#import "ForumVC.h"

#import "SCUploadManager.h"


//#define kToolbarHeight (35 + 46)
#define kToolbarHeight (52)

@interface WBStatusComposeViewController() <YYTextViewDelegate, YYTextKeyboardObserver,ZDropScrollViewDelegate,ForumVCDelegate,TZImagePickerControllerDelegate>

@property (strong, nonatomic) UIButton *publishButton;

@property (nonatomic, strong) YYTextView *textView;

@property (nonatomic, strong) UIView *toolbar;

@property (nonatomic, strong) UIButton *toolbarTopicButton;
@property (strong, nonatomic) UIButton *anonymButton;


@property (nonatomic,strong) ZDropScrollView* dropScrollView;

@property (nonatomic,strong) NSMutableArray* imageDatas;//image 类型数组
@property (strong, nonatomic) NSMutableArray *selectedAssets;// asset
@property (strong, nonatomic) NSMutableArray *pics;// url 类型

// 话题
@property (nonatomic,strong)TopicModel *selectedTopicModel;

// 匿名
@property (assign, nonatomic) BOOL anonym;

@end

@implementation WBStatusComposeViewController

- (instancetype)init {
    self = [super init];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    return self;
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
	debugMethod();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    WEAKSELF;
//    [self.view jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
//        [weakSelf.view endEditing:YES];
//    }];
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self _initNavBar];
    [self _initTextView];
    [self _initToolbar];
	[self _initDropScrollView];
    [_textView becomeFirstResponder];
	
}

- (void)_initNavBar {
	self.title = @"发帖";
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(_cancel)];
    [button setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                     NSForegroundColorAttributeName : UIColorHex(0D0E15)} forState:UIControlStateNormal];
	[button setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],
									 NSForegroundColorAttributeName : UIColorHex(0D0E15)} forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = button;
	
	UIBarButtonItem *publishBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.publishButton];
	self.navigationItem.rightBarButtonItem = publishBtnItem;

}



- (UIButton *)publishButton{
	if (!_publishButton) {
		
		_publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_publishButton.frame = CGRectMake(0, 0, 54, 24);
		_publishButton.layer.cornerRadius = 4.0;
		_publishButton.layer.masksToBounds = YES;
		_publishButton.titleLabel.font = [UIFont systemFontOfSize:14];
		[_publishButton setTitle:@"发表" forState:UIControlStateNormal];
		[_publishButton setTitleColor:UIColorHex(FFFFFF) forState:UIControlStateNormal];
		[_publishButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
		[_publishButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(63D190)] forState:UIControlStateNormal];
		[_publishButton addTarget:self action:@selector(_publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
	}
	return _publishButton;
}

- (void)_initTextView {
    if (_textView) return;
    _textView = [YYTextView new];
    _textView.top = 0;
	_textView.height = 128;
	_textView.width = self.view.width;
	_textView.textContainerInset = UIEdgeInsetsMake(0, 16, 0, 16);
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
	
    TextLinePositionModifier *modifier = [TextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:16];
    modifier.paddingTop = 12;
    modifier.paddingBottom = 12;
    modifier.lineHeightMultiple = 1.5;
    _textView.linePositionModifier = modifier;
	
	
	NSString *placeholderPlainText = @"分享新鲜事...";
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.color = UIColorHex(c4c4c4);
        atr.font = [UIFont systemFontOfSize:16];
        _textView.placeholderAttributedText = atr;
    }
	
//    if (_autoTopicName) {
//        _textView.text = _autoTopicName;
//    }
    
    [self.view addSubview:_textView];
	
}

- (void)_initToolbar {
    if (_toolbar) return;
    _toolbar = [UIView new];
    _toolbar.backgroundColor = [UIColor whiteColor];
	_toolbar.top = _textView.bottom;
    _toolbar.size = CGSizeMake(self.view.width, kToolbarHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_toolbar];
	
	
    _toolbarTopicButton = [self _toolbarButtonWithImage:@"ic_topic" highlight:nil];
	
	_anonymButton = [self _toolbarButtonWithImage:@"anonymous_1" highlight:nil];
	
	
    CGFloat padding = 16;
    
    _toolbarTopicButton.centerX = padding + _toolbarTopicButton.width/2;
	_anonymButton.centerX = kScreenWidth - padding - _anonymButton.width/2;
	
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, kToolbarHeight)];
    label.text = @"是否匿名";
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.font = [UIFont systemFontOfSize:15];
    label.centerX = _anonymButton.left - 25;
    [_toolbar addSubview:label];
    
    
	UIView *line = [UIView new];
	line.backgroundColor = Line;
	line.top = kToolbarHeight-1;
	line.left = 0;
	line.width = _toolbar.width;
	line.height = 0.3;
	line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[_toolbar addSubview:line];
}

- (UIButton *)_toolbarButtonWithImage:(NSString *)imageName highlight:(NSString *)highlightImageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.size = CGSizeMake(28, 28);
	if (imageName) {
		[button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	}
	if (highlightImageName) {
		[button setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
	}
    button.centerY = kToolbarHeight / 2;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:button];
    return button;
}

- (void)_initDropScrollView{
	self.dropScrollView.top = _toolbar.bottom + 16;
	[self.view addSubview:self.dropScrollView];
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
- (void)_cancel {
    [self.view endEditing:YES];
    if (_dismiss){
        _dismiss();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

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
		[self.view makeToast:@"不支持空内容的发表哟"];
		return NO;
	}
	text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
	if (text.length < 5) {
		[self.view makeToast:@"内容太少了~"];
		return NO;
	}
	
	return YES;
}

- (void)uploadFriendCircle{
		
    [SVProgressHUD show];
    
    /*
        text    string    True        动态正文
        images    string    False    ["http://a.jpg", "http://b.jpg"]    图片列表
        latitude    float    False        经度
        longitude    float    False        纬度
        address    str    False        地址
        is_hidden_name    bool    False        匿名， 默认False
        function_type    int        用途。1：普通动态，2：广告， 3：通知
        topic    list        话题列表
    */
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]init];
    
    NSString *text = self.textView.text;
    if ([NSString ins_String:text]) {
        [mutableDic setObject:text forKey:@"text"];
    }
    
    if (self.pics.count > 0) {
        [mutableDic setObject:self.pics forKey:@"images"];
    }
    
    if ([SCUserCenter sharedCenter].currentUser.userInfo.latitude != 0) {
        [mutableDic setObject:[NSNumber numberWithFloat:[SCUserCenter sharedCenter].currentUser.userInfo.latitude] forKey:@"latitude"];
        [mutableDic setObject:[NSNumber numberWithFloat:[SCUserCenter sharedCenter].currentUser.userInfo.longitude] forKey:@"longitude"];
    }
    
    if ([SCUserCenter sharedCenter].currentUser.userInfo.myLocation) {
        [mutableDic setObject:[SCUserCenter sharedCenter].currentUser.userInfo.myLocation forKey:@"address"];
    }
    
    [mutableDic setObject:[NSNumber numberWithBool:_anonym] forKey:@"is_hidden_name"];
    
    [mutableDic setObject:@(1) forKey:@"function_type"];
    
    if (_topicModel) {
//        [mutableDic setObject:@[[NSNumber numberWithInteger:_topicModel.iD]] forKey:@"topic"];
        [mutableDic setObject:_topicModel.name forKey:@"topic"];
    }
    
//    NSDictionary *params = @{@"account":self.phoneTF.text?:@"",@"password":_vcPWTF.text?:@"",@"code":self.vcTF.text?:@""
//                             };
    
    WEAKSELF;
    POSTRequest *request = [POSTRequest requestWithPath:@"/moments/" parameters:mutableDic?:nil completionHandler:^(InsRequest *request) {
        
        [SVProgressHUD dismiss];
        
        if (!request.error) {
            
            [SVProgressHUD showImage:AlertSuccessImage status:@"发表成功"];
            [SVProgressHUD dismissWithDelay:2];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            
            [SVProgressHUD showImage:AlertErrorImage status:request.responseObject[kRequestMessageKey]];
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
                objectKey = [NSString stringWithFormat:@"%f%d.png",[[NSDate date] timeIntervalSince1970]*1000,arc4random()%INT_MAX];
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



- (void)_buttonClicked:(UIButton *)button {

    if (button == _toolbarTopicButton) {
        ForumVC *vc = [ForumVC new];
        vc.forumVCType = ForumVCTypeTopicSelect;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
		
	}else if (button == _anonymButton) {
		
		_anonym = !_anonym;
		
		if (_anonym) {
			[_anonymButton setImage:[UIImage imageNamed:@"anonymous"] forState:UIControlStateNormal];
		}else{
			[_anonymButton setImage:[UIImage imageNamed:@"anonymous_1"] forState:UIControlStateNormal];
		}
		
	}
}

- (void)topicSelected:(TopicModel *)topicModel{
    _topicModel = topicModel;
    [_toolbarTopicButton setTitleColor:Font_color333 forState:UIControlStateNormal];
    [_toolbarTopicButton setTitle:_topicModel.name forState:UIControlStateNormal];
    [_toolbarTopicButton setImage:nil forState:UIControlStateNormal];
    [_toolbarTopicButton sizeToFit];
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
	imagePickerVc.naviTitleFont = [UIFont systemFontOfSize:16];
	imagePickerVc.naviTitleColor = UIColorHex(0D0E15);
	imagePickerVc.oKButtonTitleColorNormal = UIColorHex(62D694);
	imagePickerVc.oKButtonTitleColorDisabled = kGuaCellHightColor;
	imagePickerVc.barItemTextColor = UIColorHex(0D0E15);
	imagePickerVc.barItemTextFont = [UIFont systemFontOfSize:16];
	imagePickerVc.iconThemeColor = UIColorHex(62D694);
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
	imagePickerVc.allowPickingOriginalPhoto = NO;
	imagePickerVc.allowPickingGif = NO;
	imagePickerVc.allowPickingMultipleVideo = YES;//可以多选视频/gif图片
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
