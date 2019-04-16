//
//  MeV2TableViewCell.h
//  SocialContact
//
//  Created by EDZ on 2019/3/4.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MeV2TableViewCellDelegate <NSObject>

@optional

- (void)gerenziliaoClicked;

- (void)zeoubiaozhunClicked;

- (void)woyaorenzhenged;

- (void)shuikanguowoClicked;

- (void)fenxiangRuanjianClicked;

- (void)dangqianJifenClicked;

- (void)shoudaoWeixinClicked;

- (void)openVipBtnClicked;

- (void)yueClicked;

@end
@interface MeV2TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lookMeUnreadCount;

@property (weak, nonatomic) IBOutlet UILabel *askWeChatUnreadCountLB;
@property (weak, nonatomic) IBOutlet UILabel *ziliaoT;

@property (weak, nonatomic) IBOutlet UILabel *zeouT;
@property (weak, nonatomic) IBOutlet UILabel *renzhengT;
@property (weak, nonatomic) IBOutlet UILabel *jifenT;
@property (weak, nonatomic) IBOutlet UILabel *fenxiangT;
@property (weak, nonatomic) IBOutlet UILabel *lookMeT;
@property (weak, nonatomic) IBOutlet UILabel *receiveWechatT;
@property (weak, nonatomic) IBOutlet UILabel *openVipT;
@property (weak, nonatomic) IBOutlet UILabel *yueT;

@property(nonatomic,weak) id <MeV2TableViewCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
