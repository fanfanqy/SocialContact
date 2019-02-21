//
//  NewDynamicsTableViewCell.h
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/27.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewDynamicsLayout.h"
#import "SDWeiXinPhotoContainerView.h"
#import "WBStatusHelper.h"

//#import "UIView+XWAddForRoundedCorner.h"

@class NewDynamicsTableViewCell;
@protocol NewDynamicsCellDelegate;



@interface NewDynamicsThumbCommentView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView * bgImgView;
@property(nonatomic,strong)YYLabel * thumbLabel;
@property(nonatomic,strong)UIView * dividingLine;
@property(nonatomic,strong)NSMutableArray * likeArray;
@property(nonatomic,strong)NSMutableArray * commentArray;
@property(nonatomic,strong)NewDynamicsLayout * layout;
@property(nonatomic,strong)UITableView * commentTable;

@property(nonatomic,weak)NewDynamicsTableViewCell * cell;

- (void)CommentArr:(NSMutableArray *)commentArr DynamicsLayout:(NewDynamicsLayout *)layout;

@end

@interface CommentTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView * portrait;// 头像
@property(nonatomic,strong)YYLabel * nameLabel;// 昵称
@property(nonatomic,strong)YYLabel * commentLabel; // 内容
@property(nonatomic,strong)YYLabel * dateLabel;

@property(nonatomic,strong)CommentLayout * layout;

@property(nonatomic,weak)NewDynamicsTableViewCell * cell;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@interface NewDynamicsTableViewCell : UITableViewCell

@property(nonatomic,assign)id<NewDynamicsCellDelegate>delegate;
@property(nonatomic,strong)NewDynamicsLayout * layout;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property(nonatomic,strong)UIView * customBackView;// 头像
@property(nonatomic,strong)UIImageView *portrait;// 头像
@property(nonatomic,strong)YYLabel * name;// 昵称
@property (strong, nonatomic)YYLabel *address;// 位置
@property (strong, nonatomic)YYLabel *time;// 位置
@property(nonatomic,strong)YYLabel * content; // 内容
@property (strong, nonatomic)YYLabel *topics;// 话题
@property(nonatomic,strong)UIButton *zanBtn; // 点赞
@property (strong, nonatomic)YYLabel *zanCount;// 话题
@property(nonatomic,strong)UIButton *commentBtn; // 评论
@property (strong, nonatomic)YYLabel *commentCount;// 话题
@property(nonatomic,strong)SDWeiXinPhotoContainerView *picContainerView; // 图片
@property(nonatomic,strong) UIView *sectionView;// 灰色背景
@property(nonatomic,strong)NewDynamicsThumbCommentView * commentView;


@end

@protocol NewDynamicsCellDelegate <NSObject>

/** @brief 点击了 Cell */
- (void)cellDidClick:(NewDynamicsTableViewCell *)cell;

/** @brief 下拉按钮 */
- (void)cellDidClickMenuBtn:(NewDynamicsTableViewCell *)cell;

/**
 点击了话题链接
 */
- (void)cellDidClickTopic:(TopicModel *)topicModel cell:(NewDynamicsTableViewCell *)cell;

/**
 点击了全文/收回
 */
- (void)cellDidClickMoreLess:(NewDynamicsTableViewCell *)cell;

/**
 点击了评论按钮
 */
- (void)cellDidClickComment:(NewDynamicsTableViewCell *)cell;

/**
 点击了回复内容
 */
- (void)cellDidClickReply:(NewDynamicsTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

/**
 点击了评论用户头像
 */
- (void)cellDidClickCommenterPortait:(NewDynamicsTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

/**
 长按了评论用户头像
 */
- (void)cellDidLongPressCommenterPortait:(NewDynamicsTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

/**
 点击了赞
 */
- (void)cellDidClickLike:(NewDynamicsTableViewCell *)cell;

/**
 点击了用户
 */
- (void)cell:(NewDynamicsTableViewCell *)cell didClickUser:(SCUserInfo *)user;

/**
 点击了图片
 */
- (void)cell:(NewDynamicsTableViewCell *)cell didClickImageAtIndex:(NSUInteger)index;

/**
 点击了 Label 的链接
 */
- (void)cell:(NewDynamicsTableViewCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;

@end


