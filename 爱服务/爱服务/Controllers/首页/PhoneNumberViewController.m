//
//  PhoneNumberViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/12.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "PhoneNumberViewController.h"

@interface PhoneNumberViewController ()

@end

@implementation PhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
    [self setTable];
}

- (void)setTable {
    
    CGFloat height;
    CGFloat width;
    CGFloat fontSize;
    if (iPhone6_plus) {
        height = Height - 420;
        width = Width - 100;
        fontSize = 20;
    }else if (iPhone6) {
        height = Height - 400;
        width = Width - 100;
        fontSize = 18;
    }else if (iPhone5_5s) {
        height = Height - 350;
        width = Width - 100;
        fontSize = 18;
    }else {
        height = Height - 200;
        width = Width - 100;
        fontSize = 16;
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height*1.5/5.5)];
    label.text = @"拨打客服电话";
    label.textColor = color(59, 165, 249, 1);
    label.font = font(fontSize);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(6, height*1.5/5.5 - 0.5, width - 12, 0.5)];
    lineView1.backgroundColor = color(150, 150, 150, 1);
    [self.view addSubview:lineView1];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstButton setTitle:@"0757-26631015" forState:UIControlStateNormal];
    [firstButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
    [firstButton setTitleColor:color(230, 230, 230, 1) forState:UIControlStateHighlighted];
    firstButton.frame = CGRectMake(0, height*1.5/5.5, width, height/5.5);
    [firstButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:firstButton];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(6, height*2.5/5.5 - 0.5, width - 12, 0.5)];
    lineView2.backgroundColor = color(150, 150, 150, 1);
    [self.view addSubview:lineView2];
    
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondButton setTitle:@"0757-26631895" forState:UIControlStateNormal];
    [secondButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
    [secondButton setTitleColor:color(230, 230, 230, 1) forState:UIControlStateHighlighted];
    secondButton.frame = CGRectMake(0, height*2.5/5.5, width, height/5.5);
    [secondButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
 
    [self.view addSubview:secondButton];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(6, height*3.5/5.5 - 0.5, width - 12, 0.5)];
    lineView3.backgroundColor = color(150, 150, 150, 1);
    [self.view addSubview:lineView3];
    
    UIButton *thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [thirdButton setTitle:@"0757-26631581" forState:UIControlStateNormal];
    [thirdButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
    [thirdButton setTitleColor:color(230, 230, 230, 1) forState:UIControlStateHighlighted];
    thirdButton.frame = CGRectMake(0, height*3.5/5.5, width, height/5.5);
    [thirdButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
 
    [self.view addSubview:thirdButton];
    
    UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [quitButton setTitle:@"取消" forState:UIControlStateNormal];
    [quitButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
    [quitButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
    quitButton.backgroundColor = color(59, 165, 249, 1);
    quitButton.frame = CGRectMake(0, height*4.5/5.5, width, height/5.5);
    
    [self.view addSubview:quitButton];
    [quitButton addTarget:self action:@selector(quitButtonClicked) forControlEvents:UIControlEventTouchUpInside];

}

- (void)buttonClicked:(UIButton *)sender {
    
        NSString *telString = [NSString stringWithFormat:@"telprompt://%@",sender.titleLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
    
}

- (void)quitButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
