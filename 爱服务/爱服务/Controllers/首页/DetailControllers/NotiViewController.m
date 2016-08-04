//
//  NotiViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "NotiViewController.h"
#import "UserModel.h"

@interface NotiViewController ()

@end

@implementation NotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UserModel *userModel = [UserModel readUserModel];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@page.aspx?type=tongzhi&comid=%@&uid=%@",HomeURL,@(userModel.comid),@(userModel.uid)]]]];
    [self setNaviTitle];
}

- (void)backLastView:(UIBarButtonItem *)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kBackFromNoti object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setNaviTitle {
    self.navigationItem.title = @"通知公告";
}
@end
