//
//  SayHiCell.h
//  SocialContact
//
//  Created by EDZ on 2019/3/28.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface SayHiCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

INS_P_STRONG(SCUserInfo *, userModel);

@end

NS_ASSUME_NONNULL_END
