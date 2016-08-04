//
//  WithDrawViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "WithDrawViewController.h"
#import "UserModel.h"
#import <WebKit/WebKit.h>
@interface WithDrawViewController ()
<
WKUIDelegate
>

@end

@implementation WithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UserModel *userModel = [UserModel readUserModel];
    self.webView.UIDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@page.aspx?type=withdraw&comid=%ld&uid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid]]]];
    [self setNaviTitle];
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

- (void)setNaviTitle {
    self.navigationItem.title = @"我要提现";
}

@end
