//
//  NewDynamicsTableViewCell.m
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/27.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import "NewDynamicsTableViewCell.h"


@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		[self setup];
	}
	return self;
}

- (void)setup{
	[self.contentView addSubview:self.portrait];
	[self.contentView addSubview:self.nameLabel];
	[self.contentView addSubview:self.commentLabel];
}

- (void)setLayout:(CommentLayout *)layout{
	
    //头像
    _portrait.left = kMomentContentInsetLeft;
    _portrait.top = 10;
    _portrait.size = CGSizeMake(kMomentPortraitWH, kMomentPortraitWH);

    if (_cell.layout.model.is_hidden_name) {
        _portrait.image = [UIImage imageNamed:@"anonymous_1"];
    }else{
        UIImage *placeHoldImage = [UIImage imageNamed:@"anonymous_1"];
       
        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:layout.model.from_customer.avatar_url]];

        BOOL isExit = [[SDWebImageManager sharedManager].imageCache diskImageDataExistsWithKey:cacheImageKey];

        if (isExit) {
            placeHoldImage = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:layout.model.from_customer.avatar_url];
        }
        
        NSString *avatarUrl = @"";
        if ([NSString ins_String:layout.model.from_customer.avatar_url]) {
            avatarUrl = layout.model.from_customer.avatar_url;
            if (![avatarUrl containsString:@"http"]) {
                avatarUrl = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,avatarUrl];
            }
        }
        if (![avatarUrl containsString:@"http"]) {
            avatarUrl = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,avatarUrl];
        }
        [_portrait sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:placeHoldImage options:SDWebImageRefreshCached];
    }

    //昵称
    _nameLabel.textLayout = layout.nickNameLayout;
    _nameLabel.top = _portrait.top;
    _nameLabel.left = _portrait.right + 8;
    CGSize nameSize = [_nameLabel sizeThatFits:CGSizeZero];
    _nameLabel.width = nameSize.width;
    _nameLabel.height = 20;

    _commentLabel.left = _portrait.right + 8;
    _commentLabel.top = _nameLabel.bottom+4;
    _commentLabel.textLayout = layout.commentLayout;
    _commentLabel.width = kScreenWidth  - kMomentPortraitWH - kMomentContentInsetRight * 2 - 10 ;
    _commentLabel.height = layout.commentHeight;
	
}

-(UIImageView *)portrait
{
	if(!_portrait){
		_portrait = [UIImageView new];
		_portrait.userInteractionEnabled = YES;
		_portrait.backgroundColor = UIColorHex(FCFCFC);
		_portrait.layer.cornerRadius = 20.0;
		_portrait.layer.masksToBounds = YES;
		_portrait.layer.contentMode = UIViewContentModeScaleAspectFit;
		UITapGestureRecognizer *tapCommenter = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCommenterPortrait:)];
		[_portrait addGestureRecognizer:tapCommenter];
		
		UILongPressGestureRecognizer *longpresCommenter = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressCommenterPortrait:)];
		[_portrait addGestureRecognizer:longpresCommenter];
		
	}
	return _portrait;
}

- (void)tapCommenterPortrait:(UITapGestureRecognizer *)tap{
	
	UIImageView *portrait = tap.view;
	CommentTableViewCell *cell = (CommentTableViewCell *)portrait.superview.superview;
	NSIndexPath *indexPath = cell.indexPath;
	
	if ([self.cell.delegate respondsToSelector:@selector(cellDidClickCommenterPortait:indexPath:)]) {
		[self.cell.delegate cellDidClickCommenterPortait:self.cell indexPath:indexPath];
	}
}

- (void)longpressCommenterPortrait:(UILongPressGestureRecognizer *)longpress{
	
	if (longpress.state == UIGestureRecognizerStateBegan) {
		UIImageView *portrait = longpress.view;
		CommentTableViewCell *cell = (CommentTableViewCell *)portrait.superview.superview;
		NSIndexPath *indexPath = cell.indexPath;
		
		if ([self.cell.delegate respondsToSelector:@selector(cellDidLongPressCommenterPortait:indexPath:)]) {
			[self.cell.delegate cellDidLongPressCommenterPortait:cell indexPath:indexPath];
		}
	}
	
}

-(YYLabel *)nameLabel
{
	if (!_nameLabel) {
		_nameLabel = [YYLabel new];
		UIFont *font = [UIFont fontWithName:@"Heiti SC" size:14];
		_nameLabel.font = font;
		_nameLabel.textColor = UIColorHex(0D0E15);
	}
	return _nameLabel;
}

-(YYLabel *)commentLabel
{
	if (!_commentLabel) {
		_commentLabel = [YYLabel new];
		_commentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
	}
	return _commentLabel;
}


@end

@implementation NewDynamicsThumbCommentView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.userInteractionEnabled = YES;
    [self addSubview:self.commentTable];
}

- (void)CommentArr:(NSMutableArray *)commentArr DynamicsLayout:(NewDynamicsLayout *)layout
{
    self.commentArray = layout.commentLayoutArr;
    _layout = layout;
    _commentTable.left = 0;
    _commentTable.top = 0;
    _commentTable.width = kScreenWidth;
    _commentTable.height = _layout.commentHeight;
    
    [self.commentTable reloadData];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45 + _cell.layout.zanUsersHeight)];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.3)];
    line.backgroundColor = Line;
    
    YYLabel *zanUsersLabel = [[YYLabel alloc]initWithFrame:CGRectMake(kMomentContentInsetLeft, 10, kScreenWidth-2*kMomentContentInsetLeft, _cell.layout.zanUsersHeight+5)];
    WEAKSELF;
    zanUsersLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weakSelf.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weakSelf.cell.delegate cell:weakSelf.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    zanUsersLabel.textLayout = _cell.layout.zanUsersLayout;
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(kMomentContentInsetLeft, _cell.layout.zanUsersHeight + 15 + 6, 20, 20)];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.image = [UIImage imageNamed:@"find_comment"];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, _cell.layout.zanUsersHeight + 15, kScreenWidth-50, 30)];
    label.font = [UIFont fontWithName:@"Heiti SC" size:14];
    label.textColor = Font_color333;
    if (self.commentArray.count == 0) {
        label.text = @"最新评论";
    }else {
        label.text = [NSString stringWithFormat:@"最新评论 %ld",self.commentArray.count];
    }
    [view addSubview:zanUsersLabel];
    [view addSubview:imgV];
    [view addSubview:label];
    [view addSubview:line];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _cell.layout.zanUsersHeight + 45.f;
}

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentLayout * layout = self.commentArray[indexPath.row];
    return layout.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    
    CommentLayout * layout = self.commentArray[indexPath.row];
	
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.cell = self.cell;
	cell.indexPath = indexPath;
	[cell setLayout:layout];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	if ([self.cell.delegate respondsToSelector:@selector(cellDidClickReply:indexPath:)]) {
		[self.cell.delegate cellDidClickReply:self.cell indexPath:indexPath];
	}
}

-(UITableView *)commentTable
{
    if (!_commentTable) {
        _commentTable = [UITableView new];
        _commentTable.dataSource = self;
        _commentTable.delegate = self;
        _commentTable.scrollEnabled = NO;
        _commentTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _commentTable.separatorColor = Line;
        _commentTable.backgroundColor = [UIColor clearColor];
    }
    return _commentTable;
}


@end

@implementation NewDynamicsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{
	self.backgroundColor = [UIColor clearColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:self.customBackView];
    
    
    [self.contentView addSubview:self.portrait];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.address];
    
    [self.contentView addSubview:self.content];
    [self.contentView addSubview:self.picContainerView];
    [self.contentView addSubview:self.topics];
    
    [self.contentView addSubview:self.zanBtn];
    [self.contentView addSubview:self.zanCount];
    
    [self.contentView addSubview:self.commentBtn];
    [self.contentView addSubview:self.commentCount];
    
    [self.contentView addSubview:self.commentView];
    
    [self.contentView addSubview:self.sectionView];
    
    self.portrait.left = kMomentContentInsetLeft;
    self.portrait.top = kMomentContentInsetTop;
    self.portrait.width = kMomentPortraitWH;
    self.portrait.height = kMomentPortraitWH;
    
    self.time.top = kMomentContentInsetTop+kMomentPortraitWH/2.0;
    self.time.left = kScreenWidth-kMomentContentInsetRight-150;
    self.time.width = 150;
    self.time.height = kMomentPortraitWH/2.0;
    
    self.name.top = kMomentContentInsetTop;
    self.name.left = kMomentContentInsetLeft + kMomentPortraitWH + kMomentAvatarRightNickLeft/2.0;
    self.name.width = kScreenWidth-kMomentContentInsetRight-kMomentPortraitWH - kMomentAvatarRightNickLeft/2.0;
    self.name.height = kMomentPortraitWH/2.0;
    
    self.address.top = self.name.bottom;
    self.address.left = self.name.left;
    self.address.width = 100;
    self.address.height = kMomentPortraitWH/2.0;
    
    self.content.top = self.portrait.bottom + kMomentAvatarBottomContentTop;
    self.content.left = kMomentContentInsetLeft;
    self.content.width = kScreenWidth - 2*kMomentContentInsetRight;
    self.content.height = 20;
    
    self.picContainerView.top = self.content.bottom + kMomentContentBottomPhotoContainTop;
    self.picContainerView.left = kMomentContentInsetLeft;
    self.picContainerView.width = kScreenWidth - 2*kMomentContentInsetRight;
    self.picContainerView.height = 100;
    
    self.topics.left = kMomentContentInsetLeft;
    self.topics.width = 200;
    self.topics.height = 20;

    
    self.zanCount.width = 30;
    self.zanCount.right =  kScreenWidth-kMomentContentInsetRight;
    self.zanCount.height = 20;
    
    self.zanBtn.width = 20;
    self.zanBtn.height = 20;
    self.zanBtn.right = self.zanCount.left - 5;

    self.commentCount.width = 30;
    self.commentCount.height = 20;
    self.commentCount.right = self.zanBtn.left - 5;

    self.commentBtn.width = 20;
    self.commentBtn.height = 20;
    self.commentBtn.right = self.commentCount.left - 5;

    self.sectionView.left = 0;
    self.sectionView.width = kScreenWidth;
    self.sectionView.height = kDynamicsSectionViewHeight;
    


    /*
     
     static CGFloat const kMomentContentInsetLeft = 15;
     static CGFloat const kMomentContentInsetTop = 15;
     static CGFloat const kMomentContentInsetRight = 15;
     static CGFloat const kMomentContentInsetBootm = 15;
     
     
     static CGFloat const kMomentAvatarRightNickLeft =20;
     
     static CGFloat const kMomentAvatarBottomContentTop =20;
     
     static CGFloat const kMomentContentBottomPhotoContainTop =20;
     
     static CGFloat const kMomentPhotoContainBottomTopicTop =20;

     
     */

    
}

-(void)setLayout:(NewDynamicsLayout *)layout
{

    _layout = layout;
    MomentModel * model = layout.model;
    
    if (layout.momentRequestType == MomentRequestTypeSkill) {
        [self.portrait sd_setImageWithURL:[NSURL URLWithString:model.avatar_url?:@""]];
        self.name.text = model.name?:@"";
        self.address.text = model.address_home?:@"";
        self.time.text = layout.formatedTimeString?:@"";
        self.content.textLayout = layout.contentLayout;
        
    }else {
        
        if (model.is_hidden_name) {
            self.portrait.image = [UIImage imageNamed:@"icon_default_person"];
        }else{
            NSString *avatarUrl = @"";
            
            if ([NSString ins_String:model.customer.avatar_url]) {
                if ([NSString ins_String:model.customer.avatar_url]) {
                    avatarUrl = model.customer.avatar_url;
                    if (![avatarUrl containsString:@"http"]) {
                        avatarUrl = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,avatarUrl];
                    }
                }
                [self.portrait sd_setImageWithURL:[NSURL URLWithString:avatarUrl?:@""]];
            }else{
                self.portrait.image = [UIImage imageNamed:@"icon_default_person"];
            }
        }
        
        NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:model.customer.name?:@""];
        attString.font = [UIFont fontWithName:@"Heiti SC" size:15];
        UIImage *image;
        if (model.customer.gender == 1) {
            image = [UIImage imageNamed:@"ic_male"];
        }else{
            image = [UIImage imageNamed:@"ic_women"];
        }
        if (image) {
            NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(15, 15) alignToFont:[UIFont fontWithName:@"Heiti SC" size:15] alignment:YYTextVerticalAlignmentCenter];
            [attString appendAttributedString:attachText];
        }
        
        UIImage *vipImage;
        if (model.customer.service_vip_expired_at) {
            NSDate *date = [model.customer.service_vip_expired_at sc_dateWithUTCString];
            NSTimeInterval interval = [date timeIntervalSinceNow];
            if (interval > 0) {
                vipImage = [UIImage imageNamed:@"ic_huiyuan"];
            }
        }
        if (vipImage) {
            NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:vipImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(15, 15) alignToFont:[UIFont fontWithName:@"Heiti SC" size:15] alignment:YYTextVerticalAlignmentCenter];
            [attString appendAttributedString:attachText];
        }
        
        self.name.attributedText = attString;
        
        if ([NSString ins_String:model.customer.address_home]) {
            self.address.text = [NSString stringWithFormat:@"%@",model.customer.address_home?:@""];
        }else{
            self.address.text = @"";
        }
        
        
        self.time.text = layout.formatedTimeString?:@"";
        self.content.textLayout = layout.contentLayout;
    }
    
//    [self.address sizeToFit];
    
    self.content.height = layout.contentHeight;
    
    if (layout.momentRequestType == MomentRequestTypeSkill) {
        self.picContainerView.hidden = YES;
        self.zanBtn.hidden = YES;
        self.zanCount.hidden = YES;
        self.commentBtn.hidden = YES;
        self.commentCount.hidden = YES;
        
        return;
    }
    
//    self.content.height = layout.contentHeight;
    
    if (model.images.count != 0) {
        self.picContainerView.itemH = layout.itemHeight;
        self.picContainerView.itemW = layout.itemWidth;
        self.picContainerView.perRowItemCount = layout.perRowItemCount;
        
        self.picContainerView.picsArray = layout.photosUrlsArray;
    }else{
        // 解决图片错乱
        self.picContainerView.picsArray = [NSMutableArray array];
    }
    
    if (model.topic.count > 0) {
        
        self.topics.hidden = NO;
        TopicModel *topicModel = model.topic[0];
        self.topics.text = [NSString stringWithFormat:@"#%@#",topicModel.name];
    }else{
        self.topics.hidden = YES;
    }
    
    self.commentCount.text = [NSString stringWithFormat:@"%ld",model.comment_total];
    self.zanCount.text = [NSString stringWithFormat:@"%ld",model.like_total];
    
    if (model.images.count != 0) {
        self.picContainerView.top = self.content.bottom + kMomentContentBottomPhotoContainTop;
        self.picContainerView.height = layout.photoContainerSize.height;
        
        self.topics.top = self.picContainerView.bottom + kMomentPhotoContainBottomTopicTop;
        self.zanBtn.top = self.picContainerView.bottom + kMomentPhotoContainBottomTopicTop;
    }else{
        self.topics.top = self.content.bottom + kMomentPhotoContainBottomTopicTop;
        self.zanBtn.top = self.content.bottom + kMomentPhotoContainBottomTopicTop;
    }
    self.zanCount.top = self.zanBtn.top;
    self.commentBtn.top = self.zanBtn.top;
    self.commentCount.top = self.zanBtn.top;
    
    if (layout.momentRequestType == MomentRequestTypeMyMomentDetail || layout.momentRequestType == MomentRequestTypeUserMomentDetail){
        if (layout.commentLayoutArr.count != 0 || layout.zanUsers.count != 0) {
            _commentView.hidden = NO;
            //点赞/评论
            _commentView.left = 0;
            _commentView.top = self.commentBtn.bottom + 16;
            _commentView.width = kScreenWidth;
            _commentView.height = layout.commentHeight;
            
            [_commentView CommentArr:layout.commentLayoutArr DynamicsLayout:layout];
        }else{
            _commentView.hidden = YES;
        }
    }
    
    if (layout.model.isZan) {
        [self.zanBtn setImage:[UIImage imageNamed:@"find_dianzhan_selected"] forState:UIControlStateNormal];
    }else{
        [self.zanBtn setImage:[UIImage imageNamed:@"find_dianzhan"] forState:UIControlStateNormal];
    }
    
    
    if (layout.momentRequestType == MomentRequestTypeNewest || layout.momentRequestType == MomentRequestTypeTopicList) {
        self.sectionView.hidden = NO;
        self.sectionView.top = self.zanBtn.bottom+16;// 16：底部间隙
    }else{
        self.sectionView.hidden = YES;
    }
}

#pragma mark - getter

- (UIView *)customBackView{
	if (!_customBackView) {
		_customBackView = [UIView new];
		_customBackView.backgroundColor = [UIColor whiteColor];
		// Shadow
	}
	return _customBackView;
}

- (void)tapUserPortrait:(UITapGestureRecognizer *)tap{
	
//    UIImageView *portrait = (UIImageView *)tap.view;
//    NewDynamicsTableViewCell *cell = (NewDynamicsTableViewCell *)portrait.superview.superview;
//    NSIndexPath *indexPath = cell.indexPath;
	
	// 匿名不让跳转
    if (self.layout.model.is_hidden_name) {
        return;
    }
    
    SCUserInfo *userInfo = _layout.model.customer;
    
    if (_delegate && [self.delegate respondsToSelector:@selector(cell:didClickUser:)]) {
        [self.delegate cell:self didClickUser:userInfo];
    }
	
}

-(UIImageView *)portrait
{
    if(!_portrait){
        _portrait = [UIImageView new];
        _portrait.userInteractionEnabled = YES;
        _portrait.backgroundColor = UIColorHex(DCDCDC);
        _portrait.layer.cornerRadius = 20.0;
        _portrait.layer.masksToBounds = YES;
        _portrait.layer.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tapUser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserPortrait:)];
        [_portrait addGestureRecognizer:tapUser];
    }
    return _portrait;
}

-(YYLabel *)name
{
    if (!_name) {
        _name = [YYLabel new];
		_name.textVerticalAlignment = YYTextVerticalAlignmentTop;
		UIFont *font = [UIFont fontWithName:@"Heiti SC" size:15];
		_name.font = font;
        _name.textColor = Font_color333;
        
    }
    return _name;
}

- (YYLabel *)address{
	if (!_address) {
		_address = [YYLabel new];
//        _address.textAlignment = NSTextAlignmentCenter;
		_address.font = [UIFont fontWithName:@"Heiti SC" size:12];
        _address.textColor = YD_Color666;
//        _address.layer.borderColor = YD_Color666.CGColor;
//        _address.layer.borderWidth = 1.f;
//        _address.layer.cornerRadius = 6.f;
        
	}
	return _address;
}

- (YYLabel *)time{
    if (!_time) {
        _time = [YYLabel new];
        _time.textAlignment = NSTextAlignmentRight;
        _time.font = [UIFont fontWithName:@"Heiti SC" size:12];
        _time.textColor = YD_Color666;
    }
    return _time;
}

- (YYLabel *)content{
    if (!_content) {
        _content = [YYLabel new];
        _content.font = [UIFont fontWithName:@"Heiti SC" size:12];
        _content.textColor = YD_Color666;
        WEAKSELF;
        _content.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            if ([weakSelf.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
                [weakSelf.delegate cell:weakSelf didClickInLabel:(YYLabel *)containerView textRange:range];
            }
        };
    }
    return _content;
}

- (YYLabel *)topics{
    if (!_topics) {
        _topics = [YYLabel new];
        _topics.font = [UIFont fontWithName:@"Heiti SC" size:12];
        _topics.textColor = m1;
        _topics.hidden = YES;
        _topics.userInteractionEnabled = YES;
        WEAKSELF;
        [_topics jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(cellDidClickTopic:cell:)]) {
                [weakSelf.delegate cellDidClickTopic:weakSelf.layout.model.topic[0] cell:weakSelf];
            }
        }];
    }
    return _topics;
}

- (UIButton *)zanBtn{
    if (!_zanBtn) {
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zanBtn setImage:[UIImage imageNamed:@"find_dianzhan"] forState:UIControlStateNormal];
        [_zanBtn addTarget:self action:@selector(zanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zanBtn;
}

- (void)zanBtnClick{
    if (_delegate && [_delegate respondsToSelector:@selector(cellDidClickLike:)]) {
        [_delegate cellDidClickLike:self];
    }
}

- (YYLabel *)zanCount{
    if (!_zanCount) {
        _zanCount = [YYLabel new];
        _zanCount.textAlignment = NSTextAlignmentLeft;
        _zanCount.font = [UIFont fontWithName:@"Heiti SC" size:12];
        _zanCount.textColor = Font_color333;
        WEAKSELF;
        [_zanCount jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weakSelf zanBtnClick];
        }];
    }
    return _zanCount;
}

- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"find_comment"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (void)commentBtnClick{
    if (_delegate && [_delegate respondsToSelector:@selector(cellDidClickComment:)]) {
        [_delegate cellDidClickComment:self];
    }
}

- (YYLabel *)commentCount{
    if (!_commentCount) {
        _commentCount = [YYLabel new];
        _commentCount.textAlignment = NSTextAlignmentLeft;
        _commentCount.font = [UIFont fontWithName:@"Heiti SC" size:12];
        _commentCount.textColor = Font_color333;
        WEAKSELF;
        [_commentCount jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weakSelf commentBtnClick];
        }];
    }
    return _commentCount;
}

- (UIView *)sectionView{
    if (!_sectionView) {
        _sectionView = [UIView new];
        _sectionView.backgroundColor = BackGroundColor;
    }
    return _sectionView;
}


-(SDWeiXinPhotoContainerView *)picContainerView
{
    if (!_picContainerView) {
		_picContainerView = [[SDWeiXinPhotoContainerView alloc]initWithFrame:CGRectZero];
    }
    return _picContainerView;
}


-(NewDynamicsThumbCommentView *)commentView
{
    if (!_commentView) {
        _commentView = [NewDynamicsThumbCommentView new];
        _commentView.cell = self;
    }
    return _commentView;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = touches.anyObject;
	[(_customBackView) performSelector:@selector(setBackgroundColor:) withObject:kGuaCellHightColor afterDelay:0.0];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesRestoreBackgroundColor];
	if ([self.delegate respondsToSelector:@selector(cellDidClick:)]) {
		[self.delegate cellDidClick:self];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesRestoreBackgroundColor];
}

- (void)touchesRestoreBackgroundColor {
	[NSObject cancelPreviousPerformRequestsWithTarget:_customBackView selector:@selector(setBackgroundColor:) object:kGuaCellHightColor];
	_customBackView.backgroundColor = [UIColor whiteColor];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
