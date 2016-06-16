//
//  DetailPageBaseViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/9.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "DetailPageBaseViewController.h"

@interface DetailPageBaseViewController ()

@end

@implementation DetailPageBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backLastView:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 60, 40);
    [backButton setTitleColor:color(245, 245, 245, 1) forState:UIControlStateNormal];
    [backButton setTitleColor:color(170, 170, 170, 1) forState:UIControlStateHighlighted];
    [backButton setImage:[UIImage imageNamed:@"navigationbar_back_light"] forState:UIControlStateNormal];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    
    UIBarButtonItem  *backItem =[[UIBarButtonItem alloc]initWithCustomView: backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backLastView:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
