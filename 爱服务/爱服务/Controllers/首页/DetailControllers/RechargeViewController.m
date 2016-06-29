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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, 44*3+60) style:UITableViewStyleGrouped];
        
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.backgroundColor = [UIColor whiteColor];
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMoney:) name:kUpdateMoney object:nil];
    
}

- (void)updateMoney:(NSNotification *)noti {
    
    [self.navigationController popViewControllerAnimated:YES];
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
    self.rechargeButton.frame = CGRectMake(40, 44*3+60 + 20, Width - 80, height);
    [self.view addSubview:self.rechargeButton];

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
                self.rechargeButton.backgroundColor = color(231, 76, 60, 1);
                self.rechargeButton.enabled = YES;

            }
        }
        
        if (sender.text.length == 2) {
            NSString *firstCharacter = [sender.text substringToIndex:1];
           
            NSLog(@"firstCharacter = %@",firstCharacter);
            if ([firstCharacter isEqualToString:@"0"]) {
                if (single == '0') {
                    sender.text = @"0";
                }else if (single == '.') {
                    self.haveDot = YES;
                }else {
                    sender.text = [NSString stringWithFormat:@"%@",@(single - 48)];
                    self.rechargeButton.backgroundColor = color(231, 76, 60, 1);
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
                        self.rechargeButton.backgroundColor = color(231, 76, 60, 1);
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
                    self.rechargeButton.backgroundColor = color(231, 76, 60, 1);
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
        
        NSString *url = [NSString stringWithFormat:@"%@Payment/Alipay/Recharge.ashx?action=getorderid",HomeURL];
//        NSString *url = [NSString stringWithFormat:@"%@Payment/Alipay/Recharge.ashx?action=getorderid",@"http://192.168.1.173:90/forapp/"];
        NSDictionary *params = @{
                                 @"title":order.subject,
                                 @"content":order.body,
                                 @"money":order.totalFee,
                                 @"userId":@(userModel.comid)
                                 };
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
//                order.goodsType = @"0";
                order.inputCharset = @"utf-8";
                order.itBPay = @"30m";
//                order.return_url = @"m.alipay.com";
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
                
                NSString *url = [NSString stringWithFormat:@"%@Payment/Alipay/Recharge.ashx?action=getsign&orderId=%@",HomeURL,order.outTradeNO];
//                NSString *url = [NSString stringWithFormat:@"%@Payment/Alipay/Recharge.ashx?action=getsign&orderId=%@",@"http://192.168.1.173:90/forapp/",order.outTradeNO];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *json = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                    
                    if ([json[@"status"] isEqualToString:@"ok"]) {
                        
                        NSString *signedString = json[@"data"];
                        NSLog(@"signedString = %@",signedString);
                        NSString *signerStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, /* allocator */(__bridge CFStringRef)signedString, NULL, /* charactersToLeaveUnescaped */(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);

                        NSString *orderString = nil;
                        
                        
                        if (signedString != nil) {
                            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signerStr, @"RSA"];
                            
                            
                            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                                self.bitch = 0;
                                if (self.bitch < 3) {
                                    [self updateResponse:order];
                                }
                                
                            }];
                        }
                    }

                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"error.userInfo = %@",error.userInfo);
                }];

            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.userInfo);
//            [hud hideAnimated:YES];
//            [hud removeFromSuperViewOnHide];
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
        NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            PayReq *payReq = [[PayReq alloc] init];
            
            payReq.partnerId           = [responseObject objectForKey:@"partnerid"];
//            NSLog(@"req.partnerId = %@",req.partnerId);
            
            payReq.prepayId            = [responseObject objectForKey:@"prepayid"];
            payReq.nonceStr            = [responseObject objectForKey:@"noncestr"];
            payReq.timeStamp           = [[responseObject objectForKey:@"timestamp"] intValue];
            payReq.package             = [responseObject objectForKey:@"package"];
            payReq.sign                = [responseObject objectForKey:@"sign"];
            
            [WXApi sendReq:payReq];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
        
    }
    
    
    
}

- (void)updateResponse:(Order *)order {
    self.bitch ++;
    __block BOOL flag = NO;
    
    dispatch_group_t group = dispatch_group_create();
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSString *url = [NSString stringWithFormat:@"%@/Payment/Alipay/Recharge.ashx?action=getorderstate&orderid=%@",@"http://192.168.1.173:90/forapp",order.outTradeNO];
    NSString *url = [NSString stringWithFormat:@"%@/Payment/Alipay/Recharge.ashx?action=getorderstate&orderid=%@",HomeURL,order.outTradeNO];
    dispatch_group_enter(group);
    
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        UIView *window = [[UIApplication sharedApplication].delegate window];
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"data"] integerValue] ==  5) {
            flag = YES;
            
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
            hud.mode = MBProgressHUDModeCustomView;
            [window addSubview:hud];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 74, 74)];
            imageView.image = [UIImage imageNamed:@"icon_joblist_loading"];
            hud.customView = imageView;
            
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            animation.toValue = @(M_PI*2);
            animation.duration = 1.25;
            [hud.customView.layer addAnimation:animation forKey:nil];
            
            
            [hud showAnimated:YES];
            
            hud.offset = CGPointMake(0, Height/5);
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 74, 74)];
                imageView.image = [UIImage imageNamed:@"icon_jd_sendSucess"];
                hud.customView = imageView;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    [hud removeFromSuperViewOnHide];
                    dispatch_group_leave(group);
                });
                
            });
            
        }else {
            if (self.bitch == 3) {
                flag = YES;
                UIView *window = [[UIApplication sharedApplication].delegate window];
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"支付取消";
                CGFloat fontsize;
                if (iPhone4_4s || iPhone5_5s) {
                    fontsize = 14;
                }else {
                    fontsize = 16;
                }
                hud.label.font = font(fontsize);
                [window addSubview:hud];
                [hud showAnimated:YES];
                hud.offset = CGPointMake(0, Height/5);
                [hud hideAnimated:YES afterDelay:1.25];
                [hud removeFromSuperViewOnHide];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_group_leave(group);
                });
            }

        }
//        if ([responseObject[@"data"] integerValue] == 1) {
//            flag = YES;
//            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = @"支付取消";
//            CGFloat fontsize;
//            if (iPhone4_4s || iPhone5_5s) {
//                fontsize = 14;
//            }else {
//                fontsize = 16;
//            }
//            hud.label.font = font(fontsize);
//            [window addSubview:hud];
//            [hud showAnimated:YES];
//            hud.offset = CGPointMake(0, Height/5);
//            [hud hideAnimated:YES afterDelay:1.25];
//            [hud removeFromSuperViewOnHide];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                dispatch_group_leave(group);
//            });
//            
//        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_group_leave(group);
        NSLog(@"error.userInfo = %@",error.userInfo);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (flag) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMoney object:nil];
            self.bitch = 3;
        }else {
            [self updateResponse:order];
        }
        
    });
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        self.cell = [[[NSBundle mainBundle] loadNibNamed:@"MoneyTableViewCell" owner:self options:nil] lastObject];
        self.cell.moneyTextField.delegate = self;
        self.cell.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [self.cell.moneyTextField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
        
        self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.cell;
    }else {
        PayTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:self options:nil]lastObject];
        
        if (indexPath.row == 0) {
            cell.payLabel.text = @"支付宝钱包支付";
            cell.payImageView.image = [UIImage imageNamed:@"alipay"];
            cell.chooseImageView.image = [UIImage imageNamed:@"rate_annoy_button_normal"];
        }else {
            cell.payLabel.text = @"微信客户端支付";
            cell.payImageView.image = [UIImage imageNamed:@"WXPay"];
            cell.chooseImageView.image = [UIImage imageNamed:@"rate_annoy_button_normal"];
        }
        
        return cell;
    }

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        MoneyTableViewCell *cell = (MoneyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.moneyTextField becomeFirstResponder];
    }else {
        [self.view endEditing:YES];
        if (indexPath.row == 0) {
            
            i = 1;
            
            PayTableViewCell *cell1 = (PayTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell1.chooseImageView.image = [UIImage imageNamed:@"rate_annoy_button_selected"];
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:1];
            PayTableViewCell *cell2 = (PayTableViewCell *)[tableView cellForRowAtIndexPath:indexpath];
            cell2.chooseImageView.image = [UIImage imageNamed:@"rate_annoy_button_normal"];
 
            
        }else {
            
            i = 2;
            
            PayTableViewCell *cell1 = (PayTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell1.chooseImageView.image = [UIImage imageNamed:@"rate_annoy_button_selected"];
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:1];
            PayTableViewCell *cell2 = (PayTableViewCell *)[tableView cellForRowAtIndexPath:indexpath];
            cell2.chooseImageView.image = [UIImage imageNamed:@"rate_annoy_button_normal"];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
