//
//  BottleCell.m
//  SocialContact
//
//  Created by EDZ on 2019/2/26.
//  Copyright © 2019 ha. All rights reserved.
//

#import "BottleCell.h"

@implementation BottleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img.layer.cornerRadius = 30.f;
    self.img.layer.masksToBounds = YES;
}

- (void)setModel:(BottleModel *)model{
    
    _model = model;
    
    if (model) {
        
        if (model.customer) {
            [self.img sc_setImgWithUrl:_model.customer.avatar_url placeholderImg:@"icon_default_person"];
        }else{
            // 自己的
            [self.img sc_setImgWithUrl:[SCUserCenter sharedCenter].currentUser.userInfo.avatar_url placeholderImg:@"icon_default_person"];
        }
        self.nick.text = _model.customer.name;
        self.text.text = _model.text;
//        NSDate *date = [NSDate dateWithISOFormatString:_model.create_at];
//        self.time.text = [WBStatusHelper stringWithTimelineDate:date];
        
        self.time.text =  [_model.create_at sc_timeAgoWithUTCString];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
