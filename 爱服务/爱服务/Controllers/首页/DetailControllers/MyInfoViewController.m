//
//  MyInfoViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//


#import "MyInfoViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "UserModel.h"
#import <WebKit/WebKit.h>
@interface MyInfoViewController ()
<
WKNavigationDelegate,
WKUIDelegate
>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *noNetWorkingView;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *quitButton;
@end

@implementation MyInfoViewController

- (UIButton *)quitButton {
    if (!_quitButton) {
        _quitButton = [UIButton buttonWithType:0];
        
        [_quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        
        [_quitButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
        [_quitButton addTarget:self action:@selector(quitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        CGFloat height;
        if (iPhone4_4s || iPhone5_5s) {
            height = 44;
        }else {
            height = 49;
        }
        _quitButton.frame = CGRectMake(0, Height - StatusBarAndNavigationBarHeight - height, Width, height);
        _quitButton.backgroundColor = color(59, 165, 249, 1);
    }
    return _quitButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        if (iPhone4_4s || iPhone5_5s) {
            _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight - TabbarHeight + 5)];
        }else{
            _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight - TabbarHeight)];
        }
        
        _containerView.backgroundColor = [UIColor whiteColor];
        [_containerView addSubview:self.noNetWorkingView];
    }
    return _containerView;
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

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, Width, 2)];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = BlueColor;
    }
    return _progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setWebView];
    [self setNaviTitle];
    [self setQuitButton];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_containerView) {
        [self.containerView removeFromSuperview];
        self.containerView = nil;
    }
}



- (void)setWebView {
    UserModel *userModel = [UserModel readUserModel];
    CGFloat height;
    if (iPhone4_4s || iPhone5_5s) {
        height = 44;
    }else {
        height = 49;
    }

    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight - height)];
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;

    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
#if Environment_Mode == 1
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/page.aspx?type=user&comid=%ld&uid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid]]]];
    NSLog(@"%@",[NSString stringWithFormat:@"%@/page.aspx?type=user&comid=%ld&uid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid]);
    
#elif Environment_Mode == 2
    self.url = [NSString stringWithFormat:@"%@/page.aspx?type=user&comid=%ld&uid=%ld&device=i",HomeURL,(long)userModel.comid,(long)userModel.uid];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
#endif
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.view addSubview:self.progressView];
    [self.view insertSubview:self.webView belowSubview:self.progressView];
    
    
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
#if Environment_Mode == 1
#elif Environment_Mode == 2
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
#endif
    
    
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    
    [controller addAction:action];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:controller animated:YES completion:^{
            completionHandler();
        }];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.webView.estimatedProgress;
    }else if ([keyPath isEqualToString:@"canGoBack"]) {
        
        
    }
    //加载完成
    if (!self.webView.isLoading) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
    }
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.progressView.alpha = 0;
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.view addSubview:self.containerView];
    }
}



- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
#if Environment_Mode == 1
#elif Environment_Mode == 2
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
#endif
    
}



- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    
    
}




- (void)setQuitButton {
#if Environment_Mode == 1
    UIButton *quitButton = [UIButton buttonWithType:0];
    
    [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    
    [quitButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    CGFloat height;
    if (iPhone4_4s || iPhone5_5s) {
        height = 44;
    }else {
        height = 49;
    }
    quitButton.frame = CGRectMake(0, Height - StatusBarAndNavigationBarHeight - height, Width, height);
    quitButton.backgroundColor = color(59, 165, 249, 1);
    [self.view addSubview:quitButton];
#elif Environment_Mode == 2
    
    [self.view addSubview:self.quitButton];
#endif
    
}

- (void)quitButtonClicked {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"logOut"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hadLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    NSArray *vcList = self.navigationController.viewControllers;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [vcList[0] presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil];
    
}





- (void)setNaviTitle {
#if Environment_Mode == 1
    self.navigationItem.title = @"我的信息";
#elif Environment_Mode == 2
    self.navigationItem.title = @"基础信息";
#endif
    
}




@end
