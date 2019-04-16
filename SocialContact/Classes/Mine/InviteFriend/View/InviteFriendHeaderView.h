//
//  InviteFriendHeaderView.h
//  SocialContact
//
//  Created by EDZ on 2019/2/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

/**
 <#Description#>
 */
@interface InviteFriendHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (weak, nonatomic) IBOutlet UILabel *totalInviteCount;
@property (weak, nonatomic) IBOutlet UILabel *totalPayCount;
@property (weak, nonatomic) IBOutlet UILabel *notArrivedAmout;
@property (weak, nonatomic) IBOutlet UILabel *arrivedAmount;

INS_P_STRONG(InviteInfoModel *, inviteInfoModel);

@end

NS_ASSUME_NONNULL_END
