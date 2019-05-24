//
//  ActivityDetialVC.m
//  SocialContact
//
//  Created by EDZ on 2019/5/23.
//  Copyright © 2019 ha. All rights reserved.
//

#import "ActivityDetialVC.h"

@interface ActivityDetialVC ()

@property(nonatomic,strong)YYLabel *titleL;

@property(nonatomic,strong)UIImageView *headImgV;

@property(nonatomic,strong)YYLabel *contentL;

@property(nonatomic,strong)YYLabel *dateL;

@property(nonatomic,strong)YYTextLayout * titleLayout;

@property(nonatomic,strong)YYTextLayout * contentLayout;

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation ActivityDetialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
    
}

- (void)setUpUI{
    
    self.titleLayout = [self createLayout:_articleModel.headline font:[UIFont systemFontOfSize:16]];
    self.titleL.textLayout = self.titleLayout;

    [self.view addSubview:self.titleL];
    [self.view addSubview:self.dateL];
    [self.view addSubview:self.webView];
    
    [self.webView loadHTMLString:_articleModel.content baseURL:nil];
    
   
    self.dateL.text = [self.articleModel.create_at sc_timeAgoWithUTCString];

    [self updateFrame];
    
}

- (void)updateFrame{
    
    self.titleL.height = self.titleLayout.textBoundingSize.height;
    
    self.dateL.top = self.titleL.bottom;
    
    self.webView.top = self.dateL.bottom;
    self.webView.height = kScreenHeight-self.webView.top;
    self.webView.scrollView.bounces = NO;
    
    [self.webView sizeToFit];
    
}

- (YYTextLayout *)createLayout:(NSString *)text font:(UIFont *)font
{
    
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:text];
    
    attString.font = [[UIFont systemFontOfSize:18]fontWithBold];
    attString.lineSpacing = 6;
    attString.color = [UIColor blackColor];
    attString.alignment = NSTextAlignmentCenter;
    
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - 2*10 , [self getSpaceLabelHeightwithText:attString Speace:6 withFont:font withWidth:(kScreenWidth - 2*10)]) ];//3是特殊标点或者表情会多占用的空间
    container.truncationType = YYTextTruncationTypeEnd;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attString];
//    _contentHeight = _contentLayout.textBoundingSize.height;
    
    return layout;
    
}

- (UIWebView *)webView{
    
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 100)];
        
    }
    return _webView;
}

-(CGFloat)getSpaceLabelHeightwithText:(NSMutableAttributedString *)attStr Speace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [attStr.string boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


-(YYLabel *)titleL
{
    if (!_titleL) {
        _titleL = [YYLabel new];
        _titleL.frame = CGRectMake(10, 10, kScreenWidth-20, 40);
        UIFont *font = [UIFont systemFontOfSize:14];
        _titleL.font = font;
        _titleL.textColor = UIColorHex(0D0E15);
    }
    return _titleL;
}

-(YYLabel *)dateL
{
    if (!_dateL) {
        _dateL = [YYLabel new];
        _dateL.frame = CGRectMake(10, 50, kScreenWidth-20, 40);
        _dateL.textAlignment = NSTextAlignmentRight;
        UIFont *font = [UIFont systemFontOfSize:14];
        _dateL.font = font;
        _dateL.textColor = UIColorHex(0D0E15);
    }
    return _dateL;
}

- (UIImageView *)headImgV{
    if (!_headImgV) {
        _headImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenWidth-20)];
        _headImgV.contentMode = UIViewContentModeScaleAspectFill;
        _headImgV.backgroundColor = BackGroundColor;
    }
    return _headImgV;
}

-(YYLabel *)contentL
{
    if (!_contentL) {
        _contentL = [YYLabel new];
        UIFont *font = [UIFont systemFontOfSize:14];
        _contentL.font = font;
        _contentL.textColor = UIColorHex(0D0E15);
    }
    return _contentL;
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
