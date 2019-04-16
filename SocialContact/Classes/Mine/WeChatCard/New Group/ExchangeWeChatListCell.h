//
//  ExchangeWeChatListCell.h
//  SocialContact
//
//  Created by EDZ on 2019/2/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ExchangeWeChatListCellDelegate <NSObject>

@optional

- (void)refuseBtnClicked:(NSIndexPath *)indexPath type:(NSInteger)type;

- (void)agreeBtnClicked:(NSIndexPath *)indexPath type:(NSInteger)type;

@end

@interface ExchangeWeChatListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UILabel *shifouTongYi;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateL;

@property (strong, nonatomic) ApplyModel *model;

@property (strong, nonatomic) NSIndexPath *indexPath;

/*
 0:我发出的微信请求
 1:我收到的微信请求
 2:我发出的线上线下约
 3:我收到的线上线下约
 */
@property (assign, nonatomic) NSInteger type;

@property (weak, nonatomic) id <ExchangeWeChatListCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
