//
//  ChangePWDViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/7/19.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "ChangePWDViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UserModel.h"
@interface ChangePWDViewController ()

@property (nonatomic, strong) UITextField *textfield2;
@end

@implementation ChangePWDViewController

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
        height = Height - 550;
        width = Width - 100;
        fontSize = 20;
    }else if (iPhone6) {
        height = Height - 500;
        width = Width - 100;
        fontSize = 18;
    }else if (iPhone5_5s) {
        height = Height - 420;
        width = Width - 100;
        fontSize = 18;
    }else {
        height = Height - 320;
        width = Width - 100;
        fontSize = 16;
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height/4)];
    label.text = @"修改密码";
    label.textColor = color(59, 165, 249, 1);
    label.font = font(fontSize);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    
    
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(5, height/4 - 0.5, width - 10, 0.5)];
    lineView2.backgroundColor = color(150, 150, 150, 1);
    [self.view addSubview:lineView2];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lineView2.frame), width/4, height/4)];
    label1.text = @"修改密码";
    if (iPhone6 || iPhone6_plus) {
        label1.font = font(14);
    }else {
        label1.font = font(13);
    }
    
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = color(59, 165, 249, 1);
    [self.view addSubview:label1];
    
    self.textfield1 = [[UITextField  alloc] initWithFrame:CGRectMake(5+CGRectGetMaxX(label1.frame), CGRectGetMaxY(lineView2.frame), width - 5 - width/4, height/4)];
    [self.view addSubview:self.textfield1];
    self.textfield1.secureTextEntry = YES;
    if (iPhone6 || iPhone6_plus) {
        self.textfield1.font = font(14);
    }else {
        self.textfield1.font = font(13);
    }
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(5, height/2 - 0.5, width - 10, 0.5)];
    lineView3.backgroundColor = color(150, 150, 150, 1);
    [self.view addSubview:lineView3];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lineView3.frame), width/4, height/4)];
    label2.text = @"确认密码";
    if (iPhone6 || iPhone6_plus) {
        label2.font = font(14);
    }else {
        label2.font = font(13);
    }
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = color(59, 165, 249, 1);
    [self.view addSubview:label2];
    
    self.textfield2 = [[UITextField  alloc] initWithFrame:CGRectMake(5+CGRectGetMaxX(label2.frame), CGRectGetMaxY(lineView3.frame), width - 5 - width/4, height/4)];
    [self.view addSubview:self.textfield2];
    self.textfield2.secureTextEntry = YES;
    if (iPhone6 || iPhone6_plus) {
        self.textfield2.font = font(14);
    }else {
        self.textfield2.font = font(13);
    }
    
    UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [quitButton setTitle:@"取消" forState:UIControlStateNormal];
    [quitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    quitButton.backgroundColor = MainBlueColor;
    quitButton.frame = CGRectMake(0, height*3/4, width/2-0.3, height/4);
    
    [self.view addSubview:quitButton];
    [quitButton addTarget:self action:@selector(quitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *decideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [decideButton setTitle:@"确定" forState:UIControlStateNormal];
    [decideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    decideButton.backgroundColor = MainBlueColor;
    decideButton.frame = CGRectMake(width/2+0.3, height*3/4, width/2-0.3, height/4);
    [self.view addSubview:decideButton];
    [decideButton addTarget:self action:@selector(decideButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
}



- (void)buttonClicked:(UIButton *)sender {
    
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@",sender.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
    
}

- (void)quitButtonClicked {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)decideButtonClicked {
    [self.view endEditing:YES];
    if ([self.textfield1.text isEqualToString:@""] || !self.textfield1.text) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入新密码";
        hud.label.font = font(14);
        [hud hideAnimated:YES afterDelay:1.25];
        return;
    }
    if ([self.textfield2.text isEqualToString:@""] || !self.textfield2.text) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入确认密码";
        hud.label.font = font(14);
        [hud hideAnimated:YES afterDelay:1.25];
        return;
    }
    
    if (![self.textfield1.text isEqualToString:self.textfield2.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"密码输入不一致";
        hud.label.font = font(14);
        [hud hideAnimated:YES afterDelay:1.25];
        return;
    }
    
    
    UserModel *userModel = [UserModel readUserModel];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/Passport.ashx?action=changepwd",HomeURL];
    NSDictionary *params = @{
                             @"userId":@(userModel.uid),
                             @"newPassword":self.textfield2.text,
                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *str = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([str integerValue] == 1) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = NSLocalizedString(@"修改成功", @"HUD completed title");
            hud.label.font = font(14);
            [hud hideAnimated:YES afterDelay:0.75f];
            [hud removeFromSuperViewOnHide];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = NSLocalizedString(@"修改失败", @"HUD completed title");
            hud.label.font = font(14);
            [hud hideAnimated:YES afterDelay:0.75f];
            [hud removeFromSuperViewOnHide];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"修改失败", @"HUD completed title");
        hud.label.font = font(14);
        [hud hideAnimated:YES afterDelay:0.75f];
        [hud removeFromSuperViewOnHide];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
}

@end
