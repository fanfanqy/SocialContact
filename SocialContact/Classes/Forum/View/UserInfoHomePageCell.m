//
//  UserInfoHomePageCell.m
//  SocialContact
//
//  Created by EDZ on 2019/2/13.
//  Copyright © 2019 ha. All rights reserved.
//

#import "UserInfoHomePageCell.h"

@implementation UserInfoHomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.nick.font = [[UIFont systemFontOf size:20]fontWithBold];
    self.selfIntroduce.font = [UIFont systemFontOfSize:15];
    
//    self.introduce.font = [UIFont systemFontOf size:15];
}

- (void)setUserInfo:(SCUserInfo *)userInfo{
    
    _userInfo = userInfo;

    if (userInfo) {
        [self creatUI:userInfo];
    }
    
    if ([NSString ins_String:userInfo.intro]) {
        
        NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc]initWithString:@"自我介绍："];
        att1.color = Font_color333;
        att1.font = [[UIFont systemFontOfSize:16]fontWithBold];
        
        NSMutableAttributedString *att2 = [[NSMutableAttributedString alloc]initWithString:self.userInfo.intro];
        att2.color =[UIColor colorWithHexString:@"666666"];
        att2.font = [UIFont systemFontOfSize:15];
        
        [att1 appendAttributedString:att2];
        
        self.selfIntroduce.attributedText = att1;
    }else{
        self.selfIntroduce.text = @"暂无个人介绍";
    }

}


+ (CGFloat)calculateTagHeight:(SCUserInfo *)userInfo{
    //    150，摩羯座，24，**镇，期望半年结婚，5万及以下，未婚，无子女
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    NSString *height = [Help height:userInfo.height];
    NSString *age = [Help age:userInfo.age];
    
    NSString *address_home = userInfo.address_home;
    
    NSString *profession = [Help profession:userInfo.profession];
    NSString *income = [Help income:userInfo.income];
    
    NSString *marital_status = [Help marital_status:userInfo.marital_status];
    NSString *child_status = [Help child_status:userInfo.child_status];
    NSString *years_to_marry = [Help yearsToMarial:userInfo.years_to_marry];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"身高：%@",height]];
    [array addObject:[NSString stringWithFormat:@"年龄：%@",age]];
    [array addObject:[NSString stringWithFormat:@"家乡：%@",address_home]];
    [array addObject:[NSString stringWithFormat:@"职业：%@",profession]];
    [array addObject:[NSString stringWithFormat:@"收入：%@",income]];
    [array addObject:[NSString stringWithFormat:@"婚姻：%@",marital_status]];
    [array addObject:[NSString stringWithFormat:@"子女：%@",child_status]];
    [array addObject:[NSString stringWithFormat:@"几年结婚：%@",years_to_marry]];
    
    UIButton *listButton;
    
    __block float buttonRight;
    
    for (int i = 0; i < array.count; i++) {
        
        NSString *title = array[i];
        
        CGFloat titleW = [UserInfoHomePageCell labelAutoCalculateRectWith:title FontSize:14 MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + 24;
        UIButton *button = [UIButton new];
        button.tag = i;
        
        button.backgroundColor = [UIColor colorWithHexString:@"ededed"];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:Black forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        //        button.layer.cornerRadius = 14;
        button.layer.masksToBounds = YES;
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (listButton) {
                //当前按钮右侧坐标
                buttonRight = buttonRight + 15 + titleW;
                if (buttonRight > view.frame.size.width) {
                    make.top.mas_equalTo(listButton.mas_bottom).offset(10);
                    make.left.mas_equalTo(0);
                    buttonRight = 30 + titleW;
                }else{
                    make.top.mas_equalTo(listButton.mas_top).offset(0);
                    make.left.mas_equalTo(listButton.mas_right).offset(12);
                }
            }else{
                make.top.mas_equalTo(5);
                make.left.mas_equalTo(0);
                buttonRight = 30 + titleW;
            }
            make.size.mas_equalTo(CGSizeMake(titleW, 23));
            
            
        }];
        
        listButton = button;
        
        if (i == array.count - 1) {
            
            return button.bottom;
            
        }
    }
    
    return 0;
    
}
// 标签云
- (void )creatUI:(SCUserInfo *)userInfo{
    
//    150，摩羯座，24，**镇，期望半年结婚，5万及以下，未婚，无子女
    
    NSString *height = [Help height:_userInfo.height];
    NSString *age = [Help age:_userInfo.age];
    
    NSString *address_home = _userInfo.address_home;
    
    NSString *profession = [Help profession:_userInfo.profession];
    NSString *income = [Help income:_userInfo.income];
    
    NSString *education = [Help education:_userInfo.education];
    NSString *marital_status = [Help marital_status:_userInfo.marital_status];
    NSString *child_status = [Help child_status:_userInfo.child_status];
    NSString *years_to_marry = [Help yearsToMarial:_userInfo.years_to_marry];
    NSString *car = [Help car:_userInfo.car_status];
    NSString *house = [Help house:_userInfo.house_status];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"%@",height]];
    [array addObject:[NSString stringWithFormat:@"%@",age]];
    [array addObject:[NSString stringWithFormat:@"%@",address_home]];
    [array addObject:[NSString stringWithFormat:@"%@",education]];
    [array addObject:[NSString stringWithFormat:@"%@",profession]];
    [array addObject:[NSString stringWithFormat:@"月收入：%@",income]];
    
    // 房产、车辆属于保密了
    if (_userInfo.house_status != 0) {
        [array addObject:[NSString stringWithFormat:@"%@",house]];
    }
    if (_userInfo.car_status != 0) {
        [array addObject:[NSString stringWithFormat:@"%@",car]];
    }
    [array addObject:[NSString stringWithFormat:@"%@",marital_status]];
    [array addObject:[NSString stringWithFormat:@"%@",child_status]];
    [array addObject:[NSString stringWithFormat:@"%@",years_to_marry]];
    
    UIButton *listButton;
    
    __block float buttonRight;
    
    for (int i = 0; i < array.count; i++) {
        
        NSString *title = array[i];
        
        CGFloat titleW = [UserInfoHomePageCell labelAutoCalculateRectWith:title FontSize:14 MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + 24;
        UIButton *button = [UIButton new];
        button.tag = i;
        
        button.backgroundColor = [UIColor colorWithHexString:@"ededed"];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:Black forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
//        button.layer.cornerRadius = 14;
        button.layer.masksToBounds = YES;
        [self.tagView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (listButton) {
                //当前按钮右侧坐标
                buttonRight = buttonRight + 15 + titleW;
                if (buttonRight > self.tagView.frame.size.width) {
                    make.top.mas_equalTo(listButton.mas_bottom).offset(10);
                    make.left.mas_equalTo(0);
                    buttonRight = 30 + titleW;
                }else{
                    make.top.mas_equalTo(listButton.mas_top).offset(0);
                    make.left.mas_equalTo(listButton.mas_right).offset(15);
                }
            }else{
                make.top.mas_equalTo(5);
                make.left.mas_equalTo(0);
                buttonRight = 30 + titleW;
            }
            make.size.mas_equalTo(CGSizeMake(titleW, 26));
            
            
        }];
        
        listButton = button;
        
        if (i == array.count - 1) {
            self.tagView.height = button.bottom;
            self.tagHeight = self.tagView.height;
        }
    }
}

+ (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

- (void )btnClicked:(UIButton *)btn{
    NSLog(@"%zd",btn.tag);
}


@end
