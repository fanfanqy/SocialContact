//
//  InviteVC.m
//  GuaGua
//
//  Created by fqy on 2018/6/1.
//  Copyright © 2018年 HuangDeng. All rights reserved.
//

#import "InviteVC.h"

@interface InviteVC ()

@property (strong, nonatomic) YYLabel *myInviteLB;//

@property (strong, nonatomic) YYLabel *myInviteNumberLB;//

@property (strong, nonatomic) YYLabel *longPressCopyLB;//

@property (strong, nonatomic) UIButton *fillInviteCodeBtn;//

@property (strong, nonatomic) YYLabel *moreInviteWayLB;

@property (strong, nonatomic) YYLabel *introduceLB;

@property (strong, nonatomic) UIButton *qqInviteBtn;

@property (strong, nonatomic) UIButton *wechatInviteBtn;

@property (strong, nonatomic) UIButton *weiboInviteBtn;

@property (strong, nonatomic) NSString *inviteCode;
@end

@implementation InviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    
}

- (void)configUI{
	self.title = @"邀请好友";
	
	[self.view addSubview:self.myInviteLB];
	[self.view addSubview:self.myInviteNumberLB];
	[self.view addSubview:self.longPressCopyLB];
//    [self.view addSubview:self.fillInviteCodeBtn];
	
    [self.view addSubview:self.moreInviteWayLB];
    [self.view addSubview:self.qqInviteBtn];
    [self.view addSubview:self.wechatInviteBtn];
    [self.view addSubview:self.weiboInviteBtn];
    [self.view addSubview:self.introduceLB];
	
}

- (void)copyToPasteboard{
	
}

- (void)weiboInviteBtnClick{

	WEAKSELF
	[self.view makeToast:@"已复制到粘贴板" duration:1 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
		NSURL *weiboUrl = [NSURL URLWithString:@"sinaweibo://"];
		BOOL weibo = [[UIApplication sharedApplication]canOpenURL:weiboUrl];
		if (weibo) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication]openURL:weiboUrl options:nil completionHandler:^(BOOL success) {
                    if (success) {
                        NSLog(@"成功打开weibo");
                    }
                }];
            } else {
                // Fallback on earlier versions
            }
		}else{
			[weakSelf.view makeToast:@"请先安装新浪微博" duration:1 position:CSToastPositionCenter];
		}
	}];
	
	
}

- (void)wechatInviteBtnClick{
	
	WEAKSELF
	[self.view makeToast:@"已复制到粘贴板" duration:1 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
		
		NSURL *wechatUrl = [NSURL URLWithString:@"weixin://"];
		BOOL wechat = [[UIApplication sharedApplication]canOpenURL:wechatUrl];
		if (wechat) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication]openURL:wechatUrl options:nil completionHandler:^(BOOL success) {
                    if (success) {
                        NSLog(@"成功打开wechat");
                    }
                }];
            } else {
                // Fallback on earlier versions
            }
		}else{
			[weakSelf.view makeToast:@"请先安装微信" duration:1 position:CSToastPositionCenter];
		}
		
	}];
	
	
}

- (void)qqInviteBtnClick{
	
	WEAKSELF
	[self.view makeToast:@"已复制到粘贴板" duration:1 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
		
		NSURL *qqUrl = [NSURL URLWithString:@"mqq://"];
		BOOL qq = [[UIApplication sharedApplication]canOpenURL:qqUrl];
		if (qq) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication]openURL:qqUrl options:nil completionHandler:^(BOOL success) {
                    if (success) {
                        NSLog(@"成功打开QQ");
                    }
                }];
            } else {
                // Fallback on earlier versions
            }
		}else{
			[weakSelf.view makeToast:@"请先安装QQ" duration:1 position:CSToastPositionCenter];
		}
		
	}];
	
	
	
}


- (void)openShare{
	NSString *textToShare = self.model.invitecode;
	NSURL *urlToShare = [NSURL URLWithString:@""];
	NSArray *activityItems = @[textToShare,urlToShare];
	
	UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
	avc.excludedActivityTypes = @[];//关闭系统的一些activity类型
	[self presentViewController:avc animated:YES completion:nil];
	
	UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
		NSLog(@"activityType :%@", activityType);
		if (completed)
			{
			NSLog(@"completed");
			}
		else
			{
			NSLog(@"cancel");
			}
	};
	avc.completionWithItemsHandler = myBlock;
}

- (void)myInviteNumberLongPress{
	WEAKSELF
	
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = self.model.invitecode;
	
	[self.view makeToast:@"已复制" duration:1 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
		[weakSelf openShare];
	}];
	
}

- (UIButton *)weiboInviteBtn{
	if (!_weiboInviteBtn) {
		_weiboInviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_weiboInviteBtn.top = 244+GuaTopHeight;
		_weiboInviteBtn.height = 32;
		_weiboInviteBtn.width = 32;
		_weiboInviteBtn.centerX = self.view.centerX+36+32;
		[_weiboInviteBtn setImage:[UIImage imageNamed:@"icon_weibo"] forState:UIControlStateNormal];
		[_weiboInviteBtn addTarget:self action:@selector(weiboInviteBtnClick) forControlEvents:UIControlEventTouchUpInside];
	}
	return _weiboInviteBtn;
}

- (UIButton *)wechatInviteBtn{
	if (!_wechatInviteBtn) {
		_wechatInviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_wechatInviteBtn.top = 244+GuaTopHeight;
		_wechatInviteBtn.height = 32;
		_wechatInviteBtn.width = 32;
		_wechatInviteBtn.centerX = self.view.centerX;
		[_wechatInviteBtn setImage:[UIImage imageNamed:@"icon_weixin"] forState:UIControlStateNormal];
		[_wechatInviteBtn addTarget:self action:@selector(wechatInviteBtnClick) forControlEvents:UIControlEventTouchUpInside];
	}
	return _wechatInviteBtn;
}

- (UIButton *)qqInviteBtn{
	if (!_qqInviteBtn) {
		_qqInviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_qqInviteBtn.top = 244+GuaTopHeight;
		_qqInviteBtn.height = 32;
		_qqInviteBtn.width = 32;
		_qqInviteBtn.centerX = self.view.centerX-36-32;
		[_qqInviteBtn setImage:[UIImage imageNamed:@"icon_qq"] forState:UIControlStateNormal];
		[_qqInviteBtn addTarget:self action:@selector(qqInviteBtnClick) forControlEvents:UIControlEventTouchUpInside];
	}
	return _qqInviteBtn;
}

- (YYLabel *)introduceLB{
	if (!_introduceLB) {
		_introduceLB = [YYLabel new];
		_introduceLB.numberOfLines = 0;
		_introduceLB.top = 320+GuaTopHeight;
		_introduceLB.height = 200;
		_introduceLB.width = 300;
		_introduceLB.centerX = self.view.centerX;
		_introduceLB.font = [UIFont systemFontOfSize:15];
		_introduceLB.text = @"快喊上你的小伙伴们来加入Linkinss吧，你和你的好友都会获得花花哟~\n\n邀请规则：\n1. 每位用户均有独一无二的邀请码，邀请好友填写你的邀请码，双方都可获得50花花；\n2. 每位用户仅可填写一次邀请码，但是一个人的邀请码可以被很多人填写。";
		_introduceLB.textColor = UIColorHex(999999);
		_introduceLB.textAlignment = NSTextAlignmentLeft;
		_introduceLB.textVerticalAlignment = YYTextVerticalAlignmentTop;
	}
	return _introduceLB;
}


- (YYLabel *)moreInviteWayLB{
	if (!_moreInviteWayLB) {
		_moreInviteWayLB = [YYLabel new];
		_moreInviteWayLB.top = 208+GuaTopHeight;
		_moreInviteWayLB.height = 20;
		_moreInviteWayLB.width = 100;
		_moreInviteWayLB.centerX = self.view.centerX;
		_moreInviteWayLB.font = [UIFont systemFontOfSize:14];
		_moreInviteWayLB.text = @"更多邀请方式";
		_moreInviteWayLB.textColor = UIColorHex(D3D3D3);
		_moreInviteWayLB.textAlignment = NSTextAlignmentCenter;
	}
	return _moreInviteWayLB;
}

- (UIButton *)fillInviteCodeBtn{
	if (!_fillInviteCodeBtn) {
		_fillInviteCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_fillInviteCodeBtn.top = 148+GuaTopHeight;
		_fillInviteCodeBtn.height = 28;
		_fillInviteCodeBtn.width = 100;
		_fillInviteCodeBtn.centerX = self.view.centerX;
		_fillInviteCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
		[_fillInviteCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal|UIControlStateDisabled];
		[_fillInviteCodeBtn setTitleColor:UIColorHex(61CD95) forState:UIControlStateHighlighted];
		[_fillInviteCodeBtn setTitle:@"填写邀请码" forState:UIControlStateNormal];
		[_fillInviteCodeBtn setTitle:@"已填写" forState:UIControlStateDisabled];
		[_fillInviteCodeBtn setBackgroundImage:[UIImage imageWithColor:UIColorHex(61CD95)] forState:UIControlStateNormal];
		[_fillInviteCodeBtn setBackgroundImage:[UIImage imageWithColor:kGuaCellHightColor] forState:UIControlStateHighlighted];
		[_fillInviteCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
		_fillInviteCodeBtn.layer.cornerRadius = 14;
		_fillInviteCodeBtn.layer.masksToBounds = YES;
		[_fillInviteCodeBtn addTarget:self action:@selector(fillInviteCode) forControlEvents:UIControlEventTouchUpInside];
	}
	return _fillInviteCodeBtn;
}

- (YYLabel *)longPressCopyLB{
	if (!_longPressCopyLB) {
		_longPressCopyLB = [YYLabel new];
		_longPressCopyLB.top = 102+GuaTopHeight;
		_longPressCopyLB.height = 16;
		_longPressCopyLB.width = 63;
		_longPressCopyLB.centerX = self.view.centerX;
		_longPressCopyLB.font = [UIFont systemFontOfSize:12];
		_longPressCopyLB.text = @"长按可复制";
		_longPressCopyLB.textColor = UIColorHex(4a4a4a);
		_longPressCopyLB.textAlignment = NSTextAlignmentCenter;
	}
	return _longPressCopyLB;
}

- (YYLabel *)myInviteNumberLB{
	if (!_myInviteNumberLB) {
		_myInviteNumberLB = [YYLabel new];
		_myInviteNumberLB.top = 48+GuaTopHeight;
		_myInviteNumberLB.height = 53;
		_myInviteNumberLB.width = self.view.width-50;
		_myInviteNumberLB.centerX = self.view.centerX;
		_myInviteNumberLB.font = [UIFont systemFontOfSize:12];
		_myInviteNumberLB.textColor = UIColorHex(4a4a4a);
		_myInviteNumberLB.textVerticalAlignment = YYTextVerticalAlignmentCenter;
		_myInviteNumberLB.textAlignment = NSTextAlignmentCenter;
		
		if (![NSString ins_String:self.model.invitecode]) {
			self.model.invitecode = @"";
		}
		NSMutableAttributedString *strMutable = [[NSMutableAttributedString alloc]initWithString:self.model.invitecode];
		strMutable.font = [UIFont systemFontOfSize:12];
		strMutable.alignment = NSTextAlignmentCenter;
		strMutable.color    = UIColorHex(4a4a4a);
		YYTextHighlight *highlight = [YYTextHighlight new];
		[highlight setColor:kGuaCellHightColor];
        WEAKSELF;
		highlight.longPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
			[weakSelf myInviteNumberLongPress];
		};
		[strMutable setTextHighlight:highlight range:strMutable.rangeOfAll];
		_myInviteNumberLB.attributedText = strMutable;
	}
	return _myInviteNumberLB;
}

- (YYLabel *)myInviteLB{
	if (!_myInviteLB) {
		_myInviteLB = [YYLabel new];
		
		_myInviteLB.top = 20+GuaTopHeight;
		_myInviteLB.width = 100;
		_myInviteLB.height = 24;
		_myInviteLB.centerX = self.view.centerX;
		_myInviteLB.font = [UIFont systemFontOfSize:20];
		_myInviteLB.text = @"我的邀请码";
		_myInviteLB.textColor = UIColorHex(4a4a4a);
		_myInviteLB.textAlignment = NSTextAlignmentCenter;
	}
	return _myInviteLB;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
