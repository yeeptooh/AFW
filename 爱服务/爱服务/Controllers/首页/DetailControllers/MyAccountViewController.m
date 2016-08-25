//
//  MyAccountViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//
//  以前感觉仗剑走天涯才潇洒， 现在想想平平淡淡也是福

#import "MyAccountViewController.h"
#import "UserModel.h"
@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UserModel *userModel = [UserModel readUserModel];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@page.aspx?type=zhanghu&comid=%ld&uid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid]]]];
    [self setNaviTitle];
}

- (void)setNaviTitle {
    self.navigationItem.title = @"我的帐户";
}

@end
