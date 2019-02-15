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
}

- (void)setUserInfo:(SCUserInfo *)userInfo{
    
    _userInfo = userInfo;
    
    self.nick.text = userInfo.name;
    
    UIImage *genderImage;// 未知
    if (userInfo.gender == 0) {
        genderImage = [UIImage imageNamed:@"ic_women"];
    }else if (userInfo.gender == 1) {
        genderImage = [UIImage imageNamed:@"ic_women"];
    }else if (userInfo.gender == 2) {
        genderImage = [UIImage imageNamed:@"ic_women"];
    }
    self.gender.image = genderImage;
    
    if (userInfo) {
        [self creatUI:userInfo];
    }
    
    if ([NSString ins_String:userInfo.intro]) {
        self.introduce.text = userInfo.intro;
    }else{
        self.introduce.text = @"暂无个人介绍";
    }
    

}

// 标签云
- (void )creatUI:(SCUserInfo *)userInfo{
    
//    150，摩羯座，24，**镇，期望半年结婚，5万及以下，未婚，无子女
    
    NSString *height = [Help height:_userInfo.height];
    NSString *age = [Help age:_userInfo.age];
    
    NSString *address_home = _userInfo.address_home;
    
    NSString *profession = [Help profession:_userInfo.profession];
    NSString *income = [Help income:_userInfo.income];
    
    NSString *marital_status = [Help marital_status:_userInfo.marital_status];
    NSString *child_status = [Help child_status:_userInfo.child_status];
    NSString *years_to_marry = [Help yearsToMarial:_userInfo.years_to_marry];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:height];
    [array addObject:age];
    [array addObject:address_home];
    [array addObject:[NSString stringWithFormat:@"职业：%@",profession]];
    [array addObject:[NSString stringWithFormat:@"收入：%@",income]];
    [array addObject:[NSString stringWithFormat:@"婚姻状态：%@",marital_status]];
    [array addObject:[NSString stringWithFormat:@"子女：%@",child_status]];
    [array addObject:[NSString stringWithFormat:@"结婚：%@",years_to_marry]];
 
    
    UIButton *listButton;
    
    __block float buttonRight;
    
    for (int i = 0; i < array.count; i++) {
        
        NSString *title = array[i];
        
        CGFloat titleW = [self labelAutoCalculateRectWith:title FontSize:14 MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + 20;
        UIButton *button = [UIButton new];
        button.tag = i;
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        [self.tagView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (listButton) {
                //当前按钮右侧坐标
                buttonRight = buttonRight + 15 + titleW;
                if (buttonRight > self.tagView.frame.size.width) {
                    make.top.mas_equalTo(listButton.mas_bottom).offset(10);
                    make.left.mas_equalTo(10);
                    buttonRight = 30 + titleW;
                }else{
                    make.top.mas_equalTo(listButton.mas_top).offset(0);
                    make.left.mas_equalTo(listButton.mas_right).offset(15);
                }
            }else{
                make.top.mas_equalTo(5);
                make.left.mas_equalTo(10);
                buttonRight = 30 + titleW;
            }
            make.size.mas_equalTo(CGSizeMake(titleW, 20));
            
            
        }];
        
        listButton = button;
        
        if (i == array.count - 1) {
            self.tagView.height = button.bottom;
        }
    }
}

- (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize {
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
