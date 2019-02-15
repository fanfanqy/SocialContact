//
//  TopicListsHeaderView.h
//  SocialContact
//
//  Created by EDZ on 2019/1/20.
//  Copyright © 2019 ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"
NS_ASSUME_NONNULL_BEGIN

/**
 <#Description#>
 */
@interface TopicListsHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *des;

@property(nonatomic,strong)TopicModel *topicModel;

@end

NS_ASSUME_NONNULL_END
