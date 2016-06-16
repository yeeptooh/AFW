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
#import "MBProgressHUD.h"
@interface MyInfoViewController ()
<
UIWebViewDelegate
>
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) MBProgressHUD *errorHUD;
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNaviTitle];
    [self setWebView];
    [self setQuitButton];
}



- (void)setWebView {
    UserModel *userModel = [UserModel readUserModel];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight - TabbarHeight)];
    
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
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/page.aspx?type=user&comid=%ld&uid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid]]]];
    [self.view addSubview:webView];
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

- (void)dealloc {
    NSLog(@"MyInfo dealloc");
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


@end
