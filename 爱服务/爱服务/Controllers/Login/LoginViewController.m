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
#import "YeeptNetWorkingManager.h"
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
@property (nonatomic, strong) UILabel *label;

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
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    self.imageView.frame = CGRectMake((Width - 200)/2, 60, 200, 43);
    [self.view addSubview:self.imageView];
    
}

- (void)setLoginContainer {

    self.loginContainerView = [[UIView alloc]init];
    self.loginContainerView.backgroundColor = [UIColor whiteColor];
    self.loginContainerView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 80, Width, 180);
    
    self.accountTextField.placeholder = @"请输入帐号";
    self.accountTextField.borderStyle = UITextBorderStyleNone;
    self.accountTextField.returnKeyType = UIReturnKeyNext;
    self.accountTextField.tag = 100;
    self.accountTextField.delegate = self;
    self.accountTextField.clearsOnBeginEditing = YES;
    self.accountTextField.frame = CGRectMake(10, 0, Width - 20, 43);
    UILabel *accountView = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, Width - 20, 0.7)];
    accountView.backgroundColor = color(220, 220, 220, 1);
    
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.borderStyle = UITextBorderStyleNone;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.tag = 101;
    self.passwordTextField.delegate = self;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearsOnBeginEditing = YES;
    self.passwordTextField.frame = CGRectMake(10, 44, Width - 20, 43);
    UILabel *passwordView = [[UILabel alloc] initWithFrame:CGRectMake(10, 87, Width - 20, 0.7)];
    passwordView.backgroundColor = color(220, 220, 220, 1);
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = LoginColor;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(10, 115, Width - 20, 45);
    [loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    loginButton.layer.cornerRadius = 5;
    
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.loginContainerView.frame), Width - 80, 80)];
    self.label.numberOfLines = 0;
    self.label.textColor = color(140, 140, 140, 1);
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.userInteractionEnabled = YES;
    [self.view addSubview:self.label];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"没有爱服务账号?去注册"];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName:LoginColor} range:NSMakeRange(attributeStr.length - 2, 2)];
    self.label.attributedText = attributeStr;
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [registerButton addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    registerButton.frame = self.label.bounds;

    
    [self.loginContainerView addSubview:loginButton];
    [self.label addSubview:registerButton];
    [self.loginContainerView addSubview:self.accountTextField];
    [self.loginContainerView addSubview:accountView];
    [self.loginContainerView addSubview:self.passwordTextField];
    [self.loginContainerView addSubview:passwordView];
    
    [self.view addSubview:self.loginContainerView];

}

- (void)loginNetWorking {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if ([self.accountTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.minSize = CGSizeMake(100, 100);
        hud.label.font = font(14);
        UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.detailsLabel.text = NSLocalizedString(@"用户名或密码\n为空", @"HUD completed title");
        hud.detailsLabel.font = font(14);
        hud.detailsLabel.numberOfLines = 0;
        [hud hideAnimated:YES afterDelay:1.25f];
        [hud removeFromSuperViewOnHide];
        return;
        
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minSize = CGSizeMake(115, 115);
    hud.label.font = font(14);
    
#if Environment_Mode == 1
    NSString *UUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSDictionary *params = @{
                             @"name":self.accountTextField.text,
                             @"password":self.passwordTextField.text,
                             @"imei":UUID
                             };
#elif Environment_Mode == 2
    NSDictionary *params = @{
                             @"name":self.accountTextField.text,
                             @"password":self.passwordTextField.text
                             };
#endif

    NSString *subURL = @"Passport.ashx?action=login";
    
    YeeptNetWorkingManager *manager = [[YeeptNetWorkingManager alloc] init];
    [manager POSTMethodBaseURL:HomeURL path:subURL parameters:params isJSONSerialization:YES progress:nil success:^(id responseObject) {
        
        if (responseObject != nil) {
            
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
            userModel.companyName = responseObject[@"user"][0][@"CompanyName"];
            userModel.masterName = responseObject[@"user"][0][@"MasterName"];
            userModel.userType = responseObject[@"user"][0][@"UserType"];
            [UserModel writeUserModel:userModel];

            YeeptNetWorkingManager *manager = [[YeeptNetWorkingManager alloc] init];

            NSString *subURL = @"Task.ashx?action=gettaskcount";
#if Environment_Mode == 1
            NSDictionary *params = @{
                                     @"comid":@(userModel.comid),
                                     @"uid":@(userModel.uid),
                                     @"provinceid":@(userModel.provinceid),
                                     @"cityid":@(userModel.cityid),
                                     @"districtid":@(userModel.districtid)
                                     };
#elif Environment_Mode == 2
            
            NSDictionary *params = @{
                                     @"comid":@(userModel.comid),
                                     @"uid":@(userModel.uid),
                                     @"provinceid":@(userModel.provinceid),
                                     @"cityid":@(userModel.cityid),
                                     @"districtid":@(userModel.districtid),
                                     @"handler_name":userModel.name
                                     };
#endif

            
            [manager GETMethodBaseURL:HomeURL path:subURL parameters:params isJSONSerialization:NO progress:nil success:^(id responseObject) {
                
                NSString *allString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSArray *countList = [allString componentsSeparatedByString:@","];
                
                [[NSUserDefaults standardUserDefaults] setObject:countList forKey:@"countList"];
                [[NSUserDefaults standardUserDefaults] setObject:self.accountTextField.text forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMoney object:nil];
                if (((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"]).lastObject) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kupdateBadgeNum object:nil];
                }
                
                MBProgressHUD *hud = [MBProgressHUD HUDForView:window];
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"登录成功", @"HUD completed title");
                [hud hideAnimated:YES afterDelay:0.75f];
                [hud removeFromSuperViewOnHide];
                
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"logOut"]) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [UIApplication sharedApplication].keyWindow.rootViewController = appDelegate.tabBarController;
                    }
                });
                
            } failure:^(NSError *error) {
                
                MBProgressHUD *hud = [MBProgressHUD HUDForView:window];
                UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.detailsLabel.text = NSLocalizedString(@"登录失败\n请检查网络", @"HUD completed title");
                hud.detailsLabel.font = font(14);
                hud.detailsLabel.numberOfLines = 0;
                [hud hideAnimated:YES afterDelay:1.25f];
                [hud removeFromSuperViewOnHide];
                
            }];
            
        }else{
            
            MBProgressHUD *hud = [MBProgressHUD HUDForView:window];
            UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.detailsLabel.text = NSLocalizedString(@"用户名或密\n码错误", @"HUD completed title");
            hud.detailsLabel.font = font(14);
            hud.detailsLabel.numberOfLines = 0;
            [hud hideAnimated:YES afterDelay:1.25f];
            [hud removeFromSuperViewOnHide];
            
        }
        
    } failure:^(NSError *error) {
        
        MBProgressHUD *hud = [MBProgressHUD HUDForView:window];
        UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.detailsLabel.text = NSLocalizedString(@"登录失败\n请检查网络", @"HUD completed title");
        hud.detailsLabel.font = font(14);
        hud.detailsLabel.numberOfLines = 0;
        [hud hideAnimated:YES afterDelay:1.25f];
        [hud removeFromSuperViewOnHide];
        
    }];
  
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
    if (iPhone5_5s) {
        [UIView animateWithDuration:0.75 animations:^{
            weakSelf.imageView.frame = CGRectMake((Width - 200)/2, - 45, 200, 43);
            weakSelf.loginContainerView.frame = CGRectMake(0, 100, Width - 20, 180);
            weakSelf.label.frame = CGRectMake(40, 300, Width - 80, 80);
            weakSelf.label.alpha = 0;
            weakSelf.label.userInteractionEnabled = NO;
        }];
    }else if (iPhone4_4s) {
        weakSelf.imageView.frame = CGRectMake((Width - 200)/2, - 45, 200, 43);
        weakSelf.loginContainerView.frame = CGRectMake(0, 30, Width - 20, 180);
        weakSelf.label.frame = CGRectMake(40, 300, Width - 80, 80);
        weakSelf.label.alpha = 0;
        weakSelf.label.userInteractionEnabled = NO;
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.label.alpha = 0;
            weakSelf.label.userInteractionEnabled = NO;
        }];
    }
    
}

- (void)keyboardWillHide {
    __weak typeof(self)weakSelf = self;
    
    if (iPhone5_5s || iPhone4_4s) {
        [UIView animateWithDuration:0.75 animations:^{
            weakSelf.imageView.frame = CGRectMake((Width - 200)/2, 60, 200, 43);
            weakSelf.loginContainerView.frame = CGRectMake(0, 184, Width - 20, 180);
            weakSelf.label.frame = CGRectMake(40, 383, Width - 80, 80);
            weakSelf.label.alpha = 1;
            weakSelf.label.userInteractionEnabled = YES;
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.label.alpha = 1;
            weakSelf.label.userInteractionEnabled = YES;
        }];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)dealloc {
    NSLog(@"LoginViewController Dealloc");
}
@end
