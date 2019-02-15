//
//  TopicListsHeaderView.m
//  SocialContact
//
//  Created by EDZ on 2019/1/20.
//  Copyright © 2019 ha. All rights reserved.
//

#import "TopicListsHeaderView.h"

@interface TopicListsHeaderView ()

@end

@implementation TopicListsHeaderView

- (void)setTopicModel:(TopicModel *)topicModel{
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:topicModel.logo_url?:@""]];
    
    self.title.text = topicModel.name;
    
    self.des.text = topicModel.desc;
}

@end
