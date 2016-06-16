//
//  QRCodeViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/26.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "BarCodeViewController.h"

@interface BarCodeViewController ()

@end

@implementation BarCodeViewController

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
        
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
    }
    return _bgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviTitle];
    [self.view addSubview:self.bgView];
}

- (void)setNaviTitle {
    self.navigationItem.title = @"扫一扫";
}

@end
