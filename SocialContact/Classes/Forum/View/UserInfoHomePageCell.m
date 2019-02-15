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
    
    self.introduce.text = userInfo.intro;
    
    
}

// 标签云
- (void )creatUI{
    NSArray *array = @[@"测试",@"测试测试测试测试测试",@"测试",@"测试测试测试测试测试测试",@"测试",@"测试测试",@"测试测试测试",@"测试测试测试测试",@"测试"];
    
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
                    make.top.mas_equalTo(listButton.mas_bottom).offset(15);
                    make.left.mas_equalTo(10);
                    buttonRight = 30 + titleW;
                }else{
                    make.top.mas_equalTo(listButton.mas_top).offset(0);
                    make.left.mas_equalTo(listButton.mas_right).offset(15);
                }
            }else{
                make.top.mas_equalTo(25);
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
