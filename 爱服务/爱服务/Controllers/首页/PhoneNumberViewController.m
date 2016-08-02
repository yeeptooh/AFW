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
    [self setTableView];
}

- (void)setTableView {
    
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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, height*1.5/5.5, width, height/5.5)];
    label.text = @"客服电话";
    label.textColor = color(59, 165, 249, 1);
    label.font = font(fontSize);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    
    UILabel *time1label = [[UILabel alloc] initWithFrame:CGRectMake(width/10, 0, (width*4/5), (height*1.5/5.5)/2)];
    if (iPhone4_4s) {
        time1label.text = @"上午   08:30 - 12:00";
    }else if (iPhone5_5s) {
        time1label.text = @"上午     08:30 - 12:00";
    }else if (iPhone6) {
        time1label.text = @"上午       08:30 - 12:00";
    }else if (iPhone6_plus) {
        time1label.text = @"上午         08:30 - 12:00";
    }
    
    time1label.textColor = RedColor;
    time1label.font = font(fontSize - 3);
    time1label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:time1label];
    
    UILabel *time2label = [[UILabel alloc] initWithFrame:CGRectMake(width/10, (height*1.5/5.5)/2, (width*4/5), (height*1.5/5.5)/2)];
    if (iPhone4_4s) {
        time2label.text = @"下午   13:30 - 18:00";
    }else if (iPhone5_5s) {
        time2label.text = @"下午     13:30 - 18:00";
    }else if (iPhone6) {
        time2label.text = @"下午       13:30 - 18:00";
    }else if (iPhone6_plus) {
        time2label.text = @"下午         13:30 - 18:00";
    }
    
    time2label.textColor = RedColor;
    time2label.font = font(fontSize - 3);
    time2label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:time2label];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, height*1.5/5.5 - 0.5, width, 0.5)];
    lineView1.backgroundColor = color(150, 150, 150, 1);
    [self.view addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(width/10, height*2.5/5.5 - 0.5, width*4/5, 0.5)];
    lineView2.backgroundColor = color(150, 150, 150, 1);
    [self.view addSubview:lineView2];
    
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondButton setTitle:@"0757-26631895" forState:UIControlStateNormal];
    [secondButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
    [secondButton setTitleColor:color(230, 230, 230, 1) forState:UIControlStateHighlighted];
    secondButton.frame = CGRectMake(0, height*2.5/5.5, width, height/5.5);
    [secondButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
 
    [self.view addSubview:secondButton];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(width/10, height*3.5/5.5 - 0.5, width*8/10, 0.5)];
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
    [quitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    quitButton.backgroundColor = MainBlueColor;
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
