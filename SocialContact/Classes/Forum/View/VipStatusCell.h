//
//  VipStatusCell.h
//  SocialContact
//
//  Created by EDZ on 2019/1/19.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VipStatusCellDelegate <NSObject>

@optional

- (void)vipClicked;

- (void)exchangeWechatClicked;

- (void)yueTaClicked;

@end

@interface VipStatusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *vip;
@property (weak, nonatomic) IBOutlet UIButton *exchangeWechat;
@property (weak, nonatomic) IBOutlet UIButton *yueTa;



@property (nonatomic,weak) id<VipStatusCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
