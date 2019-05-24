//
//  GreetVC.m
//  SocialContact
//
//  Created by EDZ on 2019/3/28.
//  Copyright © 2019 ha. All rights reserved.
//

#import "GreetVC.h"
#import "SayHiCell.h"
#import "SayHiTemplateModel.h"

#define BGColor [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]
#define NumberOfSinglePage 6 // 一个页面可容纳的最多按钮数
#define ViewGap 10
#define ViewMargin 10

@interface GreetVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) UIButton *sureBtn;

@property(nonatomic,strong)NSMutableArray *messageTemplatesArray;

@end

@implementation GreetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.dataArray = [NSMutableArray array];
    self.messageTemplatesArray = [NSMutableArray array];
    [self initPop];
    self.view.layer.cornerRadius = 10.f;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.sureBtn];
    
    [self fetchData];
    
    
}

- (void)initPop {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat height = 450;
    self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width*0.8, height);
    self.popupController.navigationBarHidden = YES;
    [self.popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
}

- (void)backgroundTap  {
    [self.popupController dismiss];
}

- (void)sayHi{
    
    [SVProgressHUD show];
    
    // 融云发消息
    
    [self backgroundTap];
    
    // 打招呼个数减少
    NSInteger sayHiCount = [[[NSUserDefaults standardUserDefaults]objectForKey:kSayHiCount]integerValue];
    sayHiCount --;
    [[NSUserDefaults standardUserDefaults]setObject:@(sayHiCount) forKey:kSayHiCount];
    
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        
        if (i%5== 0 && i != 0 ) {
            sleep(1);
        }
        SCUserInfo *userInfo = self.dataArray[i];
        
        if (!userInfo.isSelectedSayHi) {
            continue;
        }else{
            NSString *content = @"";
            if (self.messageTemplatesArray.count > 0) {
                NSInteger sayMessageIndex = arc4random()%self.messageTemplatesArray.count;
                SayHiTemplateModel *model =self.messageTemplatesArray[sayMessageIndex];
                content = model.text;
            }
            
            if (content.length == 0) {
                content = [NSString stringWithFormat:@"您好，%@，我是%@，很高兴认识你",userInfo.name, [SCUserCenter sharedCenter].currentUser.userInfo.name];
            }
            
            RCTextMessage *rcMC = [RCTextMessage messageWithContent:content];
            
            NSInteger targetId = userInfo.iD;
            if (targetId == 0) {
                targetId = userInfo.user_id;
            }
            [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId: [NSString stringWithFormat:@"%ld",targetId] content:rcMC pushContent:content pushData:content success:^(long messageId) {
                
                NSLog(@"打招呼成功");
                
            } error:^(RCErrorCode nErrorCode, long messageId) {
                NSLog(@"打招呼失败");
                
            }];
        }
    }
    
    [SVProgressHUD dismiss];
    
    
    [SVProgressHUD showImage:AlertSuccessImage status:@"打招呼成功"];
    [SVProgressHUD dismissWithDelay:1.5];
    
}

- (void)fetchData{
    
//    /api/message-templates/
    
    NSDictionary *dic = @{
                          @"page":@(1),
                          };
    WEAKSELF;
    GETRequest *request = [GETRequest requestWithPath:@"/api/message-templates/" parameters:dic completionHandler:^(InsRequest *request) {
        
        if (request.error) {
            
            // 消息模板不用提示错误了
//            [SVProgressHUD showImage:AlertErrorImage status:request.error.localizedDescription];
//            [SVProgressHUD dismissWithDelay:1.5];
            
        }else{
            
            [weakSelf.messageTemplatesArray removeAllObjects];
            
            NSArray *resultArray = request.responseObject[@"data"][@"results"];
            
            if ( resultArray && resultArray.count > 0 ) {
                
                [resultArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    SayHiTemplateModel *model = [SayHiTemplateModel modelWithDictionary:obj];
                    [weakSelf.messageTemplatesArray addObject:model];
                    
                }];
            }
        }
    }];
    [InsNetwork addRequest:request];
    
    

}

-(UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"一键打招呼" forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 25.0;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sayHi) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setBackgroundColor:ORANGE];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureBtn.titleLabel.textColor = [UIColor whiteColor];
        _sureBtn.frame = CGRectMake(40, 390, self.view.width-80, 50);
    }
    return _sureBtn;
}



#pragma mark 创建collectionView

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 390) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 10, *)) {
            [_collectionView setPrefetchingEnabled: NO];
        }
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.view addSubview:_collectionView];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"SayHiCell" bundle:nil] forCellWithReuseIdentifier:@"SayHiCell"];
        [_collectionView reloadData];
    }
    return _collectionView;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SayHiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SayHiCell" forIndexPath:indexPath];
    
    SCUserInfo *userModel = self.dataArray[indexPath.row];
    cell.userModel = userModel;
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    CGFloat space;
    if (self.view.width-4*80>10) {
        space = (self.view.width-4*80-3*5)/2.0-1;
    }else{
        space =  (self.view.width-3*80-2*5)/2.0-1;
    }
    return space;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 120);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
