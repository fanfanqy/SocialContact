//
//  JiFenCell.m
//  SocialContact
//
//  Created by EDZ on 2019/2/17.
//  Copyright © 2019 ha. All rights reserved.
//

#import "JiFenCell.h"

@implementation JiFenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatar.layer.cornerRadius = 45.f;
    self.avatar.layer.masksToBounds = YES;
    
    self.name.font = [[UIFont systemFontOfSize:20]fontWithBold];
    self.jifen.font =  [[UIFont systemFontOfSize:20]fontWithBold];
    
    if (![SCUserCenter sharedCenter].currentUser.userInfo.isOnlineSwitch) {
        
        self.dangqianjifenT.text = @"当前记录";
        
    }else{
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
