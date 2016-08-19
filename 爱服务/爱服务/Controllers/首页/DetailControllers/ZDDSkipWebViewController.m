//
//  ZDDSkipWebViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/8/19.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "ZDDSkipWebViewController.h"

@interface ZDDSkipWebViewController ()
<
WKUIDelegate
>
@end

@implementation ZDDSkipWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.UIDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadURL]]];
    [self setNaviTitle];
}

- (void)setNaviTitle {
    self.navigationItem.title = @"爱服务";
}

@end
