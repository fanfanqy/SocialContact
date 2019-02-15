//
//  DCIMGroupCell.h
//  ChildEnd
//
//  Created by dylan on 2017/3/1.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DCIMGroup.h"

@interface DCIMGroupCell : UITableViewCell

@property ( nonatomic, strong ) UIImageView *photoView;
@property ( nonatomic, strong ) UILabel *nickName;

- (void) setUser: (DCIMGroup *) group;

@end
