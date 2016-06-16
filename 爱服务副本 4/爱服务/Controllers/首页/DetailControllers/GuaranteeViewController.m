//
//  GuaranteeViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "GuaranteeViewController.h"
#import "UserModel.h"
#import "MBProgressHUD.h"

@interface GuaranteeViewController ()
<
UIWebViewDelegate
>
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) MBProgressHUD *errorHUD;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation GuaranteeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setWebView];
    [self setNaviTitle];
}

- (void)setWebView {
   
    UserModel *userModel = [UserModel readUserModel];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight)];
    self.HUD = [[MBProgressHUD alloc]initWithView:self.webView];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.webView addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    self.webView.delegate = self;
    
    self.errorHUD = [[MBProgressHUD alloc]initWithView:self.webView];
    self.errorHUD.mode = MBProgressHUDModeText;
    self.errorHUD.label.text = @"请检查网络连接";
    self.errorHUD.label.font = font(12);
    [self.webView addSubview:self.errorHUD];
    
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@page.aspx?type=baoxiu&comid=%ld&uid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid]]]];
    [self.view addSubview:self.webView];
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
    self.navigationItem.title = @"保修政策";
}
@end
