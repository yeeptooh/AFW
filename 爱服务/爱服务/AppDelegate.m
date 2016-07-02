//
//  AppDelegate.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/9.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UserModel.h"

#import "LoginViewController.h"

#import "HomeViewController.h"
#import "ReceiveViewController.h"
#import "CompleteViewController.h"
#import "RobViewController.h"
#import "AllOrderViewController.h"

#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "JPUSHService.h"
#import <AdSupport/ASIdentifierManager.h>

#import <AlipaySDK/AlipaySDK.h>

#import "MBProgressHUD.h"

@interface AppDelegate ()

<
WeiboSDKDelegate,
WXApiDelegate,
TencentApiInterfaceDelegate
>

@property (nonatomic, assign) NSInteger bitch;
@end
static NSString *jPushAppKey = @"832a598bcc7101ce08f1168d";
static NSString *channel = @"App Store";
static BOOL isProduction = FALSE;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UINavigationBar appearance].barTintColor = color(30, 30, 30, 1);
    [UINavigationBar appearance].tintColor = color(245, 245, 245, 1);
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} ];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hadLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstLaunch"];
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLaunch"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hadLaunched"];
    }
    
    
    
    
    

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.tabBarController = [[MyTabBarController alloc]init];
    UINavigationController *homeNaviController = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
    UINavigationController *receiveNaviController = [[UINavigationController alloc]initWithRootViewController:[[ReceiveViewController alloc]init]];
    
    UINavigationController *completeNaviController = [[UINavigationController alloc]initWithRootViewController:[[CompleteViewController alloc]init]];
    UINavigationController *robNaviController = [[UINavigationController alloc]initWithRootViewController:[[RobViewController alloc]init]];
    
    UINavigationController *allorderNaviController = [[UINavigationController alloc]initWithRootViewController:[[AllOrderViewController alloc]init]];
    
    self.tabBarController.viewControllers = @[
                                         homeNaviController,
                                         receiveNaviController,
                                         completeNaviController,
                                         robNaviController,
                                         allorderNaviController
                                         ];
    self.tabBarController.tabBar.tintColor = color(59, 165, 249, 1);

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hadLaunch"]) {
        self.window.rootViewController = self.tabBarController;
    }else{
        self.window.rootViewController = [[LoginViewController alloc]init];
    }
    
    
    UIView *tabView = [[UIView alloc]initWithFrame:CGRectMake(0, Height - TabbarHeight, Width, TabbarHeight)];
    tabView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:tabView];

    [self.window makeKeyAndVisible];
    
    
    [WXApi registerApp:WXAppKey];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WBAppKey];
    TencentOAuth *oAuth = [[TencentOAuth alloc] initWithAppId:QQKey andDelegate:nil];
    NSLog(@"--%@",oAuth.accessToken);
    
    
    
    if (iOSVerson >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    }
    
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [JPUSHService setupWithOption:launchOptions appKey:jPushAppKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
  
    
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    application.applicationIconBadgeNumber ++;
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"有可抢工单" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBadgeValueChanged object:nil];
        [alertView show];
    }
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *absoluteURL = [url absoluteString];
    if ([absoluteURL rangeOfString:WBAppKey].location != NSNotFound) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([absoluteURL rangeOfString:WXAppKey].location != NSNotFound) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([absoluteURL rangeOfString:QQKey].location != NSNotFound) {
        return [TencentApiInterface handleOpenURL:url delegate:self];
    }

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation {
    NSString *absoluteURL = [url absoluteString];
    if ([absoluteURL rangeOfString:WBAppKey].location != NSNotFound) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([absoluteURL rangeOfString:WXAppKey].location != NSNotFound) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([absoluteURL rangeOfString:QQKey].location != NSNotFound) {
        return [TencentApiInterface handleOpenURL:url delegate:self];
    }
    
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK（这个是将支付宝客户端的支付结果传回给SDK）
    if ([url.host isEqualToString:@"safepay"]) {
 
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
            
             [self updateResponse];
             
         }];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    NSString *absoluteURL = [url absoluteString];
    if ([absoluteURL rangeOfString:WBAppKey].location != NSNotFound) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([absoluteURL rangeOfString:WXAppKey].location != NSNotFound) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([absoluteURL rangeOfString:QQKey].location != NSNotFound) {
        return [TencentApiInterface handleOpenURL:url delegate:self];
    }
    
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK（这个是将支付宝客户端的支付结果传回给SDK）
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             
             [self updateResponse];
             
         }];
    }
    
    return YES;
}

- (void)updateResponse {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/Payment/Alipay/Recharge.ashx?action=getorderstate&orderid=%@",HomeURL,[[NSUserDefaults standardUserDefaults] objectForKey:@"outTradeNO"]];
    

    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"data"] integerValue] ==  5) {

            
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.window];
            hud.mode = MBProgressHUDModeCustomView;
            [self.window addSubview:hud];
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
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMoney object:nil];
                });
                
            });
            
        }
        
        if ([responseObject[@"data"] integerValue] == 1) {

            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.window];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"支付取消,如有疑问,请联系客服";
            CGFloat fontsize;
            if (iPhone4_4s || iPhone5_5s) {
                fontsize = 14;
            }else {
                fontsize = 16;
            }
            hud.label.font = font(fontsize);
            [self.window addSubview:hud];
            [hud showAnimated:YES];
            hud.offset = CGPointMake(0, Height/5);
            [hud hideAnimated:YES afterDelay:1.5];
            [hud removeFromSuperViewOnHide];
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error.userInfo = %@",error.userInfo);
        
    }];
    
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    [homeVC.timer setFireDate:[NSDate distantFuture]];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    [homeVC.timer setFireDate:[NSDate distantPast]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hadLaunch"]) {
        
        [self checkNetWorking];
    }
}

- (void)checkNetWorking {
    
    NSDictionary *params = @{
                             @"name":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
                             @"password":[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]
                             };
    NSString *URL = [NSString stringWithFormat:@"%@Passport.ashx?action=login",HomeURL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
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
                        
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSString *countString = [NSString stringWithFormat:@"%@Task.ashx?action=gettaskcount&comid=%ld&uid=%ld&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager GET:countString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                NSString *allString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                NSArray *countList = [allString componentsSeparatedByString:@","];
                
                [[NSUserDefaults standardUserDefaults] setObject:countList forKey:@"countList"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];


            
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"logOut"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - WeiBoSDKDelegate -

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

#pragma mark - WXApiDelegate -

- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        NSLog(@"%@",@(response.errCode));
        
        switch (response.errCode) {
            case WXSuccess:
            {
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.window];
                hud.mode = MBProgressHUDModeCustomView;
                [self.window addSubview:hud];
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
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMoney object:nil];
                    });
                    
                });
            }
                break;
                
            default:
            {
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.window];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"支付取消,如有疑问,请联系客服";
                CGFloat fontsize;
                if (iPhone4_4s || iPhone5_5s) {
                    fontsize = 14;
                }else {
                    fontsize = 16;
                }
                hud.label.font = font(fontsize);
                [self.window addSubview:hud];
                [hud showAnimated:YES];
                hud.offset = CGPointMake(0, Height/5);
                [hud hideAnimated:YES afterDelay:1.5];
                [hud removeFromSuperViewOnHide];
            }
                break;
        }
        
    }
    
}

#pragma mark - TencentApiInterfaceDelegate -
- (BOOL)onTencentReq:(TencentApiReq *)req {
    return YES;
}


- (BOOL)onTencentResp:(TencentApiResp *)resp {
    return YES;
}
@end
