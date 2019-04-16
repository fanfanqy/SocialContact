//
//  ArticleOrAdCell.h
//  SocialContact
//
//  Created by EDZ on 2019/2/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleOrAdModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ArticleOrAdCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (nonatomic, strong) ArticleOrAdModel *model;

@end

NS_ASSUME_NONNULL_END
