//
//  GreetVC.h
//  SocialContact
//
//  Created by EDZ on 2019/3/28.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUserInfo.h"
#import <STPopup/STPopup.h>

NS_ASSUME_NONNULL_BEGIN

@interface GreetVC : UIViewController

@property(nonatomic,strong)NSMutableArray<SCUserInfo *> *dataArray;

@end

NS_ASSUME_NONNULL_END
