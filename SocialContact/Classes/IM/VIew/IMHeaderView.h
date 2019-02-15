//
//  IMHeaderView.h
//  SocialContact
//
//  Created by EDZ on 2019/1/19.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMHeaderViewDelegate <NSObject>

@optional

- (void)nearbyUserCLick;
- (void)driftingBottleCLick;
- (void)loveSkillCLick;
- (void)inviteFriendCLick;

@end

/**
 <#Description#>
 */
@interface IMHeaderView : UIView

@property(nonatomic,assign)id <IMHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
