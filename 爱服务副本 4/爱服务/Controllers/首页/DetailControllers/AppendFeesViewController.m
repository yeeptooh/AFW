//
//  AppendFeesViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "AppendFeesViewController.h"
#import "UserModel.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "CompleteViewController.h"
@interface AppendFeesViewController ()
<
UIWebViewDelegate
>
@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) MBProgressHUD *errorHUD;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) UIButton *chooseButton;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *product;
@property (nonatomic, strong) NSString *price;

@end

@implementation AppendFeesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addKeyBoardNotification];
    [self setView];
    [self setWebView];
    [self setNaviTitle];
}

- (void)setView {
    self.view.backgroundColor = color(241, 241, 241, 1);
    NSArray *labelList = @[
                           @"工单号",
                           @"客户姓名",
                           @"地址",
                           @"产品",
                           @"已付金额",
                           @"追加金额",
                           @"追加理由"
                          ];
    for (NSInteger i = 0; i < 7; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5 + ((Height - StatusBarAndNavigationBarHeight)*i/12), Width/4, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
        
        label.text = labelList[i];
        CGFloat fontsize;
        if (iPhone6_plus || iPhone6) {
            fontsize = 16;
        }else{
            fontsize = 14;
        }
        label.font = [UIFont systemFontOfSize:fontsize];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor blackColor];
        [self.view addSubview:label];
    }
    
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (!_ID) {
        [self.chooseButton setTitle:@"请先选择工单" forState:UIControlStateNormal];
    }else{
        [self.chooseButton setTitle:_ID forState:UIControlStateNormal];
    }
    CGFloat fontsize;
    if (iPhone4_4s || iPhone5_5s) {
        fontsize = 14;
    }else{
        fontsize = 16;
    }
    self.chooseButton.titleLabel.font = font(fontsize);
    [self.chooseButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
    [self.chooseButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseButton.layer.cornerRadius = 5;
    self.chooseButton.layer.masksToBounds = YES;
    self.chooseButton.tag = 500;
    self.chooseButton.backgroundColor = [UIColor whiteColor];
    self.chooseButton.frame = CGRectMake(Width*5/16, 5, Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10);
    [self.view addSubview:self.chooseButton];
    
    for (NSInteger i = 0; i < 4; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(Width*5/16, 5 + ((Height - StatusBarAndNavigationBarHeight)*(i + 1)/12), Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
        label.backgroundColor = [UIColor whiteColor];
        label.font = font(fontsize);
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.tag = 700 + i;
        if (i == 0) {
            label.text = _name;
        }else if (i == 1) {
            label.text = _address;
        }else if (i == 2) {
            label.text = _product;
        }else{
            label.text = _price;
        }
        [self.view addSubview:label];
    }
    
    
    for (NSInteger i = 0; i < 2; i ++) {
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(Width*5/16, 5 + ((Height - StatusBarAndNavigationBarHeight)*(i+5)/12), Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.font = font(fontsize);
        textfield.layer.cornerRadius = 5;
        textfield.layer.masksToBounds = YES;
        
        textfield.tag = 1000 + i;
        [self.view addSubview: textfield];
    }
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    
    [submit setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    submit.layer.cornerRadius = 5;
    submit.layer.masksToBounds = YES;
    submit.backgroundColor = color(23, 133, 255, 1);
    submit.frame = CGRectMake(30, 5 + ((Height - StatusBarAndNavigationBarHeight)*7/12), Width - 60, (Height - StatusBarAndNavigationBarHeight)/12 - 10);
    [self.view addSubview:submit];
    
    
}

- (void)submitClicked:(UIButton *)sender {
    if ([self.chooseButton.titleLabel.text isEqualToString:@"请先选择工单"]) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
        HUD.mode = MBProgressHUDModeText;
        HUD.label.text = @"请先选择工单";
        HUD.label.font = font(14);
        [self.view addSubview:HUD];
        [HUD showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
            [HUD removeFromSuperViewOnHide];
        });
        
        return;
    }
    
    if ([((UITextField *)[self.view viewWithTag:1000]).text isEqualToString:@""]) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
        
        HUD.mode = MBProgressHUDModeText;
        HUD.label.text = @"请填写追加费用";
        CGFloat fontsize;
        if (iPhone4_4s || iPhone5_5s) {
            fontsize = 14;
        }else{
            fontsize = 16;
        }
        HUD.label.font = font(fontsize);
        [self.view addSubview:HUD];
        [HUD showAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
            [HUD removeFromSuperViewOnHide];
        });
        return;
        
    }
    
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:HUD];
    [HUD showAnimated:YES];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 5;
    NSString *URL = [NSString stringWithFormat:@"%@apply.ashx?action=addmoney",HomeURL];
    
    NSDictionary *params = @{
                             @"taskid":_ID,
                             @"money":((UITextField *)[self.view viewWithTag:1000]).text,
                             @"remarks":((UITextField *)[self.view viewWithTag:1001]).text
                             };
    
    __weak typeof(self)weakSelf = self;
    
    [manager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseObject = %@",str);
        [HUD hideAnimated:YES];
        [HUD removeFromSuperViewOnHide];
        MBProgressHUD *successHUD = [[MBProgressHUD alloc]initWithView:self.view];
        successHUD.mode = MBProgressHUDModeText;
        successHUD.label.font = font(14);
        successHUD.label.text = @"提交成功";
        [weakSelf.view addSubview:successHUD];
        
        [successHUD showAnimated:YES];
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [successHUD hideAnimated:YES];
            [successHUD removeFromSuperViewOnHide];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error = %@",error.userInfo);
        [HUD hideAnimated:YES];
        [HUD removeFromSuperViewOnHide];
        MBProgressHUD *errorHUD = [[MBProgressHUD alloc]initWithView:self.view];
        errorHUD.mode = MBProgressHUDModeText;
        errorHUD.label.font = font(14);
        errorHUD.label.text = @"提交失败";
        [weakSelf.view addSubview:errorHUD];
        
        [errorHUD showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [errorHUD hideAnimated:YES];
            [errorHUD removeFromSuperViewOnHide];
            
        });
    }];
    
    
}



- (void)chooseButtonClicked:(UIButton *)sender {
    CompleteViewController *cpVC = [[CompleteViewController alloc]init];
    cpVC.returnAppend = ^(NSString *taskID, NSString *name, NSString *address, NSString *product, NSString *price) {
        
        _ID = taskID;
        UIButton *button = [self.view viewWithTag:500];
        
        [button setTitle:_ID forState:UIControlStateNormal];
        
        UILabel *label1 = [self.view viewWithTag:700];
        label1.text = name;
        UILabel *label2 = [self.view viewWithTag:701];
        label2.text = address;
        UILabel *label3 = [self.view viewWithTag:702];
        label3.text = product;
        UILabel *label4 = [self.view viewWithTag:703];
        label4.text = price;
        _name = name;
        _address = address;
        _product = product;
        _price = price;
        
        
        
    };
    
    [self.navigationController pushViewController:cpVC animated:YES];
    
}

- (void)setWebView {
    
    UserModel *userModel = [UserModel readUserModel];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(20, 10 + (Height - StatusBarAndNavigationBarHeight)*8/12, Width - 40, Height - StatusBarAndNavigationBarHeight - (Height - StatusBarAndNavigationBarHeight)*8/12 - 10)];
    self.HUD = [[MBProgressHUD alloc]initWithView:self.webView];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.webView addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    self.webView.delegate = self;
    
    self.errorHUD = [[MBProgressHUD alloc]initWithView:self.webView];
    self.errorHUD.mode = MBProgressHUDModeText;
    self.errorHUD.label.text = @"请检查网络连接";
    self.errorHUD.label.font = font(12);
    [self.webView addSubview:self.errorHUD];
    
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@page.aspx?type=addmoney&uid=%ld",HomeURL,(long)userModel.uid]]]];
    
    [self.view addSubview:self.webView];
}


#pragma mark - UIWebViewDelegate -
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.HUD hideAnimated:YES];
    [self.HUD removeFromSuperViewOnHide];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.HUD hideAnimated:YES];
    [self.HUD removeFromSuperViewOnHide];
    [self.errorHUD showAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.errorHUD hideAnimated:YES];
        [self.errorHUD removeFromSuperViewOnHide];
    });
    
}


- (void)setNaviTitle {
    self.navigationItem.title = @"追加费用";
}

- (void)keyBoardWillShow {
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    self.tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.tap];
}

- (void)keyBoardWillHide {
    [self.view removeGestureRecognizer:self.tap];
}

- (void)tap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)addKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

@end
