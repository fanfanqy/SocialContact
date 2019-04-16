//
//  PointsSkuTableViewCell.h
//  SocialContact
//
//  Created by EDZ on 2019/3/7.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PointsSkuExchange.h"
#import "PointsSkuModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol PointsSkuTableViewCellDelegate <NSObject>

@optional

- (void)exchangeBtnClicked:(NSIndexPath *)indexPath;

@end

@interface PointsSkuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;


INS_P_STRONG(PointsSkuModel *, pointsSkuModel);

INS_P_STRONG(PointsSkuExchange *, pointsSkuExchangeModel);

@property (strong, nonatomic) NSIndexPath *indexPath;

@property(nonatomic,weak)id<PointsSkuTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
