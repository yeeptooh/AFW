//
//  EnsureOrderViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/28.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "EnsureOrderViewController.h"
#import "ZDDModalTransition.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UserModel.h"
#import "AcceptViewController.h"
@interface EnsureOrderViewController ()
<
UIViewControllerTransitioningDelegate
>

@end

@implementation EnsureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.transitioningDelegate = self;
    self.modalTransitionStyle = UIModalPresentationCustom;
    [self configView];
}

- (void)configView {
//    __weak typeof(self)weakSelf = self;
    self.serviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, Width - 10 - 20, (Width - 120)/4 - 10)];
//    self.serviceLabel = [[UILabel alloc]init];
    
    [self.view addSubview:self.serviceLabel];
    
//    [self.serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(5);
//        make.left.mas_equalTo(10);
//        make.width.mas_equalTo(weakSelf.view.bounds.size.width - 30);
//        make.height.mas_equalTo((weakSelf.view.bounds.size.width - 120)/4 - 10);
//    }];
    
    
    CGFloat fontsize;
    if (iPhone4_4s || iPhone5_5s) {
        fontsize = 15;
    }else{
        fontsize = 16;
    }
    self.serviceLabel.text = [NSString stringWithFormat:@"服务人员：%@",self.wName];
    self.serviceLabel.font = font(fontsize);
    self.serviceLabel.textColor = color(30, 30, 30, 1);
    
    UILabel *warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (Width - 120)/4 + 5, (Width - 10) - 20, (Width - 120)/4 - 10)];
//    UILabel *warningLabel = [[UILabel alloc]init];
    
    warningLabel.textColor = color(130, 130, 130, 1);
    warningLabel.text = @"填写跟用户了解并预约的情况：";
    warningLabel.font = font(fontsize);
    [self.view addSubview:warningLabel];
    
//    [warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo((weakSelf.view.bounds.size.width - 120)/4 + 5);
//        make.left.mas_equalTo(10);
//        make.width.mas_equalTo((weakSelf.view.bounds.size.width - 10) - 20);
//        make.height.mas_equalTo((weakSelf.view.bounds.size.width - 120)/4 - 10);
//    }];
    
    self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(10, (Width - 120)*2/4 + 5, (Width - 10) - 20, (Width - 120)/4 - 10)];
    
    self.textfield.font = font(fontsize);
    [self.view addSubview:self.textfield];
    
    UIButton *ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [ensureButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
    ensureButton.backgroundColor = color(59, 165, 249, 1);
    ensureButton.frame = CGRectMake(0, (Width - 120)*3/4 + 5, (Width - 10)/2 - 0.25, (Width - 120)/4 - 5);
    
    
    [self.view addSubview:ensureButton];
    
//    [ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo((weakSelf.view.bounds.size.width - 120)*3/4 + 5);
//        make.left.mas_equalTo(0);
//        make.width.mas_equalTo((weakSelf.view.bounds.size.width - 10)/2 - 0.25);
//        make.height.mas_equalTo((weakSelf.view.bounds.size.width - 120)/4 - 5);
//    }];
    
    [ensureButton addTarget:self action:@selector(ensureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [quitButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [quitButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
    quitButton.backgroundColor = color(59, 165, 249, 1);
    quitButton.frame = CGRectMake((Width - 10)/2 + 0.5, (Width - 120)*3/4 + 5, (Width - 10)/2 - 0.25, (Width - 120)/4 - 5);
    
    [self.view addSubview:quitButton];
//    [quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo((weakSelf.view.bounds.size.width - 120)*3/4 + 5);
//        make.left.mas_equalTo((weakSelf.view.bounds.size.width - 10)/2 + 0.5);
//        make.width.mas_equalTo((weakSelf.view.bounds.size.width - 10)/2 - 0.25);
//        make.height.mas_equalTo((weakSelf.view.bounds.size.width - 120)/4 - 5);
//    }];
    
    [quitButton addTarget:self action:@selector(quitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)ensureButtonClicked {

    
    if ([self.textfield.text isEqualToString:@""] || !self.textfield.text) {
        MBProgressHUD *successHUD = [[MBProgressHUD alloc]initWithView:self.view];
        successHUD.mode = MBProgressHUDModeText;
        successHUD.label.font = font(14);
        successHUD.label.text = @"请填写预约信息";
        [self.view addSubview:successHUD];
        self.view.userInteractionEnabled = NO;
        [successHUD showAnimated:YES];
        [successHUD hideAnimated:YES afterDelay:0.75];
        [successHUD removeFromSuperViewOnHide];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.view.userInteractionEnabled = YES;
            
        });
        return;
    }
    
    [self.textfield resignFirstResponder];
    
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:HUD];
    [HUD showAnimated:YES];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 5;
    UserModel *userModel = [UserModel readUserModel];
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=receive",HomeURL];
    NSDictionary *params = @{
                             @"id":@(self.ID),
                             @"comid":@(userModel.comid),
                             @"uid":@(userModel.uid),
                             @"wid":self.wID,
                             @"wname":self.wName,
                             @"wphone":self.wPhone,
                             @"remark":self.textfield.text,
                             };
    
    
    __weak typeof(self)weakSelf = self;
    
    [manager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HUD hideAnimated:YES];
        [HUD removeFromSuperViewOnHide];
        MBProgressHUD *successHUD = [[MBProgressHUD alloc]initWithView:self.view];
        successHUD.mode = MBProgressHUDModeText;
        successHUD.label.font = font(14);
        successHUD.label.text = @"接单成功";
        [weakSelf.view addSubview:successHUD];
        
        [successHUD showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [successHUD hideAnimated:YES];
            [successHUD removeFromSuperViewOnHide];
            AcceptViewController *parentView = (AcceptViewController *)[(UINavigationController *)[((UITabBarController *)[weakSelf presentingViewController] ) selectedViewController] topViewController];

            [weakSelf dismissViewControllerAnimated:YES completion:^{
                [parentView.navigationController popToRootViewControllerAnimated:YES];
            }];
            
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error = %@",error.userInfo);
        [HUD hideAnimated:YES];
        [HUD removeFromSuperViewOnHide];
        MBProgressHUD *errorHUD = [[MBProgressHUD alloc]initWithView:self.view];
        errorHUD.mode = MBProgressHUDModeText;
        errorHUD.label.font = font(14);
        errorHUD.label.text = @"接单失败";
        [weakSelf.view addSubview:errorHUD];
        
        [errorHUD showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [errorHUD hideAnimated:YES];
            [errorHUD removeFromSuperViewOnHide];
            
        });
    }];
    

}

- (void)quitButtonClicked {
    [self.textfield resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [ZDDModalTransition transitionWithType:ZDDModalTransitionTypePresent duration:0.25];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [ZDDModalTransition transitionWithType:ZDDModalTransitionTypeDismiss duration:0.15];
}

@end
