//
//  RegisterViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "RegisterViewController.h"
#import <WebKit/WebKit.h>

@interface RegisterViewController ()
<
WKNavigationDelegate
>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *noNetWorkingView;
@property (nonatomic, strong) UIView *snapView;

@end

@implementation RegisterViewController

- (UIView *)snapView {
    if (!_snapView) {
        _snapView = [self.presentingViewController.view snapshotViewAfterScreenUpdates:NO];
        _snapView.frame = CGRectMake(-Width/2, 0, Width, Height);
        
    }
    return _snapView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight - 1, Width, 0)];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = BlueColor;
        
    }
    return _progressView;
}


- (UIView *)noNetWorkingView {
    
    if (!_noNetWorkingView) {
        _noNetWorkingView = [[UIView alloc]initWithFrame:CGRectMake(0, SearchBarHeight, Width, Height - StatusBarAndNavigationBarHeight - TabbarHeight - SearchBarHeight)];
        _noNetWorkingView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loding_wrong"]];
        imageView.center = CGPointMake(Width/2, _noNetWorkingView.center.y - imageView.bounds.size.height/2 - 25);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width, 50)];
        label.center = _noNetWorkingView.center;
        label.text = @"请检查网络";
        label.font = font(18);
        label.textAlignment = NSTextAlignmentCenter;
        [_noNetWorkingView addSubview:imageView];
        [_noNetWorkingView addSubview:label];
        
    }
    return _noNetWorkingView;
}

- (void)setNavigationView {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, StatusBarAndNavigationBarHeight - 1)];
    navigationView.backgroundColor = color(230, 230, 230, 1);
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight - 1, Width, 1.2)];
    lineLabel.backgroundColor = color(180, 180, 180, 1);
    [self.view addSubview:lineLabel];
    [self.view addSubview:navigationView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, StatusBarHeight, Width - 100, NavigationBarHeight - 1)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"注 册";
    label.textColor = [UIColor blackColor];
    label.font = font(18);
    label.textAlignment = NSTextAlignmentCenter;
    [navigationView addSubview:label];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton addTarget:self action:@selector(backLastView:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, StatusBarHeight, 60, NavigationBarHeight);
    
    [backButton setImage:[UIImage imageNamed:@"icon_back_pre"] forState:UIControlStateNormal];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    
    [navigationView addSubview:backButton];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationView];
    [self setWebView];

}

- (void)viewWillAppear:(BOOL)animated {
    [self.view.superview insertSubview:self.snapView atIndex:0];
    
}

- (void)setWebView {
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Width, Height - StatusBarAndNavigationBarHeight)];
    [self.view addSubview:self.webView];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.51ifw.com/passport/regbymobile.aspx?action=fromapp"]]];
    self.webView.scrollView.bounces = NO;
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.progressView];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    if (!self.webView.isLoading) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
    }
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //去掉html的标题
//    NSString *str1 = @"document.getElementById('head').remove();";
//    [webView evaluateJavaScript:str1 completionHandler:nil];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.progressView.alpha = 0;
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
        [self.view addSubview:self.noNetWorkingView];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
        [self.view addSubview:self.noNetWorkingView];
    }
}

- (void)backLastView:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];

    
    [UIView animateWithDuration:.3
                     animations:^{
                         self.snapView.frame = CGRectMake(0, 0, Width, Height);
                         self.view.frame = CGRectMake(Width, 0, Width, Height);
                     }
                     completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:NO completion:^{
                             [self.view removeFromSuperview];
                             [self.snapView removeFromSuperview];
                         }];
                     }];
}


- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
}



@end
