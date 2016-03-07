//
//  MainViewController.m
//  DZJSNativeBridge
//
//  Created by song_dzhong on 16/2/29.
//  Copyright © 2016年 song_dzhong. All rights reserved.
//

#import "MainViewController.h"
#import "NextViewController.h"

@interface MainViewController () <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView* webView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"UIWebView";
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView = webView;
    self.webView.delegate = self;
    [self.view addSubview:webView];

    UIBarButtonItem* nextVC = [[UIBarButtonItem alloc] initWithTitle:@"next" style:0 target:self action:@selector(nextVC)];
    self.navigationItem.rightBarButtonItem = nextVC;
}

- (void)nextVC
{
    NextViewController* vc = [[NextViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"TestJSBridge__tradition.html" ofType:nil];
    NSString* HTMLStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:HTMLStr baseURL:nil];
}


#pragma mark----- UIWebViewDelegate -----

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    //dzbridge 为约定好的协议头，如果是，则页面不进行跳转
    if ([request.URL.scheme isEqualToString:@"dzbridge"]) {
        //截取字符串来判断是否存在参数
        NSArray<NSString*>* arr = [request.URL.absoluteString componentsSeparatedByString:@"?"];
        if (arr.count > 1) {
            NSString* str = [arr[1] stringByRemovingPercentEncoding];
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            NSLog(@"%@", dict[@"string"]);
        }
        else {
            NSLog(@"没有参数的打印");
        }
        return NO;
    }
    //不是自定义协议头，跳转页面
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    NSString* str = [self.webView stringByEvaluatingJavaScriptFromString:@"pageDidLoad()"];
    NSLog(@"%@", str);
}

@end
