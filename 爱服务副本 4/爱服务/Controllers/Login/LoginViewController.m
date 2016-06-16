//
//  LoginViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/9.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "LoginViewController.h"
#import "UserModel.h"

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "RegisterViewController.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"

@interface LoginViewController ()
<
UITextFieldDelegate
>

@property (nonatomic, strong) UIView *loginContainerView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) MBProgressHUD *successHUD;
@property (nonatomic, strong) MBProgressHUD *nilHUD;
@property (nonatomic, strong) MBProgressHUD *failHUD;

@end

@implementation LoginViewController

- (UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[UITextField alloc]init];
    }
    return _accountTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc]init];
    }
    return _passwordTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = color(102, 201, 228, 1);
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    if (userName) {
        self.accountTextField.text = userName;
        self.passwordTextField.text = password;
    }
    
    [self setLogoImageView];
    [self setLoginContainer];
    [self addNotification];
}

- (void)setLogoImageView {
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainlogo"]];
    [self.view addSubview:self.imageView];
    
    __weak typeof(self) weakSelf = self;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(90);
        make.centerX.mas_equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(150, 50));
    }];
    
}

- (void)setLoginContainer {
    
    __weak typeof(self) weakSelf = self;
    
    self.loginContainerView = [[UIView alloc]init];
    self.loginContainerView.backgroundColor = color(164, 217, 231, 0.8);
    self.loginContainerView.layer.cornerRadius = 5;
    self.loginContainerView.layer.masksToBounds = YES;
    if (iPhone6 || iPhone6_plus) {
        self.loginContainerView.frame = CGRectMake(35, 155, Width - 70, Width - 70);
    }else{
        self.loginContainerView.frame = CGRectMake(10, 155, Width - 20, Width - 20);
    }
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"登录爱服务家电工作平台";
    label.textAlignment = NSTextAlignmentCenter;
    
    self.accountTextField.placeholder = @"请输入帐号";
    self.accountTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.accountTextField.returnKeyType = UIReturnKeyNext;
    self.accountTextField.tag = 100;
    self.accountTextField.delegate = self;
    self.accountTextField.clearsOnBeginEditing = YES;
    
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.tag = 101;
    self.passwordTextField.delegate = self;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearsOnBeginEditing = YES;
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = color(102, 201, 228, 1);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
    [loginButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    loginButton.layer.cornerRadius = 5;
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"注册新用户" forState:UIControlStateNormal];
    [registerButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
    [registerButton setTitleColor:color(50, 50, 50, 1) forState:UIControlStateHighlighted];
    [registerButton addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    if (iPhone6_plus || iPhone6) {
        registerButton.frame = CGRectMake(35 + (Width - 70)/2, 155 + (Width - 70), (Width - 70)/2, 40);
        registerButton.titleLabel.font = font(16);
    }else{
        registerButton.frame = CGRectMake(10 + (Width - 20)/2, 155 + (Width - 20), (Width - 20)/2, 40);
        registerButton.titleLabel.font = font(14);
    }
    registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    
    [self.loginContainerView addSubview:loginButton];
    [self.view addSubview:registerButton];
    [self.loginContainerView addSubview:self.accountTextField];
    [self.loginContainerView addSubview:self.passwordTextField];
    [self.loginContainerView addSubview:label];
    [self.view addSubview:self.loginContainerView];

    
    
    if (iPhone6_plus) {
        loginButton.titleLabel.font = font(16);
        label.font = font(18);
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.left.mas_equalTo(60);
            make.right.mas_equalTo(-60);
            make.top.mas_equalTo(30);
        }];
        
        [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(90);
            make.left.mas_equalTo(60);
            make.right.mas_equalTo(-60);
            make.height.mas_equalTo(40);
            
        }];
        
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.accountTextField.mas_bottom).mas_equalTo(25);
            make.left.mas_equalTo(60);
            make.right.mas_equalTo(-60);
            make.height.mas_equalTo(40);
        }];
        
        [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(40);
            make.left.mas_equalTo(60);
            make.right.mas_equalTo(-60);
            make.bottom.mas_equalTo(-50);
            
        }];
    }else{
        
        loginButton.titleLabel.font = font(14);
        label.font = font(16);

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.left.mas_equalTo(60);
            make.right.mas_equalTo(-60);
            make.top.mas_equalTo(30);
        }];
        
        [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.left.mas_equalTo(60);
            make.right.mas_equalTo(-60);
            make.top.mas_equalTo(70);
        }];

        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.accountTextField.mas_bottom).mas_equalTo(15);
            make.left.mas_equalTo(60);
            make.right.mas_equalTo(-60);
            make.height.mas_equalTo(40);
        }];
        
        [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakSelf.passwordTextField.mas_bottom).mas_equalTo(45);
            make.left.mas_equalTo(60);
            make.right.mas_equalTo(-60);
            make.bottom.mas_equalTo(-50);
            
        }];
    }

}

- (void)loginNetWorking {
    _HUD = [[MBProgressHUD alloc]initWithView:self.view];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:_HUD];
    
    [self.HUD showAnimated:YES];
    NSDictionary *params = @{
                             @"name":self.accountTextField.text,
                             @"password":self.passwordTextField.text
                             };
    NSString *URL = [NSString stringWithFormat:@"%@Passport.ashx?action=login",HomeURL];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    __weak typeof(self)weakSelf = self;
    
    [manager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf.HUD hideAnimated:YES];
        [weakSelf.HUD removeFromSuperViewOnHide];
        
        if (responseObject != nil) {

            _successHUD = [[MBProgressHUD alloc]initWithView:self.view];
            _successHUD.mode = MBProgressHUDModeText;
            _successHUD.label.text = @"登录成功";
            _successHUD.label.font = font(12);
            
            [weakSelf.view addSubview:_successHUD];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.accountTextField.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.passwordTextField.text forKey:@"password"];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hadLaunch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UserModel *userModel = [[UserModel alloc]init];
            userModel.uid = [responseObject[@"user"][0][@"UserId"] integerValue];
            userModel.comid = [responseObject[@"user"][0][@"CompanyID"] integerValue];
            userModel.money = [responseObject[@"user"][0][@"Money"] floatValue];
            userModel.provinceid = [responseObject[@"user"][0][@"ProvinceID"] integerValue];
            userModel.cityid = [responseObject[@"user"][0][@"CityID"] integerValue];
            userModel.districtid = [responseObject[@"user"][0][@"DistrictID"] integerValue];
            userModel.name = responseObject[@"user"][0][@"Name"];
            [UserModel writeUserModel:userModel];
            
            [weakSelf.successHUD showAnimated:YES];
            

            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSString *countString = [NSString stringWithFormat:@"%@Task.ashx?action=gettaskcount&comid=%ld&uid=%ld&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager GET:countString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSString *allString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSArray *countList = [allString componentsSeparatedByString:@","];
                NSLog(@"%@",countList);
                [[NSUserDefaults standardUserDefaults] setObject:countList forKey:@"countList"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [weakSelf.successHUD hideAnimated:YES];
                [weakSelf.successHUD removeFromSuperViewOnHide];
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"logOut"]) {
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }else{
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [UIApplication sharedApplication].keyWindow.rootViewController = appDelegate.tabBarController;
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        
            
        }else{
            if ([weakSelf.accountTextField.text isEqualToString:@""] || [weakSelf.passwordTextField.text isEqualToString:@""]) {
                _nilHUD = [[MBProgressHUD alloc]initWithView:self.view];
                _nilHUD.mode = MBProgressHUDModeText;
                _nilHUD.label.text = @"用户名或密码为空";
                _nilHUD.label.font = font(12);
                [weakSelf.view addSubview:_nilHUD];
                [weakSelf.nilHUD showAnimated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.nilHUD hideAnimated:YES];
                    [weakSelf.nilHUD removeFromSuperViewOnHide];
                });
            }else {
                _failHUD = [[MBProgressHUD alloc]initWithView:self.view];
                _failHUD.mode = MBProgressHUDModeText;
                _failHUD.label.text = @"用户名或密码错误";
                _failHUD.label.font = font(12);
                [weakSelf.view addSubview:_failHUD];
                
                [weakSelf.failHUD showAnimated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.failHUD hideAnimated:YES];
                    [weakSelf.failHUD removeFromSuperViewOnHide];
                });
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf.HUD hideAnimated:YES];
        [weakSelf.HUD removeFromSuperViewOnHide];
        MBProgressHUD *noConnectHUD = [[MBProgressHUD alloc]initWithView:self.view];
        noConnectHUD.mode = MBProgressHUDModeText;
        noConnectHUD.label.text = @"请检查网络连接";
        noConnectHUD.label.font = font(14);
        [weakSelf.view addSubview:noConnectHUD];
        [noConnectHUD showAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [noConnectHUD hideAnimated:YES];
            [noConnectHUD removeFromSuperViewOnHide];
        });
        
    }];
    
    
    
//    [manager POST:URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self.HUD hideAnimated:YES];
//        [self.HUD removeFromSuperViewOnHide];
//        
//        if (responseObject != nil) {
//            
//            _successHUD = [[MBProgressHUD alloc]initWithView:self.view];
//            _successHUD.mode = MBProgressHUDModeText;
//            _successHUD.label.text = @"登录成功";
//            _successHUD.label.font = font(12);
//            
//            [self.view addSubview:_successHUD];
//            [[NSUserDefaults standardUserDefaults] setObject:self.accountTextField.text forKey:@"username"];
//            [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"password"];
//            
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hadLaunch"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            UserModel *userModel = [[UserModel alloc]init];
//            userModel.uid = [responseObject[@"user"][0][@"UserId"] integerValue];
//            userModel.comid = [responseObject[@"user"][0][@"CompanyID"] integerValue];
//            userModel.money = [responseObject[@"user"][0][@"Money"] floatValue];
//            userModel.provinceid = [responseObject[@"user"][0][@"ProvinceID"] integerValue];
//            userModel.cityid = [responseObject[@"user"][0][@"CityID"] integerValue];
//            userModel.districtid = [responseObject[@"user"][0][@"DistrictID"] integerValue];
//            
//            [UserModel writeUserModel:userModel];
//            
//            [self.successHUD showAnimated:YES];
//            
//            
//            
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            NSString *countString = [NSString stringWithFormat:@"%@Task.ashx?action=gettaskcount&comid=%ld&uid=%ld&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)userModel.provinceid,userModel.cityid,(long)userModel.districtid];
//            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//            
//            [manager GET:countString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSString *allString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//                NSArray *countList = [allString componentsSeparatedByString:@","];
//                NSLog(@"%@",countList);
//                [[NSUserDefaults standardUserDefaults] setObject:countList forKey:@"countList"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//                [self.successHUD hideAnimated:YES];
//                [self.successHUD removeFromSuperViewOnHide];
//                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"logOut"]) {
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }else{
//                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                    [UIApplication sharedApplication].keyWindow.rootViewController = appDelegate.tabBarController;
//                }
//
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//               
//            }];
//            
//        }else{
//            if ([self.accountTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
//                _nilHUD = [[MBProgressHUD alloc]initWithView:self.view];
//                _nilHUD.mode = MBProgressHUDModeText;
//                _nilHUD.label.text = @"用户名或密码为空";
//                _nilHUD.label.font = font(12);
//                [self.view addSubview:_nilHUD];
//                [self.nilHUD showAnimated:YES];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.nilHUD hideAnimated:YES];
//                    [self.nilHUD removeFromSuperViewOnHide];
//                });
//            }else {
//                _failHUD = [[MBProgressHUD alloc]initWithView:self.view];
//                _failHUD.mode = MBProgressHUDModeText;
//                _failHUD.label.text = @"用户名或密码错误";
//                _failHUD.label.font = font(12);
//                [self.view addSubview:_failHUD];
//                
//                [self.failHUD showAnimated:YES];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.failHUD hideAnimated:YES];
//                    [self.failHUD removeFromSuperViewOnHide];
//                });
//            }
//
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self.HUD hideAnimated:YES];
//        [self.HUD removeFromSuperViewOnHide];
//        MBProgressHUD *noConnectHUD = [[MBProgressHUD alloc]initWithView:self.view];
//        noConnectHUD.mode = MBProgressHUDModeText;
//        noConnectHUD.label.text = @"请检查网络连接";
//        noConnectHUD.label.font = font(14);
//        [self.view addSubview:noConnectHUD];
//        [noConnectHUD showAnimated:YES];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [noConnectHUD hideAnimated:YES];
//            [noConnectHUD removeFromSuperViewOnHide];
//        });
//    }];
    
}

- (void)loginButtonClicked {
    [self.view endEditing:YES];
    [self loginNetWorking];
}

- (void)registerButtonClicked {
    
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    
    UINavigationController *registerNaviController = [[UINavigationController alloc]initWithRootViewController:registerVC];

    [self presentViewController:registerNaviController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate -
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 100) {
        UITextField *nextTextfield = [self.view viewWithTag:101];
        [nextTextfield becomeFirstResponder];
    }else {
        [self.view endEditing:YES];
        [self loginNetWorking];
    }
    return YES;
}



- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow {
    __weak typeof(self)weakSelf = self;
    
    if (iPhone4_4s) {
        [UIView animateWithDuration:0.75 animations:^{
            weakSelf.imageView.alpha = 0;
            weakSelf.loginContainerView.frame = CGRectMake(10, -10, Width - 20, Width - 20);
        }];
    }else if (iPhone5_5s){
        [UIView animateWithDuration:0.75 animations:^{
            weakSelf.imageView.alpha = 0;
            weakSelf.loginContainerView.frame = CGRectMake(10, 50, Width - 20, Width - 20);
        }];
    }

}

- (void)keyboardWillHide {
    __weak typeof(self)weakSelf = self;
    
    if (iPhone6 || iPhone6_plus) {
       
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.imageView.alpha = 1;
            weakSelf.loginContainerView.frame = CGRectMake(10, 155, Width - 20, Width - 20);
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    NSLog(@"LoginViewController Dealloc");
}
@end
