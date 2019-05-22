//
//  MeListTableViewCell.h
//  ChildEnd
//
//  Created by EDZ on 2018/12/12.
//  Copyright © 2018 readyidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLBLeading;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLB;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;

@end

NS_ASSUME_NONNULL_END
