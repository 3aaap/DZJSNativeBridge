//
//  MainViewController.m
//  DZJSNativeBridge
//
//  Created by song_dzhong on 16/2/29.
//  Copyright © 2016年 song_dzhong. All rights reserved.
//

#import "MainViewController.h"

@protocol JSObjcDelegate <JSExport>

- (void)callCamera;
- (NSString*)share:(NSString*)shareString;

@end

@interface MainViewController () <UIWebViewDelegate, JSObjcDelegate>

@property (nonatomic, strong) JSContext* jsContext;
@property (weak, nonatomic) UIWebView* webView;

@end

@implementation MainViewController

#pragma mark - Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView = webView;
    self.webView.delegate = self;
    [self.view addSubview:webView];

    NSURL* url = [[NSBundle mainBundle] URLForResource:@"TestJSBridge__JavaScriptCore" withExtension:@"html"];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];

    UIButton* btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"执行JS" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor darkGrayColor];
    btn.frame = CGRectMake(0, 400, 100, 30);
    [self.view addSubview:btn];
}

- (void)btnClick
{
    [self.jsContext evaluateScript:@"alert(\"执行 JS\")"];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //    self.jsContext[@"DZBridge"] = self;
    [self.jsContext setObject:self forKeyedSubscript:@"DZBridge"];
    self.jsContext.exceptionHandler = ^(JSContext* context, JSValue* exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

#pragma mark - JSObjcDelegate

- (void)callCamera
{
    NSLog(@"callCamera");
    // 获取到照片之后在回调js的方法picCallback把图片传出去
    JSValue* picCallback = self.jsContext[@"picCallback"];
    [picCallback callWithArguments:@[ @"photoss" ]];
}

- (NSString*)share:(NSString*)shareString
{
    NSLog(@"share:%@", shareString);
    // 分享成功回调js的方法shareCallback
    JSValue* shareCallback = self.jsContext[@"shareCallback"];
    //    JSValue* shareCallback = [self.jsContext objectForKeyedSubscript:@"shareCallback"];
    NSLog(@"%@", [shareCallback toString]);
    [shareCallback callWithArguments:nil];
    return @"执行完毕！";
}

@end
