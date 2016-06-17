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
WKNavigationDelegate
>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *noNetWorkingView;
@end

@implementation MyInfoViewController

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
    if (_noNetWorkingView) {
        [self.noNetWorkingView removeFromSuperview];
        self.noNetWorkingView = nil;
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
    
    
    
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/page.aspx?type=user&comid=%ld&uid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid]]]];
    [self.view addSubview:self.progressView];
    [self.view insertSubview:self.webView belowSubview:self.progressView];
    
    
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //        self.progressView.hidden = self.webView.estimatedProgress == 1;
        //        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
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
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
        [self.view addSubview:self.noNetWorkingView];
    }
}



- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
}

- (void)setQuitButton {
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

    [vcList[0] presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil];
    
}

- (void)setNaviTitle {
    self.navigationItem.title = @"我的信息";
}




@end
