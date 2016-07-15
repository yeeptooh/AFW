//
//  HomeViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/9.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "HomeViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
#import "PhoneNumberViewController.h"
#import "PresentAnimation.h"
#import "DismissAnimation.h"
#import "ShareAnimation.h"
#import "MBProgressHUD.h"

#import "PartsRequestViewController.h"
#import "AppendFeesViewController.h"
#import "GuaranteeViewController.h"
#import "NotiViewController.h"
#import "StandardFeeViewController.h"
#import "MyInfoViewController.h"
#import "QRCodeViewController.h"
#import "ZDDQRCodeViewController.h"
#import "MyAccountViewController.h"
#import "WithDrawViewController.h"
#import "ShareViewController.h"
#import "RechargeViewController.h"
#import "HeartProtectViewController.h"
#import "GatheringViewController.h"


#import "AddOrderViewController.h"
#import "ACCReviewViewController.h"
#import "MasterQueryViewController.h"
#import "AddMoneyDetailViewController.h"


#import <AVFoundation/AVFoundation.h>
//#import "AddOrderViewController.h"

@interface HomeViewController ()
<
SDCycleScrollViewDelegate,
UIViewControllerTransitioningDelegate,
UINavigationControllerDelegate
>
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIView *balanceView;
@property (nonatomic, strong) MBProgressHUD *HUD;


@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, assign, getter=isFlag) BOOL flag;


@end
static NSInteger tag = 0;

@implementation HomeViewController



- (UIAlertController *)alertController {
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:@"此应用的相机功能已禁用" message:@"请点击确定打开应用的相机功能" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }];
        
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [_alertController addAction:openAction];
        [_alertController addAction:closeAction];
        
    }
    return _alertController;
}

- (UIView *)balanceView {

    NSInteger imageHeight;
    if (iPhone4_4s || iPhone5_5s) {
        imageHeight = 139;
    }else if (iPhone6) {
        imageHeight = 163;
    }else if (iPhone6_plus) {
        imageHeight = 180;
    }else{
        //如果都不是,默认按照6p设计
        imageHeight = 180;
    }
    if (!_balanceView) {
        CGFloat height;
        if (iPhone4_4s) {
            height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/8;
        }else if (iPhone5_5s) {
            height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/8;
        }else if (iPhone6) {
            height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/9;
        }else if (iPhone6_plus) {
            height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/9;
        }else {
            height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/9;
        }
        
        _balanceView = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight, Width, height)];
        _balanceView.backgroundColor = [UIColor whiteColor];
        
    }
    return _balanceView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"首页";
        self.tabBarItem.image = [UIImage imageNamed:@"drawable_no_select_home"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"drawable_select_home"];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
#if Environment_Mode == 1
    self.view.backgroundColor = color(246, 246, 246, 1);
#elif Environment_Mode == 2
    self.view.backgroundColor = [UIColor whiteColor];//color(246, 246, 246, 1);
#endif
    
    [self setNaviTitle];
    [self setScrollView];
    [self updateUI];
    [self setDetailButton];
    [self setBreakLine];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AVCan"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badgeValueChanged:) name:kBadgeValueChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMoney:) name:kUpdateMoney object:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 * 60 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    
}



- (void)updateMoney:(NSNotification *)sender {
    [self updateUI];
}


- (void)setBadgeValue {
    UIViewController *receiveVC = [self.tabBarController viewControllers][1];
    UIViewController *completeVC = [self.tabBarController viewControllers][2];
    UIViewController *robVC = [self.tabBarController viewControllers][3];
    UIViewController *allorderVC = [self.tabBarController viewControllers][4];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][1] isEqualToString:@"0"]) {
        
        receiveVC.tabBarItem.badgeValue = nil;
    }else{
        receiveVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][1];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][2] isEqualToString:@"0"]) {
        completeVC.tabBarItem.badgeValue = nil;
    }else{
        completeVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][2];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][3] isEqualToString:@"0"]) {
        robVC.tabBarItem.badgeValue = nil;
    }else{
        robVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][3];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][0] isEqualToString:@"0"]) {
        allorderVC.tabBarItem.badgeValue = nil;
    }else{
        allorderVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][0];
    }

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewWillAppear:animated];
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor = color(30, 30, 30, 1);
    if (self.isFlag) {
        [self updateUI];
        self.flag = NO;
    }
    
    [self setBadgeValue];
    
}



- (void)upDateNetWorking {
    
    [self.HUD showAnimated:YES];
    
    NSDictionary *params = @{
                             @"name":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
                             @"password":[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]
                             };
    NSString *URL = [NSString stringWithFormat:@"%@Passport.ashx?action=login",HomeURL];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 5;
    __weak typeof(self)weakSelf = self;
    
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
            manager.requestSerializer.timeoutInterval = 5;
            [manager GET:countString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSString *allString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSArray *countList = [allString componentsSeparatedByString:@","];
                
                [[NSUserDefaults standardUserDefaults] setObject:countList forKey:@"countList"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [weakSelf.HUD hideAnimated:YES];
                [weakSelf.HUD removeFromSuperViewOnHide];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakSelf.HUD hideAnimated:YES];
                [weakSelf.HUD removeFromSuperViewOnHide];
            }];
 
        }else{
            
            [weakSelf.HUD hideAnimated:YES];
            [weakSelf.HUD removeFromSuperViewOnHide];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf.HUD hideAnimated:YES];
        [weakSelf.HUD removeFromSuperViewOnHide];
        
    }];

}

- (void)updateUI {
    UIView *window = [[UIApplication sharedApplication].delegate window];
    self.HUD = [[MBProgressHUD alloc]initWithView:window];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [window addSubview:self.HUD];
    
    [self upDateNetWorking];
    [self setBalance];
    [self setBadgeValue];
}

- (void)setNaviTitle {
    self.navigationItem.title = @"首页";
    
//    UIImageView *logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainicon"]];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:logoImageView];
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneButton setImage:[UIImage imageNamed:@"msg_room_toolbar_media_fct_notrace_norm_0"] forState:UIControlStateNormal];
    
    
    phoneButton.frame = CGRectMake(0, 0, Width/10, Width/10);
    [phoneButton addTarget:self action:@selector(phoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:phoneButton];

}

- (void)phoneButtonClicked {
    PhoneNumberViewController *phoneNumberVC = [[PhoneNumberViewController alloc]init];
    phoneNumberVC.transitioningDelegate = self;
    phoneNumberVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:phoneNumberVC animated:YES completion:nil];
}

- (void)setScrollView {
    NSInteger imageHeight;
    if (iPhone4_4s || iPhone5_5s) {
        imageHeight = 139;
    }else if (iPhone6) {
        imageHeight = 163;
    }else if (iPhone6_plus) {
        imageHeight = 180;
    }else{
        imageHeight = 180;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, imageHeight)];
    scrollView.contentSize = CGSizeMake(Width * PageCount, scrollView.bounds.size.height);
    [self.view addSubview:scrollView];
    
    NSArray *imageNameList = @[
                               @"home_viewpage1.jpg",
                               @"home_viewpage2.jpg",
                               @"home_viewpage3.jpg"
                               ];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:scrollView.bounds shouldInfiniteLoop:YES imageNamesGroup:imageNameList];
    
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    
    [scrollView addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cycleScrollView.autoScrollTimeInterval = 3.f;
    
}

#pragma mark - SDCycleScrollViewDelegate -
//点击某张图片
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了第%ld张图片",(long)index);
}

- (void)setBalance {
    NSInteger imageHeight;
    CGFloat height;
    if (iPhone4_4s || iPhone5_5s) {
        imageHeight = 139;
        height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/8;

    }else if (iPhone6) {
        imageHeight = 163;
        height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/9;
    }else if (iPhone6_plus) {
        imageHeight = 180;
        height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/9;
    }else{
        imageHeight = 180;
        height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/9;

    }
    
    if (self.balanceView != nil) {
        [self.balanceView removeFromSuperview];
        self.balanceView = nil;
    }
    UserModel *userModel = [UserModel readUserModel];
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width*2/5, self.balanceView.bounds.size.height)];
    NSString *balanceStr = [NSString stringWithFormat:@"账户余额:%.2f元",userModel.money];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:balanceStr];
    UIColor *color = [UIColor redColor];
    NSRange range = NSMakeRange(5, balanceStr.length - 6);
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:color
                          range:range];
    balanceLabel.attributedText = attributedStr;
    balanceLabel.font = font(13);
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [self.balanceView addSubview:balanceLabel];
    
    
#if Environment_Mode == 1
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width*2/5, 0, Width*2/5, balanceLabel.bounds.size.height)];
    NSString *money = [((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"]) lastObject];
    CGFloat moneyNumber = [money floatValue];
    NSString *moneyStr = [NSString stringWithFormat:@"保证金:%.2f元",moneyNumber];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, moneyStr.length - 5)];
    moneyLabel.attributedText = attributedString;
    moneyLabel.textAlignment = NSTextAlignmentCenter;

    moneyLabel.font = font(13);
    [self.balanceView addSubview:moneyLabel];
#elif Environment_Mode == 2
#endif

    UIButton *drawMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    drawMoneyButton.frame = CGRectMake(Width*4/5, 0, Width/5, self.balanceView.bounds.size.height);
    [drawMoneyButton setTitle:@"提现" forState:UIControlStateNormal];
    [drawMoneyButton setTitleColor:color(80, 80, 80, 1) forState:UIControlStateNormal];
    [drawMoneyButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];

    drawMoneyButton.titleLabel.font = font(13);
    [drawMoneyButton setImage:[UIImage imageNamed:@"common_icon_arrow"] forState:UIControlStateNormal];
    [drawMoneyButton setImage:[UIImage imageNamed:@"common_icon_arrow_highlighted"] forState:UIControlStateHighlighted];
    [drawMoneyButton addTarget:self action:@selector(drawMoneyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.balanceView addSubview:drawMoneyButton];
    
    [self.view addSubview:self.balanceView];
    
    CGSize imageSize = drawMoneyButton.imageView.bounds.size;
    CGSize titleLabelSize = drawMoneyButton.titleLabel.bounds.size;

    drawMoneyButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleLabelSize.width+imageSize.width, 0, 0);
    drawMoneyButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width-titleLabelSize.width, 0, 0);
    drawMoneyButton.contentEdgeInsets = UIEdgeInsetsMake(0, -Width/24, 0, -Width/8);
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, height-0.5, Width, 0.5)];
    lineView.backgroundColor = color(200, 200, 200, 1);
    [self.balanceView addSubview:lineView];
    
}

- (void)setDetailButton {
    
    NSInteger imageHeight;
    if (iPhone4_4s || iPhone5_5s) {
        imageHeight = 139;
    }else if (iPhone6) {
        imageHeight = 163;
    }else if (iPhone6_plus) {
        imageHeight = 180;
    }else{
        imageHeight = 180;
    }
#if Environment_Mode == 1
    
    CGFloat height;
    
    UIScrollView *scrollView;
    if (iPhone4_4s) {
        height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/8;
        self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, height * 7 + height *7 / 3)];
        self.containerView.backgroundColor = [UIColor whiteColor];
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, imageHeight + height , Width, height * 7)];
        scrollView.contentSize = CGSizeMake(Width, height * 7 + height *7 / 3);
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [scrollView addSubview:self.containerView];
        [self.view addSubview:scrollView];
        for (NSInteger i = 0; i < 4; i ++) {
            for (NSInteger j = 0;  j < 4; j ++) {
                self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.detailButton.tag = tag + 1000;
                tag ++;
                
                [self.detailButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"a%ld",(long)tag]] forState:UIControlStateNormal];
                
                //            if (i == 2 && (j == 2 || j == 3)) {
                //                [self.detailButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                //            }
                
                [self.detailButton addTarget:self action:@selector(detailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
 
                self.detailButton.frame = CGRectMake(Width*j/4, height*7*i/3, Width/4, height*7/3);
                
                if (self.detailButton.tag == 1000) {
                    [self.detailButton setTitle:@"配件申请" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1001) {
                    [self.detailButton setTitle:@"追加费用" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1002) {
                    [self.detailButton setTitle:@"保修政策" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1003) {
                    [self.detailButton setTitle:@"通知公告" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1004) {
                    [self.detailButton setTitle:@"收费标准" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1005) {
                    [self.detailButton setTitle:@"我的信息" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1006) {
                    [self.detailButton setTitle:@"二维码" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1007) {
                    [self.detailButton setTitle:@"分享好友" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1008) {
                    [self.detailButton setTitle:@"我的帐户" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if(self.detailButton.tag == 1009) {
                    [self.detailButton setTitle:@"我要提现" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if(self.detailButton.tag == 1010) {
                    [self.detailButton setTitle:@"我要充值" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if(self.detailButton.tag == 1011) {
                    [self.detailButton setTitle:@"爱心保" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if(self.detailButton.tag == 1012) {
                    [self.detailButton setTitle:@"我要收款" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }
                CGFloat fontsize = 12;
                
                self.detailButton.titleLabel.font = font(fontsize);
                CGSize imageSize = self.detailButton.imageView.bounds.size;
                CGSize titleLabelSize = self.detailButton.titleLabel.bounds.size;
                
                self.detailButton.imageEdgeInsets = UIEdgeInsetsMake(- self.detailButton.bounds.size.height/3, 0, 0, -titleLabelSize.width);
                self.detailButton.titleEdgeInsets = UIEdgeInsetsMake(self.detailButton.bounds.size.height/2, -imageSize.width, 0, 0);
                
                
                [self.containerView addSubview:self.detailButton];
            }
        }
    }else if (iPhone5_5s){
        height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/8;
        self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, height * 8)];
        self.containerView.backgroundColor = [UIColor whiteColor];
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, imageHeight + height , Width, height * 7)];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(Width, height * 8);
        [scrollView addSubview:self.containerView];
        [self.view addSubview:scrollView];
        for (NSInteger i = 0; i < 4; i ++) {
            for (NSInteger j = 0;  j < 4; j ++) {
                self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.detailButton.tag = tag + 1000;
                tag ++;
                
                [self.detailButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"a%ld",(long)tag]] forState:UIControlStateNormal];
                
                //            if (i == 2 && (j == 2 || j == 3)) {
                //                [self.detailButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                //            }
                
                [self.detailButton addTarget:self action:@selector(detailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

                self.detailButton.frame = CGRectMake(Width*j/4, height*2*i, Width/4, height*2);
                
                if (self.detailButton.tag == 1000) {
                    [self.detailButton setTitle:@"配件申请" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1001) {
                    [self.detailButton setTitle:@"追加费用" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1002) {
                    [self.detailButton setTitle:@"保修政策" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1003) {
                    [self.detailButton setTitle:@"通知公告" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1004) {
                    [self.detailButton setTitle:@"收费标准" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1005) {
                    [self.detailButton setTitle:@"我的信息" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1006) {
                    [self.detailButton setTitle:@"二维码" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1007) {
                    [self.detailButton setTitle:@"分享好友" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1008) {
                    [self.detailButton setTitle:@"我的帐户" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if(self.detailButton.tag == 1009) {
                    [self.detailButton setTitle:@"我要提现" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if(self.detailButton.tag == 1010) {
                    [self.detailButton setTitle:@"我要充值" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if(self.detailButton.tag == 1011) {
                    [self.detailButton setTitle:@"爱心保" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1012) {
                    [self.detailButton setTitle:@"我要收款" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }
                CGFloat fontsize = 12;
                
                self.detailButton.titleLabel.font = font(fontsize);
                CGSize imageSize = self.detailButton.imageView.bounds.size;
                CGSize titleLabelSize = self.detailButton.titleLabel.bounds.size;
                
                self.detailButton.imageEdgeInsets = UIEdgeInsetsMake(- self.detailButton.bounds.size.height/3, 0, 0, -titleLabelSize.width);
                self.detailButton.titleEdgeInsets = UIEdgeInsetsMake(self.detailButton.bounds.size.height/2, -imageSize.width, 0, 0);

                [self.containerView addSubview:self.detailButton];
            }
        }
        
    }else if (iPhone6 || iPhone6_plus) {
        height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/9;
        self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height, Width, height * 8)];
        self.containerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.containerView];
        for (NSInteger i = 0; i < 4; i ++) {
            for (NSInteger j = 0;  j < 4; j ++) {
                self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.detailButton.tag = tag + 1000;
                tag ++;
                
                [self.detailButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"a%ld",(long)tag]] forState:UIControlStateNormal];
                
                //            if (i == 2 && (j == 2 || j == 3)) {
                //                [self.detailButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                //            }
                
                [self.detailButton addTarget:self action:@selector(detailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

                self.detailButton.frame = CGRectMake(Width*j/4, height*2*i, Width/4, height*2);
               
                if (self.detailButton.tag == 1000) {
                    [self.detailButton setTitle:@"配件申请" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1001) {
                    [self.detailButton setTitle:@"追加费用" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1002) {
                    [self.detailButton setTitle:@"保修政策" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1003) {
                    [self.detailButton setTitle:@"通知公告" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1004) {
                    [self.detailButton setTitle:@"收费标准" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1005) {
                    [self.detailButton setTitle:@"我的信息" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1006) {
                    [self.detailButton setTitle:@"二维码" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1007) {
                    [self.detailButton setTitle:@"分享好友" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1008) {
                    [self.detailButton setTitle:@"我的帐户" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if(self.detailButton.tag == 1009) {
                    [self.detailButton setTitle:@"我要提现" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if(self.detailButton.tag == 1010) {
                    [self.detailButton setTitle:@"我要充值" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if(self.detailButton.tag == 1011) {
                    [self.detailButton setTitle:@"爱心保" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1012) {
                    [self.detailButton setTitle:@"我要收款" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }
                CGFloat fontsize = 13;
                
                self.detailButton.titleLabel.font = font(fontsize);
                CGSize imageSize = self.detailButton.imageView.bounds.size;
                CGSize titleLabelSize = self.detailButton.titleLabel.bounds.size;
                
                self.detailButton.imageEdgeInsets = UIEdgeInsetsMake(- self.detailButton.bounds.size.height/3, 0, 0, -titleLabelSize.width);
                self.detailButton.titleEdgeInsets = UIEdgeInsetsMake(self.detailButton.bounds.size.height/2, -imageSize.width, 0, 0);
                
                
                [self.containerView addSubview:self.detailButton];
            }
        }
        
    }else {
        height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/9;
        self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height, Width, height * 8)];
        self.containerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.containerView];
        for (NSInteger i = 0; i < 4; i ++) {
            for (NSInteger j = 0;  j < 4; j ++) {
                self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.detailButton.tag = tag + 1000;
                tag ++;
                
                [self.detailButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"a%ld",(long)tag]] forState:UIControlStateNormal];
                
                //            if (i == 2 && (j == 2 || j == 3)) {
                //                [self.detailButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                //            }
                
                [self.detailButton addTarget:self action:@selector(detailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                self.detailButton.frame = CGRectMake(Width*j/4, height*2*i, Width/4, height*2);
                
                if (self.detailButton.tag == 1000) {
                    [self.detailButton setTitle:@"配件申请" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1001) {
                    [self.detailButton setTitle:@"追加费用" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1002) {
                    [self.detailButton setTitle:@"保修政策" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1003) {
                    [self.detailButton setTitle:@"通知公告" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1004) {
                    [self.detailButton setTitle:@"收费标准" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1005) {
                    [self.detailButton setTitle:@"我的信息" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1006) {
                    [self.detailButton setTitle:@"二维码" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1007) {
                    [self.detailButton setTitle:@"分享好友" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1008) {
                    [self.detailButton setTitle:@"我的帐户" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if(self.detailButton.tag == 1009) {
                    [self.detailButton setTitle:@"我要提现" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if(self.detailButton.tag == 1010) {
                    [self.detailButton setTitle:@"我要充值" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if(self.detailButton.tag == 1011) {
                    [self.detailButton setTitle:@"爱心保" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }else if (self.detailButton.tag == 1012) {
                    [self.detailButton setTitle:@"我要收款" forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                    [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                }
                CGFloat fontsize = 13;
                
                self.detailButton.titleLabel.font = font(fontsize);
                CGSize imageSize = self.detailButton.imageView.bounds.size;
                CGSize titleLabelSize = self.detailButton.titleLabel.bounds.size;
                
                self.detailButton.imageEdgeInsets = UIEdgeInsetsMake(- self.detailButton.bounds.size.height/3, 0, 0, -titleLabelSize.width);
                self.detailButton.titleEdgeInsets = UIEdgeInsetsMake(self.detailButton.bounds.size.height/2, -imageSize.width, 0, 0);
                
                
                [self.containerView addSubview:self.detailButton];
            }
        }
    }
    
  
#elif Environment_Mode == 2
    CGFloat height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/8;
    UIView *containerView;
    if (iPhone4_4s) {
        containerView = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height, Width, height*7)];
    }else{
        containerView = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height, Width, height*6)];
    }
    
    
    [self.view addSubview:containerView];
    for (NSInteger i = 0; i < 2; i ++) {
        for (NSInteger j = 0;  j < 4; j ++) {
            self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.detailButton.tag = tag + 1000;
            tag ++;
            
            [self.detailButton addTarget:self action:@selector(detailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if (iPhone4_4s) {
                self.detailButton.frame = CGRectMake(Width*j/4, height*7*i/3, Width/4, height*6/3);
            }else {
                self.detailButton.frame = CGRectMake(Width*j/4, height*6*i/3, Width/4, height*6/3);
            }
            
            if (self.detailButton.tag == 1000) {
                [self.detailButton setTitle:@"我要下单" forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                [self.detailButton setImage:[UIImage imageNamed:@"a1"] forState:UIControlStateNormal];
            }else if (self.detailButton.tag == 1001) {
                [self.detailButton setTitle:@"配件审核" forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                [self.detailButton setImage:[UIImage imageNamed:@"a3"] forState:UIControlStateNormal];
            }else if (self.detailButton.tag == 1002) {
                [self.detailButton setTitle:@"追加审核" forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                [self.detailButton setImage:[UIImage imageNamed:@"a4"] forState:UIControlStateNormal];
            }else if (self.detailButton.tag == 1003) {
                [self.detailButton setTitle:@"师傅查询" forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                [self.detailButton setImage:[UIImage imageNamed:@"a6"] forState:UIControlStateNormal];
            }else if (self.detailButton.tag == 1004) {
                [self.detailButton setTitle:@"基础资料" forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                [self.detailButton setImage:[UIImage imageNamed:@"a6"] forState:UIControlStateNormal];
            }else if (self.detailButton.tag == 1005) {
                [self.detailButton setTitle:@"我的账户" forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                [self.detailButton setImage:[UIImage imageNamed:@"a9"] forState:UIControlStateNormal];
            }else if (self.detailButton.tag == 1006) {
                [self.detailButton setTitle:@"我要提现" forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                [self.detailButton setImage:[UIImage imageNamed:@"a10"] forState:UIControlStateNormal];
            }else if (self.detailButton.tag == 1007) {
                [self.detailButton setTitle:@"我要充值" forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
                [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
                [self.detailButton setImage:[UIImage imageNamed:@"a11"] forState:UIControlStateNormal];
            }
            CGFloat fontsize;
            if (iPhone4_4s || iPhone5_5s) {
                fontsize = 12;
            }else {
                fontsize = 13;
            }
            self.detailButton.titleLabel.font = font(fontsize);
            CGSize imageSize = self.detailButton.imageView.bounds.size;
            CGSize titleLabelSize = self.detailButton.titleLabel.bounds.size;
            
            self.detailButton.imageEdgeInsets = UIEdgeInsetsMake(- self.detailButton.bounds.size.height/3, 0, 0, -titleLabelSize.width);
            self.detailButton.titleEdgeInsets = UIEdgeInsetsMake(self.detailButton.bounds.size.height/2, -imageSize.width, 0, 0);
            
            
            [containerView addSubview:self.detailButton];
        }
    }
    
#endif
    
}

- (void)setBreakLine {
    NSInteger imageHeight;
    if (iPhone4_4s || iPhone5_5s) {
        imageHeight = 139;
    }else if (iPhone6) {
        imageHeight = 163;
    }else if (iPhone6_plus) {
        imageHeight = 180;
    }else{
        imageHeight = 180;
    }
#if Environment_Mode == 1
    
    if (iPhone4_4s) {
        CGFloat height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/8;
        UIView *H1Line = [[UIView alloc]initWithFrame:CGRectMake(0, height*7/3-0.5, Width, 0.5)];
        H1Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:H1Line];
        
        UIView *H2Line = [[UIView alloc]initWithFrame:CGRectMake(0, height*7*2/3-0.5, Width, 0.5)];
        H2Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:H2Line];
        
        UIView *H3Line = [[UIView alloc]initWithFrame:CGRectMake(0, height*7*3/3-0.5, Width, 0.5)];
        H3Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:H3Line];
        
        UIView *H4Line = [[UIView alloc]initWithFrame:CGRectMake(0, height*7*4/3-0.5, Width, 0.5)];
        H4Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:H4Line];
        
        
        UIView *V1Line = [[UIView alloc]initWithFrame:CGRectMake(Width/4-0.5, imageHeight + height, 0.5, height*7 + height *7 / 3)];
        V1Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:V1Line];
        
        UIView *V2Line = [[UIView alloc]initWithFrame:CGRectMake(Width*2/4-0.5, imageHeight + height, 0.5, height*7 + height *7 / 3)];
        V2Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:V2Line];
        
        UIView *V3Line = [[UIView alloc]initWithFrame:CGRectMake(Width*3/4-0.5, imageHeight + height, 0.5, height*7 + height *7 / 3)];
        V3Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:V3Line];
    }else if (iPhone5_5s){
        CGFloat height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/8;
        
//        UIView *H0Line = [[UIView alloc]initWithFrame:CGRectMake(0, -0.5, Width, 0.5)];
//        H0Line.backgroundColor = color(200, 200, 200, 1);
//        [self.containerView addSubview:H0Line];
        
        UIView *H1Line = [[UIView alloc]initWithFrame:CGRectMake(0, height * 8 / 4 - 0.5, Width, 0.5)];
        H1Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:H1Line];
        
        UIView *H2Line = [[UIView alloc]initWithFrame:CGRectMake(0, height * 8 * 2 / 4 - 0.5, Width, 0.5)];
        H2Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:H2Line];
        
        UIView *H3Line = [[UIView alloc]initWithFrame:CGRectMake(0, height * 8 * 3 / 4  - 0.5, Width, 0.5)];
        H3Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:H3Line];
        
        UIView *H4Line = [[UIView alloc]initWithFrame:CGRectMake(0, height * 8 * 4 / 4  - 0.5, Width, 0.5)];
        H4Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:H4Line];
        
        
        UIView *V1Line = [[UIView alloc]initWithFrame:CGRectMake(Width / 4 - 0.5, 0, 0.5, height * 8)];
        V1Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:V1Line];
        
        UIView *V2Line = [[UIView alloc]initWithFrame:CGRectMake(Width * 2 / 4 - 0.5, 0, 0.5, height * 8)];
        V2Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:V2Line];
        
        UIView *V3Line = [[UIView alloc]initWithFrame:CGRectMake(Width * 3 / 4 - 0.5, 0, 0.5, height * 8)];
        V3Line.backgroundColor = color(200, 200, 200, 1);
        [self.containerView addSubview:V3Line];
    } else if (iPhone6 || iPhone6_plus) {
        CGFloat height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/9;
        UIView *H1Line = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height + height * 8 / 4 - 0.5, Width, 0.5)];
        H1Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:H1Line];
        
        UIView *H2Line = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height + height * 8 * 2 / 4 - 0.5, Width, 0.5)];
        H2Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:H2Line];
        
        UIView *H3Line = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height + height * 8 * 3 / 4 - 0.5, Width, 0.5)];
        H3Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:H3Line];
        
        
        UIView *V1Line = [[UIView alloc]initWithFrame:CGRectMake(Width / 4 - 0.5, imageHeight + height, 0.5, height * 8)];
        V1Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V1Line];
        
        UIView *V2Line = [[UIView alloc]initWithFrame:CGRectMake(Width * 2 / 4 - 0.5, imageHeight + height, 0.5, height * 8)];
        V2Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V2Line];
        
        UIView *V3Line = [[UIView alloc]initWithFrame:CGRectMake(Width * 3 / 4 - 0.5, imageHeight + height, 0.5, height * 8)];
        V3Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V3Line];
    }
    
#elif Environment_Mode == 2
    CGFloat height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/8;
    
    if (iPhone4_4s) {
        UIView *H1Line = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height + height*7/3-0.5, Width, 0.5)];
        H1Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:H1Line];
        
        UIView *H2Line = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height + height*7*2/3-0.5, Width, 0.5)];
        H2Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:H2Line];
        
        
        UIView *V1Line = [[UIView alloc]initWithFrame:CGRectMake(Width/4-0.5, imageHeight + height, 0.5, height*7*2/3)];
        V1Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V1Line];
        
        UIView *V2Line = [[UIView alloc]initWithFrame:CGRectMake(Width*2/4-0.5, imageHeight + height, 0.5, height*7*2/3)];
        V2Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V2Line];
        
        UIView *V3Line = [[UIView alloc]initWithFrame:CGRectMake(Width*3/4-0.5, imageHeight + height, 0.5, height*7*2/3)];
        V3Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V3Line];
    }else{
        UIView *H1Line = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height + height * 6 / 3 - 0.5, Width, 0.5)];
        H1Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:H1Line];
        
        UIView *H2Line = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height + height * 6 * 2 / 3 - 0.5, Width, 0.5)];
        H2Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:H2Line];
        
        
        UIView *V1Line = [[UIView alloc]initWithFrame:CGRectMake(Width / 4 - 0.5, imageHeight + height, 0.5, height * 6*2/3)];
        V1Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V1Line];
        
        UIView *V2Line = [[UIView alloc]initWithFrame:CGRectMake(Width * 2 / 4 - 0.5, imageHeight + height, 0.5, height * 6*2/3)];
        V2Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V2Line];
        
        UIView *V3Line = [[UIView alloc]initWithFrame:CGRectMake(Width * 3 / 4 - 0.5, imageHeight + height, 0.5, height * 6*2/3)];
        V3Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V3Line];
    }
#endif
   
}

#pragma mark - buttonClicked -
- (void)drawMoneyButtonClicked {
    
    WithDrawViewController *withDrawVC = [[WithDrawViewController alloc]init];
    withDrawVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:withDrawVC animated:YES];

}

- (void)detailButtonClicked:(UIButton *)sender {
#if Environment_Mode == 1
    if (sender.tag == 1000) {
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AVCan"]) {
            PartsRequestViewController *partsRequestVC = [[PartsRequestViewController alloc]init];
            partsRequestVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:partsRequestVC animated:YES];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AVCan"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }else {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            NSLog(@"%ld",(long)status);
            if (status == AVAuthorizationStatusAuthorized) {
                PartsRequestViewController *partsRequestVC = [[PartsRequestViewController alloc]init];
                partsRequestVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:partsRequestVC animated:YES];

            }else {
                [self presentViewController:self.alertController animated:YES completion:nil];
            }
        }
        
  
    }else if (sender.tag == 1001) {
        
        AppendFeesViewController *appendVC = [[AppendFeesViewController alloc]init];
        appendVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:appendVC animated:YES];
        
    }else if (sender.tag == 1002) {
        
        GuaranteeViewController *guaranteeVC = [[GuaranteeViewController alloc]init];
        guaranteeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:guaranteeVC animated:YES];
        
    }else if (sender.tag == 1003) {
        
        NotiViewController *notiVC = [[NotiViewController alloc]init];
        notiVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:notiVC animated:YES];
        
    }else if (sender.tag == 1004) {
        
        StandardFeeViewController *standardVC = [[StandardFeeViewController alloc]init];
        standardVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:standardVC animated:YES];
        
    }else if (sender.tag == 1005) {
        
        MyInfoViewController *infoVC = [[MyInfoViewController alloc]init];
        infoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
        
    }else if (sender.tag == 1006) {
        
//        QRCodeViewController *qrcodeVC = [[QRCodeViewController alloc]init];
//        qrcodeVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:qrcodeVC animated:YES];
        
        ZDDQRCodeViewController *qrcodeVC = [[ZDDQRCodeViewController alloc] init];
        qrcodeVC.hidesBottomBarWhenPushed = YES;
        
        UIImage *image = [UIImage imageNamed:@"IMG_4188.jpg"];
        
        CIQRCodeFeature *QRCodeFeature = (CIQRCodeFeature *)[[self detectQRCodeWithImage:image] firstObject];
        NSLog(@"%lu",(unsigned long)[self detectQRCodeWithImage:image].count);
        
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        
        [filter setDefaults];
        qrcodeVC.message = QRCodeFeature.messageString;
        NSData *urlData = [QRCodeFeature.messageString dataUsingEncoding:NSUTF8StringEncoding];
        
        
        [filter setValue:urlData forKey:@"inputMessage"];
        CIImage *ciImage = [filter outputImage];
        
        UIImage *qrImage = [self createNonInterpolatedUIImageFromCIImage:ciImage withSize:qrcodeVC.imageView.bounds.size.width];
        qrcodeVC.imageView.image = qrImage;
        [self.navigationController pushViewController:qrcodeVC animated:YES];
        
    }else if (sender.tag == 1007) {
        
        ShareViewController *sVC = [[ShareViewController alloc]init];
        sVC.transitioningDelegate = self;
        sVC.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:sVC animated:YES completion:nil];
        
    }else if (sender.tag == 1008) {
        
        MyAccountViewController *accountVC = [[MyAccountViewController alloc]init];
        accountVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:accountVC animated:YES];
        
    }else if (sender.tag == 1009) {
        
        WithDrawViewController *withDrawVC = [[WithDrawViewController alloc]init];
        withDrawVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:withDrawVC animated:YES];
    }else if (sender.tag == 1010) {
        
        self.flag = YES;
        RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
        rechargeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rechargeVC animated:YES];
        
    }else if (sender.tag == 1011) {
        
        self.flag = YES;
        HeartProtectViewController *heartVC = [[HeartProtectViewController alloc] init];
        heartVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:heartVC animated:YES];
        
    }else if (sender.tag == 1012) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        
        
        
        UserModel *userModel = [UserModel readUserModel];
        
        GatheringViewController *gatherVC = [[GatheringViewController alloc] init];
        gatherVC.hidesBottomBarWhenPushed = YES;
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString *url = [NSString stringWithFormat:@"%@uploadFile.ashx?action=loadimages&userId=%@",HomeURL, @(userModel.uid)];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
        
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",dic);
            if (dic[@"wechatpay"] == 0) {
                
            }else {
 
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",subHomeURL, dic[@"wechatpay"]]]];
                gatherVC.imageView1.image = [UIImage imageWithData:data];
                
            }
            if (dic[@"alipay"] == 0) {
                
            }else {

                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",subHomeURL, dic[@"alipay"]]]];
                gatherVC.imageView2.image = [UIImage imageWithData:data];
                
            }
            
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
            
            [hud hideAnimated:YES];
            [hud removeFromSuperViewOnHide];
            [self.navigationController pushViewController:gatherVC animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
            UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = NSLocalizedString(@"请检查网络", @"HUD completed title");
            [hud hideAnimated:YES afterDelay:1.5f];
            [hud removeFromSuperViewOnHide];
            NSLog(@"%@",error.userInfo);
            
        }];
        
  
        
        
        
    }
    
#elif Environment_Mode == 2
    if (sender.tag == 1000) {
        AddOrderViewController *addVC = [[AddOrderViewController alloc] init];
        addVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addVC animated:YES];
        
        
    }else if (sender.tag == 1001) {
        ACCReviewViewController *ACCVC = [[ACCReviewViewController alloc] init];
        ACCVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ACCVC animated:YES];
        
        
    }else if (sender.tag == 1002) {
        
        AddMoneyDetailViewController *addMoneyVC = [[AddMoneyDetailViewController alloc] init];
        addMoneyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addMoneyVC animated:YES];
        
        
        
    }else if (sender.tag == 1003) {
        MasterQueryViewController *ACCVC = [[MasterQueryViewController alloc] init];
        ACCVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ACCVC animated:YES];
        
        
    }else if (sender.tag == 1004) {
        
        MyInfoViewController *infoVC = [[MyInfoViewController alloc]init];
        infoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
        
    }else if (sender.tag == 1005) {
        
        MyAccountViewController *accountVC = [[MyAccountViewController alloc]init];
        accountVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:accountVC animated:YES];
        
    }else if (sender.tag == 1006) {
        
        WithDrawViewController *withDrawVC = [[WithDrawViewController alloc]init];
        withDrawVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:withDrawVC animated:YES];
        
        
    }else if (sender.tag == 1007) {
        self.flag = YES;
        RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
        rechargeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rechargeVC animated:YES];
        
    }
    
#endif
    
}

- (void)badgeValueChanged:(NSNotification *)noti {
    UIViewController *receiveVC = [self.tabBarController viewControllers][1];
    UIViewController *completeVC = [self.tabBarController viewControllers][2];
    UIViewController *robVC = [self.tabBarController viewControllers][3];
    UIViewController *allorderVC = [self.tabBarController viewControllers][4];
    
    UserModel *userModel = [UserModel readUserModel];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *countString = [NSString stringWithFormat:@"%@Task.ashx?action=gettaskcount&comid=%ld&uid=%ld&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:countString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *allString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *countList = [allString componentsSeparatedByString:@","];
        
        [[NSUserDefaults standardUserDefaults] setObject:countList forKey:@"countList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][1] isEqualToString:@"0"]) {
            
            receiveVC.tabBarItem.badgeValue = nil;
        }else{
            receiveVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][1];
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][2] isEqualToString:@"0"]) {
            completeVC.tabBarItem.badgeValue = nil;
        }else{
            completeVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][2];
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][3] isEqualToString:@"0"]) {
            robVC.tabBarItem.badgeValue = nil;
        }else{
            robVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][3];
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][0] isEqualToString:@"0"]) {
            allorderVC.tabBarItem.badgeValue = nil;
        }else{
            allorderVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - UIViewControllerTransitioningDelegate -

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:[PhoneNumberViewController class]]) {
        return [[PresentAnimation alloc]init];
    }else{
        return [ShareAnimation shareAnimationWithType:ShareAnimationTypePresent duration:0.15 presentHeight:258];
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:[PhoneNumberViewController class]]) {
        return [[DismissAnimation alloc]init];
    }else{
        return [ShareAnimation shareAnimationWithType:ShareAnimationTypeDismiss duration:0.05 presentHeight:258];
    }
    
}

- (NSArray *)detectQRCodeWithImage:(UIImage *)QRCodeImage {
    //通过type和options创建CIDetector的对象
    CIDetector *detector = [CIDetector
                            detectorOfType:CIDetectorTypeQRCode
                            context:nil
                            options:@{
                                      CIDetectorAccuracy:CIDetectorAccuracyLow
                                      }];
    
    CIImage *image = [CIImage imageWithCGImage:QRCodeImage.CGImage];
    NSArray *features = [detector featuresInImage:image];
    
    return features;
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = scale * CGRectGetWidth(extent);
    size_t height = scale * CGRectGetHeight(extent);
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
}


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"HomeVC dealloc");
}
@end
