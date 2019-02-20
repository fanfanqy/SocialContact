//
//  NewDynamicsLayout.m
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/27.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import "NewDynamicsLayout.h"
#import "SDWeiXinPhotoContainerView.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

@implementation NewDynamicsLayout

- (instancetype)initWithModel:(MomentModel *)model momentUIType:(MomentUIType)momentUIType momentRequestType:(MomentRequestType)momentRequestType
{
    self = [super init];
    if (self) {
        _model = model;
		_momentUIType = momentUIType;
        _momentRequestType = momentRequestType;
        [self resetLayout];
    }
    return self;
}

- (void)resetLayout
{
    _height = 0;
    _commentHeight = 0;
    
    if (_momentRequestType == MomentRequestTypeSkill) {
        
        NSDate *date = [NSDate dateWithISOFormatString:_model.last_request_at];
        _formatedTimeString = [WBStatusHelper stringWithTimelineDate:date];
        
    }else{
        NSDate *date = [NSDate dateWithISOFormatString:_model.update_at];
        _formatedTimeString = [WBStatusHelper stringWithTimelineDate:date];
    }
    
    _height += kMomentContentInsetTop;
    _height += kMomentPortraitWH;
    
//		帖子内容
    [self layoutDetail];
    if (_contentLayout.textBoundingSize.height > 0) {
        _height += kMomentAvatarBottomContentTop;
        _height += _contentLayout.textBoundingSize.height;
        _height += kMomentContentBottomPhotoContainTop;
    }
    if (_momentRequestType == MomentRequestTypeSkill) {
        // 底部间隙
        _height += 16;
        return;
    }

//		照片
    if (_model.images.count != 0) {
        [self layoutPicture];
        _height += _photoContainerSize.height;
        _height += kMomentPhotoContainBottomTopicTop;
    }
		
// 时间的高度
    _height += 20;
    
// 底部间隙
    _height += 16;
	
    
    if (self.commentLayoutArr.count > 0 || _zanUsers.count > 0) {
        [self layoutComment];
        _commentHeight += 45; // 最新评论
        [self layoutZanUsers];
        
        _height += _commentHeight;
    }
    
}

- (void)layoutDetail
{
    _contentLayout = nil;
    NSString *text = @"";

     if (_momentRequestType == MomentRequestTypeSkill) {
         if (!_model.skills) {
             return;
         }
         text = _model.skills;
     }else{
         if (!_model.text) {
             return;
         }
         text = _model.text;
     }
	
	NSString *convertToSystemEmoticonsText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:text];
	
    // 去掉首尾空格和换行符
    convertToSystemEmoticonsText = [convertToSystemEmoticonsText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:convertToSystemEmoticonsText];
	
	attString.font = [UIFont systemFontOfSize:15];
	attString.lineSpacing = 6;
	attString.color = UIColorHex(0D0E15);
	attString.alignment = NSTextAlignmentJustified;
	
	YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - 2*kMomentContentInsetLeft , [self getSpaceLabelHeightwithText:attString Speace:6 withFont:[UIFont systemFontOfSize:15] withWidth:(kScreenWidth - 2*kMomentContentInsetLeft)]) ];//3是特殊标点或者表情会多占用的空间
    container.truncationType = YYTextTruncationTypeEnd;
    _contentLayout = [YYTextLayout layoutWithContainer:container text:attString];
    _contentHeight = _contentLayout.textBoundingSize.height;
    
}

- (void)layoutPicture
{
    self.photoContainerSize = CGSizeZero;
    self.photoContainerSize = [SDWeiXinPhotoContainerView getContainerSize:_model.images width:kScreenWidth-2*kMomentContentInsetLeft];
    
    self.photosUrlsArray = [NSMutableArray array];
    for (MomentImageModel *model in _model.images) {
        [self.photosUrlsArray addObject:model.url?:@""];
    }
    self.perRowItemCount = [SDWeiXinPhotoContainerView perRowItemCountForPicPathArray:_model.images];
    self.itemWidth = [SDWeiXinPhotoContainerView itemWidth:_model.images width:kScreenWidth-2*kMomentContentInsetLeft];
    self.itemHeight = self.itemWidth;
    
}

/**
 *  计算富文本字体高度
 *
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
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

- (void)layoutZanUsers{
    
    _zanUsersLayout = nil;
    NSString *text = @"";
    
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:[UIImage imageNamed:@"find_dianzhan"] contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(20, 20) alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
    [attString appendAttributedString:attachText];
    
    for (LikeModel *model in self.zanUsers) {
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:model.customer.name];
        attStr.font = [UIFont systemFontOfSize:15];
        attStr.lineSpacing = 6;
        attStr.color = [UIColor whiteColor];
        attStr.alignment = NSTextAlignmentJustified;
        
        YYTextBorder *normalBorder = [YYTextBorder new];
        normalBorder.insets = UIEdgeInsetsMake(-4, 0, -4, 0);
//        normalBorder.cornerRadius = 8;
        normalBorder.fillColor = BLUE;
        [attStr setTextBackgroundBorder:normalBorder];
        
        // 高亮状态的背景
        YYTextBorder *highlightBorder = [YYTextBorder new];
        highlightBorder.insets = UIEdgeInsetsMake(-4, 0, -4, 0);
//        highlightBorder.cornerRadius = 8;
        highlightBorder.fillColor = ORANGE;
        
        // 高亮状态
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setBackgroundBorder:highlightBorder];
        // 数据信息，用于稍后用户点击
        highlight.userInfo = @{@"kLikeUserId" : [NSNumber numberWithInteger:model.customer.iD]};
        [attStr setTextHighlight:highlight range:attStr.rangeOfAll];
        
        NSMutableAttributedString * konggeAttStr = [[NSMutableAttributedString alloc] initWithString:@" "];
        [attString appendAttributedString:konggeAttStr];
        [attString appendAttributedString:attStr];
        [attString appendAttributedString:konggeAttStr];
    }
    
    attString.font = [UIFont systemFontOfSize:15];
    attString.lineSpacing = 6;
    attString.color = [UIColor whiteColor];
    attString.alignment = NSTextAlignmentJustified;
    
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - 2*kMomentContentInsetLeft , [self getSpaceLabelHeightwithText:attString Speace:6 withFont:[UIFont systemFontOfSize:15] withWidth:(kScreenWidth - 2*kMomentContentInsetLeft)]) ];//3是特殊标点或者表情会多占用的空间
    container.truncationType = YYTextTruncationTypeEnd;
    _zanUsersLayout = [YYTextLayout layoutWithContainer:container text:attString];
    _zanUsersHeight = _zanUsersLayout.textBoundingSize.height;
    _zanUsersHeight += 10;// 上部加10
    _commentHeight += _zanUsersHeight;
    
}

- (void)layoutComment{

    for (int i = 0; i < self.commentLayoutArr.count; i++) {
        CommentLayout *layout = self.commentLayoutArr[i];
        _commentHeight += layout.height;
        
    }

}

-(NSMutableArray *)commentLayoutArr
{
    if (!_commentLayoutArr) {
        _commentLayoutArr = [NSMutableArray array];
    }
    return _commentLayoutArr;
}

@end

@implementation CommentLayout

- (instancetype)initWithModel:(CommentModel *)model{
	self = [super init];
	if (self) {
		_model = model;
		[self resetLayout];
	}
	return self;
}

- (void)resetLayout{

    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] init];
    text.lineSpacing = kDynamicsLineSpacing;
    text.alignment = NSTextAlignmentJustified;
    text.color = UIColorHex(0D0E15);
    
    //        YYTextHighlight * highLight = [YYTextHighlight new];
    //        [nick setColor:UIColorHex(3A444A) range:nick.rangeOfAll];
    
    //        highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
    //            if (weakSelf.clickUserBlock) {
    //                weakSelf.clickUserBlock(model.userid);
    //            }
    //        };
    //        [nick setTextHighlight:highLight range:nick.rangeOfAll];
    
    if (_model.from_customer) {
        
        NSString *convertToSystemEmoticonsText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:_model.from_customer.name];
        
        NSMutableAttributedString * nick = [[NSMutableAttributedString alloc] initWithString:convertToSystemEmoticonsText];
        nick.color = UIColorHex(0D0E15);
        nick.alignment = NSTextAlignmentJustified;
        nick.lineSpacing = kDynamicsLineSpacing;
        nick.font = [UIFont systemFontOfSize:14];
        
        [text appendAttributedString:nick];
    }
    
    if (_model.to_customer) {
        NSString *convertToSystemEmoticonsText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:_model.to_customer.name];
    
        NSMutableAttributedString * tonick = [[NSMutableAttributedString alloc] initWithString:convertToSystemEmoticonsText];
        tonick.font = [UIFont systemFontOfSize:14];
        [tonick setColor:UIColorHex(0D0E15) range:tonick.rangeOfAll];
    
        NSMutableAttributedString * hfText = [[NSMutableAttributedString alloc] initWithString:@" 回复 "];
        hfText.alignment = NSTextAlignmentJustified;
        hfText.lineSpacing = kDynamicsLineSpacing;
        [hfText setColor:UIColorHex(666666) range:hfText.rangeOfAll];
        hfText.font = [UIFont systemFontOfSize:14];
        [text appendAttributedString:hfText];
        [text appendAttributedString:tonick];
    
        NSMutableAttributedString * fhText = [[NSMutableAttributedString alloc] initWithString:@"："];
        fhText.lineSpacing = kDynamicsLineSpacing;
        fhText.alignment = NSTextAlignmentJustified;
        fhText.font = [UIFont systemFontOfSize:14];
        [text appendAttributedString:fhText];
    }
    
    
    NSMutableAttributedString * contentText = [[NSMutableAttributedString alloc] init];
    contentText.lineSpacing = kDynamicsLineSpacing;
    contentText.alignment = NSTextAlignmentJustified;
    contentText.color = UIColorHex(0D0E15);
    if (_model.text) {
        
        NSString *convertToSystemEmoticonsText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:_model.text];
        
        NSMutableAttributedString * message = [[NSMutableAttributedString alloc] initWithString:convertToSystemEmoticonsText];
        message.alignment = NSTextAlignmentJustified;
        message.lineSpacing = kDynamicsLineSpacing;
        message.color = UIColorHex(0D0E15);
        message.font = [UIFont systemFontOfSize:14];
        [contentText appendAttributedString:message];
    }
        
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - kMomentContentInsetLeft * 2 - 10 - kMomentPortraitWH,CGFLOAT_MAX)]; // 左右间距、头像宽高、间距10
    YYTextLayout * textLayout = [YYTextLayout layoutWithContainer:container text:text];
    self.nickNameLayout = textLayout;
    
    
    YYTextLayout * contentLayout = [YYTextLayout layoutWithContainer:container text:contentText];

    self.commentLayout = contentLayout;

    self.commentHeight = contentLayout.textBoundingRect.size.height;
    
    if (self.commentHeight > 20) {
        self.height =  10 + kMomentPortraitWH/2.0 + self.commentHeight;
    }else{
        self.height =  10 + kMomentPortraitWH;
    }
    // 底部间距 10
    self.height += 10;
    
}

@end
