//
//  AppDelegate.m
//  爱服务
/****************************************************************
 *  程序中可能还有很多代码需要优化,
 *  比如,使用系统的UIImagePickerController,当用户手机中有一些超大的图片
 *  (20M的图片)应用的内存会暴增,造成闪退,可以自定义一个或使用好的第三方的
 *  imagePickerController,优化一下内存.避免这个问题.
 *  
 *  这个项目用了一个project多个target的策略， 好处挺多， 但这个东西我也不是使用的最好， 可以探究更多用法。
 *  不是所有地方都用的autoLayout， 原谅我。
 *  
 ****************************************************************/
//  Created by 张冬冬 on 16/4/9.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "AppDelegate.h"
#import "YeeptNetWorkingManager.h"
#import "UserModel.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "ReceiveViewController.h"
#import "CompleteViewController.h"
#import "RobViewController.h"
#import "AllOrderViewController.h"

#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "JPUSHService.h"
#import <AdSupport/ASIdentifierManager.h>

#import <AlipaySDK/AlipaySDK.h>
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import "Appirater.h"
@interface AppDelegate ()

<
WeiboSDKDelegate,
WXApiDelegate,
TencentApiInterfaceDelegate,
CLLocationManagerDelegate,
UIAlertViewDelegate
>

@property (nonatomic, assign) NSInteger bitch;
@property (nonatomic, assign) NSInteger fuckUBaby;

#if Environment_Mode == 1
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UIAlertController *locationAlertController;
@property (nonatomic, strong) UIAlertController *appLocationAlertController;
@property (nonatomic, strong) NSTimer *updateLocationTimer;
#elif Environment_Mode == 2
#endif

@end
static NSString *jPushAppKey = @"832a598bcc7101ce08f1168d";
static NSString *channel = @"App Store";
static BOOL isProduction = FALSE;
@implementation AppDelegate

#if Environment_Mode == 1

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        if (iOSVerson >= 9.0) {
//            _locationManager.allowsBackgroundLocationUpdates = YES;
        }
        if (iOSVerson >= 8.0) {
            [_locationManager requestAlwaysAuthorization];
        }
        CLLocationDistance distance = 10;
        _locationManager.distanceFilter = distance;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
    }
    return _locationManager;
}
#elif Environment_Mode == 2
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UINavigationBar appearance].barTintColor = color(30, 30, 30, 1);
    [UINavigationBar appearance].tintColor = color(245, 245, 245, 1);
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                           }];
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
    //解决tabbar懒加载问题
    [homeNaviController view];
    [receiveNaviController view];
    [completeNaviController view];
    [robNaviController view];
    [allorderNaviController view];
    
    self.tabBarController.tabBar.tintColor = color(65, 131, 196, 1);

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hadLaunch"]) {
        self.window.rootViewController = self.tabBarController;
    }else{
        self.window.rootViewController = [[LoginViewController alloc]init];
    }
    
    UIView *tabView = [[UIView alloc]initWithFrame:CGRectMake(0, Height - TabbarHeight, Width, TabbarHeight)];
    tabView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:tabView];
    [self.window makeKeyAndVisible];
    
    
    
#if Environment_Mode == 1
    //1073429240
    [Appirater setAppId:@"1073429240"];
    [Appirater setDaysUntilPrompt:7];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
#elif Environment_Mode == 2
    //1134925235
    [Appirater setAppId:@"1134925235"];
    [Appirater setDaysUntilPrompt:7];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
#endif
    
    [WXApi registerApp:WXAppKey];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WBAppKey];
    TencentOAuth *oAuth = [[TencentOAuth alloc] initWithAppId:QQKey andDelegate:nil];
    NSLog(@"%@",oAuth.accessToken);
    
    if (iOSVerson >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    }
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [JPUSHService setupWithOption:launchOptions appKey:jPushAppKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
  
#if Environment_Mode == 1
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLaunch"]) {
        if (![CLLocationManager locationServicesEnabled]) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"此手机的定位功能已禁用" message:@"请点击确定打开手机的定位功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 10000;
            [alertView show];
        }else if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"此应用的定位功能已禁用" message:@"请点击确定打开应用的定位功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 10001;
            [alertView show];
            
        }else {
            [self.locationManager startUpdatingLocation];
            self.updateLocationTimer = [NSTimer scheduledTimerWithTimeInterval:2*60 target:self selector:@selector(startUpdatingLocationWithLocationManager) userInfo:nil repeats:YES];
            
        }
        
    }else {
        [self.locationManager startUpdatingLocation];
        self.updateLocationTimer = [NSTimer scheduledTimerWithTimeInterval:2*60 target:self selector:@selector(startUpdatingLocationWithLocationManager) userInfo:nil repeats:YES];
        
    }
    
    
#elif Environment_Mode == 2
#endif
    self.fuckUBaby = 0;
    
    [Appirater appLaunched:YES];
    
    
    return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            
        }
    }else if (alertView.tag == 10001) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#if Environment_Mode == 1

- (void)startUpdatingLocationWithLocationManager {
    [self.locationManager startUpdatingLocation];
    
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
        case kCLAuthorizationStatusDenied:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"此应用的定位功能已禁用" message:@"请点击确定打开应用的定位功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 10001;
            [alertView show];
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            
        }
            
        default:
        {
            
        }
            break;
    }
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    UserModel *userModel = [UserModel readUserModel];

    NSString *subURL = @"common.ashx?action=update_user_lng_lat";
    NSDictionary *params = @{
                          @"userid":@(userModel.uid),
                          @"lng":@(location.coordinate.longitude),
                          @"lat":@(location.coordinate.latitude)
                         };
    
    [YeeptNetWorkingManager POSTMethodBaseURL:HomeURL path:subURL parameters:params isJSONSerialization:NO progress:nil success:^(id responseObject) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([jsonObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)jsonObj;
            
            NSString *UUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
            
            if (![dic[@"imei"] isEqualToString:UUID]) {
                
                if (![[self activityViewController] isKindOfClass:[LoginViewController class]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (self.fuckUBaby) {
                            LoginViewController *loginVC = [[LoginViewController alloc] init];
                            loginVC.passwordTextField.text = @"";
                            [[self activityViewController] presentViewController:loginVC animated:YES completion:nil];
                        }else {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"本账号已在另一台设备登录" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                LoginViewController *loginVC = [[LoginViewController alloc] init];
                                loginVC.passwordTextField.text = @"";
                                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                [[self activityViewController] presentViewController:loginVC animated:YES completion:nil];
                            }];
                            
                            [alert addAction:action];
                            
                            [[self activityViewController] presentViewController:alert animated:YES completion:nil];
                        }
                        
                    });
                    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"logOut"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hadLaunch"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    [manager stopUpdatingLocation];
}

- (UIViewController *)activityViewController {
    
    UIViewController *activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

#elif Environment_Mode == 2
#endif

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

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
            
             [self updateResponse:[[NSUserDefaults standardUserDefaults] objectForKey:@"outTradeNO"]];
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
             
             [self updateResponse:[[NSUserDefaults standardUserDefaults] objectForKey:@"outTradeNO"]];
             
         }];
    }
    return YES;
}

- (void)updateResponse:(NSString *)orderID {
    
#if Environment_Mode == 1
    NSString *subURL = [NSString stringWithFormat:@"/Payment/Alipay/Recharge.ashx?action=getorderstate&orderid=%@",orderID];
#elif Environment_Mode == 2
    NSString *subURL = [NSString stringWithFormat:@"/Payment/Alipay/Recharge.ashx?action=getorderstate&orderid=%@",orderID];

#endif
    
    [YeeptNetWorkingManager GETMethodBaseURL:HomeURL path:subURL parameters:nil isJSONSerialization:YES progress:nil success:^(id responseObject) {
        if ([responseObject[@"data"] integerValue] ==  5) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadCell object:nil];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            hud.label.text = @"付款中..";
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.minSize = CGSizeMake(100, 100);
            hud.offset = CGPointMake(0, Height/5);
            hud.label.font = font(14);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.window];
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
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            hud.label.text = @"付款中..";
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.minSize = CGSizeMake(100, 100);
            hud.offset = CGPointMake(0, Height/5);
            hud.label.font = font(14);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.window];
                UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"付款失败", @"HUD completed title");
                [hud hideAnimated:YES afterDelay:0.75f];
                [hud removeFromSuperViewOnHide];
            });
            
        }
    } failure:^(NSError *error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.label.text = @"付款中..";
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.minSize = CGSizeMake(100, 100);
        hud.offset = CGPointMake(0, Height/5);
        hud.label.font = font(14);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.window];
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



- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    [homeVC.timer setFireDate:[NSDate distantFuture]];
    self.fuckUBaby = 1;
#if Environment_Mode == 1
    
//        UIApplication *app = [UIApplication sharedApplication];
//        
//        __block UIBackgroundTaskIdentifier identifier;
//        
//        identifier = [app beginBackgroundTaskWithExpirationHandler:^{
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                if (identifier != UIBackgroundTaskInvalid) {
//                    
//                    identifier = UIBackgroundTaskInvalid;
//                    
//                }
//                
//            });
//            
//        }];
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                if (identifier != UIBackgroundTaskInvalid) {
//                    
//                    identifier = UIBackgroundTaskInvalid;
//                    
//                }
//                
//            });
//            
//        });
    
#elif Environment_Mode == 2
#endif
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    self.fuckUBaby = 0;
    [JPUSHService resetBadge];
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    [homeVC.timer setFireDate:[NSDate distantPast]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hadLaunch"]) {
        
        [self checkNetWorking];
    }
    
}

- (void)checkNetWorking {
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
    
    NSString *subURL = @"Passport.ashx?action=login";
    
    [YeeptNetWorkingManager POSTMethodBaseURL:HomeURL path:subURL parameters:params isJSONSerialization:YES progress:nil success:^(id responseObject) {
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
            
            
            
            [YeeptNetWorkingManager GETMethodBaseURL:HomeURL path:subURL parameters:params isJSONSerialization:NO progress:nil success:^(id responseObject) {
                NSString *allString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                NSArray *countList = [allString componentsSeparatedByString:@","];
                
                [[NSUserDefaults standardUserDefaults] setObject:countList forKey:@"countList"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"]).lastObject) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kupdateBadgeNum object:nil];
                }
            } failure:^(NSError *error) {
                
            }];
            
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"logOut"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"verify"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
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
        NSLog(@"response.errCode = %@",@(response.errCode));
        
        [self updateResponse:[[NSUserDefaults standardUserDefaults] objectForKey:@"WXOrderID"]];

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
