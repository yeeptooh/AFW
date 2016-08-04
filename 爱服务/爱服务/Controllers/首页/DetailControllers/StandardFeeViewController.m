//
//  StandardFeeViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "StandardFeeViewController.h"
#import "UserModel.h"
@interface StandardFeeViewController ()

@end

@implementation StandardFeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UserModel *userModel = [UserModel readUserModel];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@page.aspx?type=shoufei&comid=%ld&uid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid]]]];
    [self setNaviTitle];
}

- (void)setNaviTitle {
    self.navigationItem.title = @"收费标准";
}

@end
