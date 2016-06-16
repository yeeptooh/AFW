//
//  WithDrawViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "WithDrawViewController.h"
#import "UserModel.h"
#import "MBProgressHUD.h"
@interface WithDrawViewController ()
<
UIWebViewDelegate
>
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) MBProgressHUD *errorHUD;

@end

@implementation WithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setWebView];
    [self setNaviTitle];
}

- (void)setWebView {
    UserModel *userModel = [UserModel readUserModel];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight)];
    
    self.HUD = [[MBProgressHUD alloc]initWithView:webView];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [webView addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    webView.delegate = self;
    
    self.errorHUD = [[MBProgressHUD alloc]initWithView:webView];
    self.errorHUD.mode = MBProgressHUDModeText;
    self.errorHUD.label.text = @"请检查网络连接";
    self.errorHUD.label.font = font(12);
    [webView addSubview:self.errorHUD];
    
    webView.scrollView.bounces = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@page.aspx?type=withdraw&comid=%ld&uid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid]]]];
    [self.view addSubview:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.HUD hideAnimated:YES];
    [self.HUD removeFromSuperViewOnHide];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.HUD hideAnimated:YES];
    [self.HUD removeFromSuperViewOnHide];
    [self.errorHUD showAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.errorHUD hideAnimated:YES];
        [self.errorHUD removeFromSuperViewOnHide];
    });
    
}

- (void)setNaviTitle {
    self.navigationItem.title = @"我要提现";
}

@end
