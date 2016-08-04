//
//  ZDDWebViewViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/8/2.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "ZDDWebViewController.h"
@interface ZDDWebViewController ()
<
WKNavigationDelegate
>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIView *noNetWorkingView;
@end

@implementation ZDDWebViewController

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight)];
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, Width, 20)];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = BlueColor;
    }
    return _progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_noNetWorkingView) {
        [self.noNetWorkingView removeFromSuperview];
        self.noNetWorkingView = nil;
    }
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
    }
    //加载完成
    if (!self.webView.isLoading) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIView animateWithDuration:0.5 animations:^{
        self.progressView.alpha = 0;
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.view addSubview:self.noNetWorkingView];
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
