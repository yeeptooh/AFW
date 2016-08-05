//
//  RechargeViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/6/15.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "RechargeViewController.h"
#import "MoneyTableViewCell.h"
#import "PayTableViewCell.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UserModel.h"
#import "WXApi.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

@interface RechargeViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign, getter=isHaveDot) BOOL haveDot;
@property (nonatomic, strong) UIButton *rechargeButton;
@property (nonatomic, strong) MoneyTableViewCell *cell;
@property (nonatomic, assign) NSInteger bitch;
@end

static NSInteger i = 0;
@implementation RechargeViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, 44*4+60) style:UITableViewStyleGrouped];
        
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = color(239, 239, 244, 1);
    [self.view addSubview:self.tableView];
    [self setRechargeButton];
    [self setNaviTitle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCell) name:kReloadCell object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMoney object:nil];
}



- (void)setRechargeButton {
    
    self.rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    self.rechargeButton.layer.cornerRadius = 5;
    self.rechargeButton.layer.masksToBounds = YES;
    [self.rechargeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
    [self.rechargeButton addTarget:self action:@selector(rechargeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.rechargeButton.enabled = NO;
    self.rechargeButton.backgroundColor = color(144, 144, 144, 1);
    
    CGFloat height;
    if (iPhone4_4s || iPhone5_5s) {
        height = 44;
    }else {
        height = 49;
    }
    self.rechargeButton.frame = CGRectMake(40, 44*4+60 + 20, Width - 80, height);
    [self.view addSubview:self.rechargeButton];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.rechargeButton.frame)+20, Width, 40)];
    label.text = @"手机充值,扣除手续费0.6%";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    label.font = font(14);
    label.textColor = color(130, 130, 130, 1);
   
}


- (void)editingChanged:(UITextField *)sender {
    
    if ([sender.text rangeOfString:@"."].location == NSNotFound) {
        
        self.haveDot=NO;
    }

    if ([sender.text isEqualToString:@""] || [sender.text isEqualToString:@"0"] || [sender.text isEqualToString:@"0."]|| [sender.text isEqualToString:@"0.0"] || [sender.text isEqualToString:@"0.00"]) {
        self.rechargeButton.backgroundColor = color(144, 144, 144, 1);
        self.rechargeButton.enabled = NO;

    }
    
    if (sender.text.length > 0) {
        unichar single=[sender.text characterAtIndex:sender.text.length - 1];
        
        if (sender.text.length == 1) {
            self.haveDot = NO;
            if (single == '0') {
                
            }else if (single == '.') {
                sender.text = @"";
                
            }else{
                self.rechargeButton.backgroundColor = CZGreenColor;//BlueColor;//ALiBlueColor;//color(231, 76, 60, 1);
                self.rechargeButton.enabled = YES;

            }
        }
        
        if (sender.text.length == 2) {
            NSString *firstCharacter = [sender.text substringToIndex:1];
           
            if ([firstCharacter isEqualToString:@"0"]) {
                if (single == '0') {
                    sender.text = @"0";
                }else if (single == '.') {
                    self.haveDot = YES;
                }else {
                    sender.text = [NSString stringWithFormat:@"%@",@(single - 48)];
                    self.rechargeButton.backgroundColor = CZGreenColor;//BlueColor;//ALiBlueColor;//color(231, 76, 60, 1);
                    self.rechargeButton.enabled = YES;
                    
                }
            }else {
                if (single == '.') {
                    self.haveDot = YES;
                }
            }
        }
        
        if (sender.text.length == 3) {
            if (self.isHaveDot) {
                if (single == '0') {
                    
                }else if (single == '.') {
                    sender.text = [sender.text substringToIndex:sender.text.length - 1];
                     NSLog(@"%@",sender.text);
                }else {
                    NSString *firstCharacter = [sender.text substringToIndex:1];
                    if ([firstCharacter isEqualToString:@"0"]) {
                        self.rechargeButton.backgroundColor = CZGreenColor;
                        self.rechargeButton.enabled = YES;
                    }else{
                        
                    }
                }
            }else {
                if (single == '.') {
                    self.haveDot = YES;
                }
            }
            
        }
        
        if (sender.text.length == 4) {
            
            if (self.isHaveDot) {
                
                if (single == '.') {
                    sender.text = [sender.text substringToIndex:sender.text.length - 1];
                }else if (single == '0') {
                    
                }else {
                    self.rechargeButton.backgroundColor = CZGreenColor;//BlueColor;//ALiBlueColor;//color(231, 76, 60, 1);
                    self.rechargeButton.enabled = YES;
                }
                
            }else {
                if (single == '.') {
                    self.haveDot = YES;
                }
            }

        }
        
        
        if (sender.text.length == 5) {
            NSUInteger location = [sender.text rangeOfString:@"."].location;
            
            if (self.isHaveDot) {
                if (location == 1) {
                    sender.text = [sender.text substringToIndex:sender.text.length - 1];
                    
                }else if (location == 2) {
                    if (single == '.') {
                        sender.text = [sender.text substringToIndex:sender.text.length - 1];
                    }
                }else {
                    if (single == '.') {
                        sender.text = [sender.text substringToIndex:sender.text.length - 1];
                    }
                }
            }else {
                if (single == '.') {
                    self.haveDot = YES;
                }
            }
        }
        
        if (sender.text.length == 6) {
            NSUInteger location = [sender.text rangeOfString:@"."].location;
            if (self.isHaveDot) {
                if (location == 2) {
                    
                        sender.text = [sender.text substringToIndex:sender.text.length - 1];
                
                }else {
                    if (single == '.') {
                        sender.text = [sender.text substringToIndex:sender.text.length - 1];
                    }

                }
            }else {
                if (single == '.') {
                    self.haveDot = YES;
                }else {
                    sender.text = [sender.text substringToIndex:sender.text.length - 1];
                }
            }
        }
        
        
        if (sender.text.length == 7) {
            NSUInteger location = [sender.text rangeOfString:@"."].location;
            if (self.isHaveDot) {
                if (location == 3) {
                    
                    sender.text = [sender.text substringToIndex:sender.text.length - 1];
                    
                }else {
                    if (single == '.') {
                        sender.text = [sender.text substringToIndex:sender.text.length - 1];
                    }
                    
                }
            }else {
                
            }
        }
        
        if (sender.text.length == 8) {
            NSUInteger location = [sender.text rangeOfString:@"."].location;
            if (self.isHaveDot) {
                if (location == 4) {
                    
                    sender.text = [sender.text substringToIndex:sender.text.length - 1];
                    
                }else {
                    if (single == '.') {
                        sender.text = [sender.text substringToIndex:sender.text.length - 1];
                    }
                    
                }
            }else {
                
            }
        }
        
        
        if (sender.text.length == 9) {
            sender.text = [sender.text substringToIndex:sender.text.length - 1];
        }
    }
}

- (void)rechargeButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    
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
        order.totalFee = [NSString stringWithFormat:@"%@",self.cell.moneyTextField.text];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        UserModel *userModel = [UserModel readUserModel];
        
#if Environment_Mode == 1
        NSString *url = [NSString stringWithFormat:@"%@Payment/Alipay/Recharge.ashx?action=getorderid",HomeURL];
#elif Environment_Mode == 2
        
        NSString *url = [NSString stringWithFormat:@"%@Payment/Alipay/Recharge.ashx?action=getorderid",HomeURL];

#endif
        
        NSDictionary *params = @{
                                 @"title":order.subject,
                                 @"content":order.body,
                                 @"money":order.totalFee,
                                 @"userId":@(userModel.comid)
                                 };
//        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *json = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([json[@"status"] isEqualToString:@"ok"]) {
#if Environment_Mode == 1
                order.notifyURL = @"http://i.51ifw.com/forapp/payment/alipay/notify.aspx";//支付宝服务器异步通知自己服务器回调的URL
#elif Environment_Mode == 2
                order.notifyURL = @"http://i.51ifw.com/forapp2/payment/alipay/notify.aspx";//支付宝服务器异步通知自己服务器回调的URL
#endif
                
                order.outTradeNO = json[@"data"];
                [[NSUserDefaults standardUserDefaults] setObject:order.outTradeNO forKey:@"outTradeNO"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                order.service = @"mobile.securitypay.pay";
                order.paymentType = @"1";

                order.inputCharset = @"utf-8";
                order.itBPay = @"30m";

#if Environment_Mode == 1
                NSString *appScheme = @"aifuwu";
#elif Environment_Mode == 2
                NSString *appScheme = @"aifuwuCS";
#endif
                //将商品信息拼接成字符串
                NSString *orderSpec = [order description];
                
                //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//                id<DataSigner> signer = CreateRSADataSigner(myPrivateKey);
//                
//                NSString *signedString = [signer signString:orderSpec];
//
//                NSLog(@"signedString1 = %@",signedString);
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
#if Environment_Mode == 1
                NSString *url = [NSString stringWithFormat:@"%@Payment/Alipay/Recharge.ashx?action=getsign&orderId=%@",HomeURL,order.outTradeNO];
#elif Environment_Mode == 2
                NSString *url = [NSString stringWithFormat:@"%@Payment/Alipay/Recharge.ashx?action=getsign&orderId=%@",HomeURL,order.outTradeNO];

#endif
                
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *json = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    
                    if ([json[@"status"] isEqualToString:@"ok"]) {
                        
                        NSString *signedString = json[@"data"];
                        
                        NSString *signerStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, /* allocator */(__bridge CFStringRef)signedString, NULL, /* charactersToLeaveUnescaped */(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);

                        NSString *orderString = nil;
                        if (signedString != nil) {
                            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signerStr, @"RSA"];
                            
                            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                                    [self updateResponse:order.outTradeNO];
                            }];
                        }
                    }

                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                }];

            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
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
    }
    
    if (i == 2) {
        
        NSString *totalFee = [NSString stringWithFormat:@"%@",self.cell.moneyTextField.text];
        NSString *ipAddress = [self getIPAddress];
        UserModel *userModel = [UserModel readUserModel];
        //userid  money  ip
#if Environment_Mode == 1
        NSString *urlString   = [NSString stringWithFormat:@"%@Payment/WeiXin/Recharge.ashx?action=getwxpayment&userid=%@&money=%@&ip=%@",HomeURL,@(userModel.comid),totalFee,ipAddress];
#elif Environment_Mode == 2
        NSString *urlString   = [NSString stringWithFormat:@"%@Payment/WeiXin/Recharge.ashx?action=getwxpayment&userid=%@&money=%@&ip=%@",HomeURL,@(userModel.comid),totalFee,ipAddress];
#endif

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            if ([responseObject[@"status"] isEqualToString:@"ok"]) {
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"orderid"] forKey:@"WXOrderID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                PayReq *payReq = [[PayReq alloc] init];
                
                payReq.prepayId = responseObject[@"data"][@"prepayid"];
#if Environment_Mode == 1
                payReq.partnerId = @"1357569202";
#elif Environment_Mode == 2
                payReq.partnerId = @"1364622402";
#endif
                payReq.nonceStr = responseObject[@"data"][@"noncestr"];
                payReq.timeStamp = [responseObject[@"data"][@"timestamp"] intValue];
                payReq.package = @"Sign=WXPay";
                payReq.sign = responseObject[@"data"][@"sign"];
                [WXApi sendReq:payReq];
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

- (NSString *)getIPAddress {
    
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
#if Environment_Mode == 1
    NSString *url = [NSString stringWithFormat:@"%@/Payment/Alipay/Recharge.ashx?action=getorderstate&orderid=%@",HomeURL,orderID];
#elif Environment_Mode == 2
    NSString *url = [NSString stringWithFormat:@"%@/Payment/Alipay/Recharge.ashx?action=getorderstate&orderid=%@",HomeURL,orderID];
#endif
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"data"] integerValue] ==  5) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.label.text = @"充值中..";
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
                hud.label.text = NSLocalizedString(@"充值成功", @"HUD completed title");
                [hud hideAnimated:YES afterDelay:0.75f];
                [hud removeFromSuperViewOnHide];
                
            });
            
        }
        
        if ([responseObject[@"data"] integerValue] == 1) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.label.text = @"充值中..";
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
                hud.label.text = NSLocalizedString(@"充值失败", @"HUD completed title");
                [hud hideAnimated:YES afterDelay:0.75f];
                [hud removeFromSuperViewOnHide];
            });
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.label.text = @"充值中..";
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




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UserModel *userModel = [UserModel readUserModel];
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = [NSString stringWithFormat:@"当前账户可用余额:%.02f元",userModel.money];
            cell.textLabel.font = font(14);
            cell.textLabel.textColor = color(130, 130, 130, 1);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            self.cell = [[[NSBundle mainBundle] loadNibNamed:@"MoneyTableViewCell" owner:self options:nil] lastObject];
            self.cell.moneyTextField.delegate = self;
            self.cell.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
            [self.cell.moneyTextField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
            
            self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.cell;
        }
    }else {
        PayTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:self options:nil]lastObject];
        
        if (indexPath.row == 0) {
            cell.payLabel.text = @"支付宝钱包支付";
            cell.payImageView.image = [UIImage imageNamed:@"alipay"];
            cell.chooseImageView.image = [UIImage imageNamed:@"unchecked"];
        }else {
            cell.payLabel.text = @"微信客户端支付";
            cell.payImageView.image = [UIImage imageNamed:@"WXPay"];
            cell.chooseImageView.image = [UIImage imageNamed:@"unchecked"];
        }
        
        return cell;
    }

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else {
            MoneyTableViewCell *cell = (MoneyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell.moneyTextField becomeFirstResponder];
        }
    }else {
        [self.view endEditing:YES];
        if (indexPath.row == 0) {
            
            i = 1;
            
            PayTableViewCell *cell1 = (PayTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell1.chooseImageView.image = [UIImage imageNamed:@"success"];
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:1];
            PayTableViewCell *cell2 = (PayTableViewCell *)[tableView cellForRowAtIndexPath:indexpath];
            cell2.chooseImageView.image = [UIImage imageNamed:@"unchecked"];
 
            
        }else {
            
            i = 2;
            
            PayTableViewCell *cell1 = (PayTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell1.chooseImageView.image = [UIImage imageNamed:@"success"];
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:1];
            PayTableViewCell *cell2 = (PayTableViewCell *)[tableView cellForRowAtIndexPath:indexpath];
            cell2.chooseImageView.image = [UIImage imageNamed:@"unchecked"];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat height;
    if (section == 0) {
        height = 20;
    }else {
        height = 40;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color(239, 239, 244, 1);
    button.frame = CGRectMake(0, 0, Width, height);
    if (section == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Width, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"选择支付方式";
        label.font = font(14);
        [button addSubview:label];
        
    }
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)buttonClicked:(UIButton *)sender {
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


- (void)setNaviTitle {
    self.navigationItem.title = @"我要充值";
}

- (void)reloadCell {
#if Environment_Mode == 1
    NSDictionary *params = @{
                             @"name":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
                             @"password":[[NSUserDefaults standardUserDefaults] objectForKey:@"password"],
                             @"imei":@"1"
                             };
#elif Environment_Mode == 2
    NSDictionary *params = @{
                             @"name":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
                             @"password":[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]
                             };
#endif
    
    NSString *URL = [NSString stringWithFormat:@"%@Passport.ashx?action=login",HomeURL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    
    [manager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject != nil) {
            
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
        }
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



- (void)dealloc {
    i = 0;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
