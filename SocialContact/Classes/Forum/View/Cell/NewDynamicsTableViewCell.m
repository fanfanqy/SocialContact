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
    _portrait.top = 0;
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

        [_portrait sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",layout.model.from_customer.avatar_url]] placeholderImage:placeHoldImage options:SDWebImageRefreshCached];
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
		UIFont *font = [UIFont systemFontOfSize:14];
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
        _commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    self.portrait.left = kMomentContentInsetLeft;
    self.portrait.top = kMomentContentInsetTop;
    self.portrait.width = kMomentPortraitWH;
    self.portrait.height = kMomentPortraitWH;
    
    self.time.top = kMomentContentInsetTop+kMomentPortraitWH/2.0;
    self.time.left = kScreenWidth-kMomentContentInsetRight-60;
    self.time.width = 60;
    self.time.height = kMomentPortraitWH/2.0;
    
    self.name.top = kMomentContentInsetTop;
    self.name.left = kMomentContentInsetLeft + kMomentPortraitWH + kMomentAvatarRightNickLeft;
    self.name.width = kScreenWidth-kMomentContentInsetRight-kMomentPortraitWH - kMomentAvatarRightNickLeft;
    self.name.height = kMomentPortraitWH/2.0;
    
    self.address.top = self.name.bottom;
    self.address.left = self.name.left;
    self.address.width = kScreenWidth-kMomentContentInsetRight-40 - (100 + kMomentContentInsetRight);
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
        [self.portrait sd_setImageWithURL:[NSURL URLWithString:model.customer.avatar_url?:@""]];
        self.name.text = model.customer.name?:@"";
        self.address.text = model.customer.address_home?:@"";
        self.time.text = layout.formatedTimeString?:@"";
        self.content.textLayout = layout.contentLayout;
    }
    
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
        self.topics.text = topicModel.name;
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
        if (layout.commentLayoutArr.count != 0) {
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
		UIFont *font = [UIFont systemFontOfSize:16];
		_name.font = font;
		_name.textColor = UIColorHex(0D0E15);
    }
    return _name;
}

- (YYLabel *)address{
	if (!_address) {
		_address = [YYLabel new];
		_address.textVerticalAlignment = YYTextVerticalAlignmentBottom;
		_address.font = [UIFont systemFontOfSize:12];
		_address.textColor = UIColorHex(D3D3D3);
	}
	return _address;
}

- (YYLabel *)time{
    if (!_time) {
        _time = [YYLabel new];
        _time.textAlignment = NSTextAlignmentRight;
        _time.font = [UIFont systemFontOfSize:12];
        _time.textColor = UIColorHex(D3D3D3);
    }
    return _time;
}

- (YYLabel *)content{
    if (!_content) {
        _content = [YYLabel new];
        _content.font = [UIFont systemFontOfSize:12];
        _content.textColor = UIColorHex(D3D3D3);
    }
    return _content;
}

- (YYLabel *)topics{
    if (!_topics) {
        _topics = [YYLabel new];
        _topics.font = [UIFont systemFontOfSize:12];
        _topics.textColor = UIColorHex(D3D3D3);
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
        _zanCount.font = [UIFont systemFontOfSize:12];
        _zanCount.textColor = UIColorHex(D3D3D3);
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
        _commentCount.font = [UIFont systemFontOfSize:12];
        _commentCount.textColor = UIColorHex(D3D3D3);
        WEAKSELF;
        [_commentCount jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weakSelf commentBtnClick];
        }];
    }
    return _commentCount;
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
