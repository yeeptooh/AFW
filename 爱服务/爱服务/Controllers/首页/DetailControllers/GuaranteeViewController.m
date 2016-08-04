//
//  GuaranteeViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "GuaranteeViewController.h"
#import "UserModel.h"

@interface GuaranteeViewController ()

@end

@implementation GuaranteeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserModel *userModel = [UserModel readUserModel];
    self.url = [NSString stringWithFormat:@"%@page.aspx?type=baoxiu&comid=%@&uid=%@",HomeURL,@(userModel.comid),@(userModel.uid)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self setNaviTitle];
}


- (void)setNaviTitle {
    self.navigationItem.title = @"保修政策";
}
@end
