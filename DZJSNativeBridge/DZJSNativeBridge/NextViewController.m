//
//  NextViewController.m
//  DZJSNativeBridge
//
//  Created by song_dzhong on 16/3/6.
//  Copyright © 2016年 song_dzhong. All rights reserved.
//

#import "NextViewController.h"
#import <WebKit/WebKit.h>

@interface NextViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, weak) WKWebView* webView;

@end

@implementation NextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 创建并配置 WKWebView 的相关参数
    WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
    // 创建 配置信息的偏好
    WKPreferences* preferences = [[WKPreferences alloc] init];
    preferences.minimumFontSize = 10;
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preferences;

    WKUserContentController* userContent = [[WKUserContentController alloc] init];
    [userContent addScriptMessageHandler:self name:@"test"];
    config.userContentController = userContent;

    WKWebView* webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSString* path = [[NSBundle mainBundle] pathForResource:@"TestJSBridge__tradition_WK.html" ofType:nil];
    NSString* HTMLStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:HTMLStr baseURL:nil];
}

- (void)dealloc
{
    NSLog(@"=====已销毁");
}

#pragma mark----- WKNavigationDelegate -----

- (void)webView:(WKWebView*)webView didFinishNavigation:(WKNavigation*)navigation
{
    [self.webView evaluateJavaScript:@"pageDidLoad()" completionHandler:^(id _Nullable value, NSError* _Nullable error) {
        NSLog(@"%@", value);
    }];
}

#pragma mark----- WKUIDelegate -----

- (void)webView:(WKWebView*)webView runJavaScriptAlertPanelWithMessage:(NSString*)message initiatedByFrame:(WKFrameInfo*)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"msg:%@, frame:%@", message, frame);

    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];

    completionHandler();
}

#pragma mark----- WKScriptMessageHandler -----
/**
 *  JS 调用 OC 时 webview 会调用此方法
 *
 *  @param userContentController  webview 中配置的 userContentController 信息
 *  @param message                js 执行传递的消息
 */
- (void)userContentController:(WKUserContentController*)userContentController didReceiveScriptMessage:(WKScriptMessage*)message
{
    NSLog(@"name:%@, body:%@", message.name, message.body);
}

@end
