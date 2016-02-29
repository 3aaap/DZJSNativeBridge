//
//  MainViewController.m
//  DZJSNativeBridge
//
//  Created by song_dzhong on 16/2/29.
//  Copyright © 2016年 song_dzhong. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView* webView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView = webView;
    self.webView.delegate = self;
    [self.view addSubview:webView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"TestJSBridge__tradition.html" ofType:nil];
    NSString* HTMLStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:HTMLStr baseURL:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark----- UIWebViewDelegate -----

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.scheme isEqualToString:@"dzbridge"]) {
        NSArray<NSString*>* arr = [request.URL.absoluteString componentsSeparatedByString:@"?"];
        if (arr.count > 1) {
            NSString* str = [arr[1] stringByRemovingPercentEncoding];
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            NSLog(@"%@", dict[@"string"]);
        } else{
            NSLog(@"没有参数的打印");
        }
        return NO;
    }

    return YES;
}

@end
