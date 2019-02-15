//
//  CommonWebViewController.m
//  ChildEnd
//
//  Created by liekkas on 2017/11/15.
//  Copyright © 2017年 readyidu. All rights reserved.
//

#import "CommonWebViewController.h"
#import <WebKit/WebKit.h>

@interface CommonWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic ,strong) WKWebView *webView;
@property (nonatomic ,strong) UILabel *titleLab;

@end

@implementation CommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI{
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth  * 0.5, 40)];
    titleLab.font = [UIFont systemFontOfSize:18 ];
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLab;
    self.titleLab = titleLab;
    
    // 返回按钮
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // 创建WKWebView
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    // 设置访问的URL
    NSURL *url = [NSURL URLWithString:self.url];
    // 根据URL创建请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    // WKWebView加载请求
    [self.webView loadRequest:req];
    // 将WKWebView添加到视图
    [self.view addSubview:self.webView];
}

//// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [SVProgressHUD showWithStatus:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.titleLab.text = webView.title;
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"网络错误!"];
}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
//{
//    if(webView != self.webView) {
//        decisionHandler(WKNavigationActionPolicyAllow);
//        return;
//    }
//    
//    UIApplication *app = [UIApplication sharedApplication];
//    NSURL         *url = navigationAction.request.URL;
//    
//    if (!navigationAction.targetFrame) {
//        if ([app canOpenURL:url]) {
//            [app openURL:url];
//            decisionHandler(WKNavigationActionPolicyCancel);
//            return;
//        }
//    }
//    if ([url.scheme isEqualToString:@"tel"])
//    {
//        if ([app canOpenURL:url])
//        {
//            [app openURL:url];
//            decisionHandler(WKNavigationActionPolicyCancel);
//            return;
//        }
//    }
//    decisionHandler(WKNavigationActionPolicyAllow);
//}


- (void)backBtnAction{
    if ([self.webView canGoBack] == YES) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
