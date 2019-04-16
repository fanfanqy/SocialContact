//
//  PointsSkuExchangeTableViewCell.h
//  SocialContact
//
//  Created by EDZ on 2019/3/7.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointsSkuExchange.h"

NS_ASSUME_NONNULL_BEGIN

@interface PointsSkuExchangeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *des;

@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UILabel *create_at;

INS_P_STRONG(PointsSkuExchange *, pointsSkuExchangeModel);
@end

NS_ASSUME_NONNULL_END
