//
//  LoverConditionVC.h
//  SocialContact
//
//  Created by EDZ on 2019/1/19.
//  Copyright © 2019 ha. All rights reserved.
//

#import "Ins_ViewController.h"

@protocol LoverConditionVCDelegate <NSObject>

@optional

- (void)selectCondition:(NSDictionary *)conditionDic;

@end
NS_ASSUME_NONNULL_BEGIN

/**
 择偶标准
 */
@interface LoverConditionVC : InsViewController

INS_P_STRONG(SCUserInfo *, userModel);

@property(nonatomic,weak) id<LoverConditionVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
