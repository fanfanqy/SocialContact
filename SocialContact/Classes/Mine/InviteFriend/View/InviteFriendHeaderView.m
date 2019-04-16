//
//  InviteFriendHeaderView.m
//  SocialContact
//
//  Created by EDZ on 2019/2/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "InviteFriendHeaderView.h"

@interface InviteFriendHeaderView ()

@end

@implementation InviteFriendHeaderView

- (void)setInviteInfoModel:(InviteInfoModel *)inviteInfoModel{
    
    
    _inviteInfoModel = inviteInfoModel;
    
//    UILabel *totalAmount;
//    UILabel *totalInviteCount;
//    UILabel *totalPayCount;
//    UILabel *notArrivedAmout;
//    UILabel *arrivedAmount;
//
//    invited_count    int    邀请人数
//    customer_buy_count    int    邀请人购买服务的人数
//    total_available    int    可用金额
//    total_handing    int    正在处理的提现数量
//    total_changed    int    已兑换
    
    self.totalAmount.text = [NSString stringWithFormat:@"¥%.1lf",inviteInfoModel.total_available];
    self.totalInviteCount.text = [NSString stringWithFormat:@"%ld人",inviteInfoModel.invited_count];
    self.totalPayCount.text = [NSString stringWithFormat:@"%ld人",inviteInfoModel.customer_buy_count];
    self.notArrivedAmout.text = [NSString stringWithFormat:@"¥%.1lf",inviteInfoModel.total_handing];
    self.arrivedAmount.text = [NSString stringWithFormat:@"¥%.1lf",inviteInfoModel.total_changed];
}

@end
