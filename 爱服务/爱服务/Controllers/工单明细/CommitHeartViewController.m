//
//  CommitHeartViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/7/12.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "CommitHeartViewController.h"
#import "HYBModalTransition.h"
#import "AFNetworking.h"
#import "UserModel.h"
#import "PayTableViewCell.h"
#import "MBProgressHUD.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface CommitHeartViewController ()
<
UIViewControllerTransitioningDelegate
>
@property (nonatomic, strong) PayTableViewCell *cell1;
@property (nonatomic, strong) PayTableViewCell *cell2;
@end
static NSInteger i = 0;
@implementation CommitHeartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width, 50)];
    label.text = @"支付方式";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font(18);
    label.textColor = [UIColor blackColor];
    [headerView addSubview:label];
    
//    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width, 0.6)];
//    lineLabel.backgroundColor = [UIColor lightGrayColor];
//    [headerView addSubview:lineLabel];
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 49.4, Width - 40, 0.6)];
    lineLabel1.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lineLabel1];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(10, 11, 28, 28);
    [cancelButton setImage:[UIImage imageNamed:@"icon_login_close_pre"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancelButton];
    
    [self.view addSubview:headerView];
    
    self.cell1 = [[[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:self options:nil]lastObject];
    self.cell1.payLabel.text = @"支付宝钱包支付";
    self.cell1.payImageView.image = [UIImage imageNamed:@"alipay"];
    self.cell1.chooseImageView.image = [UIImage imageNamed:@"unchecked"];
    self.cell1.frame = CGRectMake(0, 50, Width, 44);
    
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 94, Width - 40, 0.6)];
    lineLabel2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineLabel2];
    
    
    UIButton *ALiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ALiButton.frame = self.cell1.bounds;
    [ALiButton addTarget:self action:@selector(aliButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.cell1 addSubview:ALiButton];
    
    
    
    self.cell2 = [[[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:self options:nil]lastObject];
    self.cell2.payLabel.text = @"微信客户端支付";
    self.cell2.payImageView.image = [UIImage imageNamed:@"WXPay"];
    self.cell2.chooseImageView.image = [UIImage imageNamed:@"unchecked"];
    self.cell2.frame = CGRectMake(0, 95, Width, 44);
    UILabel *lineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 139, Width - 40, 0.6)];
    lineLabel3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineLabel3];
    
    UIButton *WXButton = [UIButton buttonWithType:UIButtonTypeCustom];
    WXButton.frame = self.cell2.bounds;
    [WXButton addTarget:self action:@selector(wxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.cell2 addSubview:WXButton];
    
    
    [self.view addSubview:self.cell1];
    [self.view addSubview:self.cell2];
    
    UILabel *moneyLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, Width/2 - 20, 50)];
    moneyLabel1.text = [NSString stringWithFormat:@"需支付:"];
    moneyLabel1.font  = font(16);
    moneyLabel1.textColor = [UIColor lightGrayColor];
    moneyLabel1.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:moneyLabel1];
    
    UILabel *moneyLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(Width/2, 150, Width/2 - 20, 50)];
    moneyLabel2.text = [NSString stringWithFormat:@"%@元",self.money];
    moneyLabel2.font  = font(16);
    moneyLabel2.textColor = [UIColor lightGrayColor];
    moneyLabel2.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:moneyLabel2];
    
    CGFloat height;
    if (iPhone4_4s || iPhone5_5s) {
        height = 44;
    }else {
        height = 49;
    }
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(40, 300, Width - 80, height);
    [payButton setTitle:@"支付" forState:UIControlStateNormal];
    
    [payButton addTarget:self action:@selector(payButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    payButton.layer.cornerRadius = 5;
    payButton.layer.masksToBounds = YES;
    payButton.backgroundColor = ALiBlueColor;
    
    [self.view addSubview:payButton];
    
}

- (void)payButtonClicked {
    if (i == 0) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = @"请选择支付方式";
        CGFloat fontsize;
        if (iPhone4_4s || iPhone5_5s) {
            fontsize = 14;
        }else {
            fontsize = 16;
        }
        hud.label.font = font(fontsize);
        [self.view addSubview:hud];
        
        [hud showAnimated:YES];
        
        [hud hideAnimated:YES afterDelay:0.75];
        
        return;
    }
    
    if (i == 1) {
        
        Order *order = [[Order alloc] init];
        order.partner = myPartner;
        order.sellerID = mySeller;
        
        order.subject = @"账户充值";
        order.body = @"账户充值";
        
        order.totalFee = [NSString stringWithFormat:@"%@",self.money];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        UserModel *userModel = [UserModel readUserModel];
        NSString *url = [NSString stringWithFormat:@"%@Payment/Alipay/Recharge.ashx?action=getorderid",HomeURL];
        NSDictionary *params = @{
                                 @"title":order.subject,
                                 @"content":order.body,
                                 @"money":order.totalFee,
                                 @"userId":@(userModel.comid)
                                 };
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            NSDictionary *json = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([json[@"status"] isEqualToString:@"ok"]) {
                order.notifyURL = @"http://i.51ifw.com/forapp/payment/alipay/notify.aspx";//支付宝服务器异步通知自己服务器回调的URL

                order.outTradeNO = json[@"data"];
                [[NSUserDefaults standardUserDefaults] setObject:order.outTradeNO forKey:@"outTradeNO"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                order.service = @"mobile.securitypay.pay";
                order.paymentType = @"1";
                
                order.inputCharset = @"utf-8";
                order.itBPay = @"30m";
                
                NSString *appScheme = @"aifuwu";

                //将商品信息拼接成字符串
                NSString *orderSpec = [order description];
                
                //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
                //                id<DataSigner> signer = CreateRSADataSigner(myPrivateKey);
                //
                //                NSString *signedString = [signer signString:orderSpec];
                //
                //                NSLog(@"signedString1 = %@",signedString);
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                

                NSString *url = [NSString stringWithFormat:@"%@Payment/Alipay/Recharge.ashx?action=getsign&orderId=%@",HomeURL,order.outTradeNO];

                
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *json = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    
                    if ([json[@"status"] isEqualToString:@"ok"]) {
                        
                        NSString *signedString = json[@"data"];
                        NSLog(@"signedString = %@",signedString);
                        NSString *signerStr = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, /* allocator */(__bridge CFStringRef)signedString, NULL, /* charactersToLeaveUnescaped */(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
                        
                        NSString *orderString = nil;
                        NSLog(@"signerStr = %@",signerStr);
                        
                        if (signedString != nil) {
                            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signerStr, @"RSA"];
                            
                            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                                [self updateResponse:order.outTradeNO];
                            }];
                        }
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"error.userInfo = %@",error.userInfo);
                }];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.userInfo);
            
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            HUD.mode = MBProgressHUDModeText;
            
            HUD.label.text = @"请检查网络";
            CGFloat fontsize;
            if (iPhone4_4s || iPhone5_5s) {
                fontsize = 14;
            }else {
                fontsize = 16;
            }
            HUD.label.font = font(fontsize);
            [self.view addSubview:HUD];
            
            [HUD showAnimated:YES];
            
            [HUD hideAnimated:YES afterDelay:0.75];
            
        }];
        
        
    }else if (i == 2) {
        NSString *totalFee = [NSString stringWithFormat:@"%@",self.money];
        NSString *ipAddress = [self getIPAddress];
        UserModel *userModel = [UserModel readUserModel];
        //userid  money  ip
        NSString *urlString   = [NSString stringWithFormat:@"%@Payment/WeiXin/Recharge.ashx?action=getwxpayment&userid=%@&money=%@&ip=%@",HomeURL,@(userModel.comid),totalFee,ipAddress];
        NSLog(@"%@",urlString);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            
            if ([responseObject[@"status"] isEqualToString:@"ok"]) {
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"orderid"] forKey:@"WXOrderID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                PayReq *payReq = [[PayReq alloc] init];
                
                payReq.prepayId = responseObject[@"data"][@"prepayid"];
                payReq.partnerId = @"1357569202";
                payReq.nonceStr = responseObject[@"data"][@"noncestr"];
                payReq.timeStamp = [responseObject[@"data"][@"timestamp"] intValue];
                payReq.package = @"Sign=WXPay";
                payReq.sign = responseObject[@"data"][@"sign"];
                [WXApi sendReq:payReq];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.userInfo);
        }];
    }
 
    
}

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

- (void)updateResponse:(NSString *)orderID {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSString *url = [NSString stringWithFormat:@"%@/Payment/Alipay/Recharge.ashx?action=getorderstate&orderid=%@",HomeURL,orderID];

    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"data"] integerValue] ==  5) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.label.text = @"付款中..";
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.minSize = CGSizeMake(100, 100);
            hud.offset = CGPointMake(0, Height/5);
            hud.label.font = font(14);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"付款成功", @"HUD completed title");
                [hud hideAnimated:YES afterDelay:0.75f];
                [hud removeFromSuperViewOnHide];
                
            });
            
        }
        
        if ([responseObject[@"data"] integerValue] == 1) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.label.text = @"付款中..";
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.minSize = CGSizeMake(100, 100);
            hud.offset = CGPointMake(0, Height/5);
            hud.label.font = font(14);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"付款失败", @"HUD completed title");
                [hud hideAnimated:YES afterDelay:0.75f];
                [hud removeFromSuperViewOnHide];
            });
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.label.text = @"付款中..";
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.minSize = CGSizeMake(100, 100);
        hud.offset = CGPointMake(0, Height/5);
        hud.label.font = font(14);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
            UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = NSLocalizedString(@"网络异常", @"HUD completed title");
            [hud hideAnimated:YES afterDelay:0.75f];
            [hud removeFromSuperViewOnHide];
            
        });
    }];
}



- (void)cancelButtonClicked {
    i = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)aliButtonClicked:(UIButton *)sender {
    i = 1;
    self.cell1.chooseImageView.image = [UIImage imageNamed:@"success"];
    self.cell2.chooseImageView.image = [UIImage imageNamed:@"unchecked"];
}

- (void)wxButtonClicked:(UIButton *)sender {
    i = 2;
    self.cell2.chooseImageView.image = [UIImage imageNamed:@"success"];
    self.cell1.chooseImageView.image = [UIImage imageNamed:@"unchecked"];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [HYBModalTransition transitionWithType:kHYBModalTransitionPresent duration:0.25 presentHeight:350 scale:CGPointMake(0.9, 0.9)];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [HYBModalTransition transitionWithType:kHYBModalTransitionDismiss duration:0.25 presentHeight:350 scale:CGPointMake(0.9, 0.9)];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
