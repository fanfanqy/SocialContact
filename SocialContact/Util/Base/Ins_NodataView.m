//
//  Ins_NodataView.m
//  ChildEnd
//
//  Created by 陈康 on 2017/8/25.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "Ins_NodataView.h"

@interface Ins_NodataView()

/** icon */
@property (strong, nonatomic) UIImageView *icon;
/** 描述信息 */
@property (strong, nonatomic) UILabel *detail;

@end

@implementation Ins_NodataView

+ (instancetype)ins_nodataViewWithIcon:(UIImage *)icon detail:(NSString *)detail {
    Ins_NodataView *view = [[Ins_NodataView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, 200)];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = NO;
    view.icon.image = icon;
    view.detail.text = detail;
    [view addSubview:view.icon];
    [view addSubview:view.detail];
    return view;
}

+ (instancetype)ins_nodataViewWithIcon:(UIImage *)icon detail:(NSString *)detail actionTitle:(NSString *)title action:(NodataAction)noDataAction {
    Ins_NodataView *view = [[Ins_NodataView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, 250)];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;
    view.icon.image = icon;
    view.detail.text = detail;
    [view.action setTitle:title forState:UIControlStateNormal];
    [view addSubview:view.icon];
    [view addSubview:view.detail];
    [view addSubview:view.action];
    view.noDataAction = noDataAction;
    return view;
}


- (UIButton *)action {
    if (!_action) {
        _action = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 180)*0.5, 200, 180, 40)];
        _action.layer.borderWidth = 1;
        _action.layer.borderColor = MAIN_COLOR.CGColor;
        _action.titleLabel.font = [UIFont systemFontOfSize:16];
        _action.layer.cornerRadius = 5;
        _action.layer.masksToBounds = YES;
        [_action setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [_action addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _action;
}

- (void)buttonClick {
    if (self.noDataAction) {
        self.noDataAction();
    }
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 62)*0.5, 30, 62, 62)];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _icon;
}

- (UILabel *)detail {
    if (!_detail) {
        _detail = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, kScreenWidth - 30, 40)];
        _detail.numberOfLines = 2;
        _detail.textColor = Font_color3;
        _detail.font = [UIFont systemFontOfSize:14];
        _detail.textAlignment = NSTextAlignmentCenter;
    }
    return _detail;
}
@end
