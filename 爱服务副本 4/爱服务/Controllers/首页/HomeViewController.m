//
//  HomeViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/9.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "HomeViewController.h"
#import "AFNetworking.h"
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
#import "MyAccountViewController.h"
#import "WithDrawViewController.h"
#import "ShareViewController.h"
#import "RechargeViewController.h"


#import <CoreLocation/CoreLocation.h>
#define  imageHeight 139
@interface HomeViewController ()
<
SDCycleScrollViewDelegate,
UIViewControllerTransitioningDelegate,
UINavigationControllerDelegate
>
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIView *balanceView;
@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end
static NSInteger tag = 0;
@implementation HomeViewController

- (UIView *)balanceView {
    if (!_balanceView) {
        CGFloat height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/8;
        _balanceView = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight, Width, height)];
        
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
    
    [self setNaviTitle];
    [self setScrollView];
    
    [self setDetailButton];
    [self setBreakLine];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 * 60 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
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
  
    [self setBalance];
    [self setBadgeValue];
    
}



- (void)upDateNetWorking {
    
    [self.HUD showAnimated:YES];
    
    NSDictionary *params = @{
                             @"name":[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
                             @"password":[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]
                             };
    NSString *URL = [NSString stringWithFormat:@"%@Passport.ashx?action=login",HomeURL];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
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
            [UserModel writeUserModel:userModel];
            
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
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
            
            
//            [manager GET:countString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSString *allString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//                NSArray *countList = [allString componentsSeparatedByString:@","];
//                
//                [[NSUserDefaults standardUserDefaults] setObject:countList forKey:@"countList"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//                [weakSelf.HUD hideAnimated:YES];
//                [weakSelf.HUD removeFromSuperViewOnHide];
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [weakSelf.HUD hideAnimated:YES];
//                [weakSelf.HUD removeFromSuperViewOnHide];
//            }];
            
            
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
    
    self.HUD = [[MBProgressHUD alloc]initWithView:self.view];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:self.HUD];
    
    [self upDateNetWorking];
    
    [self setBalance];
    [self setBadgeValue];
}

- (void)setNaviTitle {
    self.navigationItem.title = @"首页";
    
    UIImageView *logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainicon"]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:logoImageView];
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneButton setImage:[UIImage imageNamed:@"msg_room_toolbar_media_fct_notrace_norm_0"] forState:UIControlStateNormal];

    [phoneButton setImage:[UIImage imageNamed:@"msg_room_toolbar_media_fct_notrace_pres_0"] forState:UIControlStateHighlighted];
    phoneButton.frame = CGRectMake(0, 0, Width/10, StatusBarAndNavigationBarHeight);
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
    CGFloat height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/8;
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
    
    
    UIButton *drawMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    drawMoneyButton.frame = CGRectMake(Width*4/5, 0, Width/5, self.balanceView.bounds.size.height);
    [drawMoneyButton setTitle:@"提现" forState:UIControlStateNormal];
    [drawMoneyButton setTitleColor:color(80, 80, 80, 1) forState:UIControlStateNormal];
    [drawMoneyButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
//    drawMoneyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    
    CGFloat height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/8;
    UIView *containerView;
    if (iPhone4_4s) {
        containerView = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height, Width, height*7)];
    }else{
        containerView = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height, Width, height*6)];
    }
    
    
    [self.view addSubview:containerView];
    for (NSInteger i = 0; i < 3; i ++) {
        for (NSInteger j = 0;  j < 4; j ++) {
            self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.detailButton.tag = tag + 1000;
            tag ++;
            
            [self.detailButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"a%ld",(long)tag]] forState:UIControlStateNormal];
            if (i == 2) {
                if (j == 2 || j == 3) {
                    [self.detailButton setImage:nil forState:UIControlStateNormal];
                }
            }
            [self.detailButton addTarget:self action:@selector(detailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if (iPhone4_4s) {
                self.detailButton.frame = CGRectMake(Width*j/4, height*7*i/3, Width/4, height*6/3);
            }else {
                self.detailButton.frame = CGRectMake(Width*j/4, height*6*i/3, Width/4, height*6/3);
            }

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
//                [self.detailButton setTitle:@"我要充值" forState:UIControlStateNormal];
//                [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
//                [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
            }else if(self.detailButton.tag == 1011) {
//                [self.detailButton setTitle:@"爱心保" forState:UIControlStateNormal];
//                [self.detailButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
//                [self.detailButton setTitleColor:color(140, 140, 140, 1) forState:UIControlStateHighlighted];
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
    
    
}

- (void)setBreakLine {
    CGFloat height = (Height - StatusBarAndNavigationBarHeight - imageHeight - TabbarHeight)/8;
    
    if (iPhone4_4s) {
        UIView *H1Line = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height + height*7/3-0.5, Width, 0.5)];
        H1Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:H1Line];
        
        UIView *H2Line = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height + height*7*2/3-0.5, Width, 0.5)];
        H2Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:H2Line];
        
        
        UIView *V1Line = [[UIView alloc]initWithFrame:CGRectMake(Width/4-0.5, imageHeight + height, 0.5, height*7)];
        V1Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V1Line];
        
        UIView *V2Line = [[UIView alloc]initWithFrame:CGRectMake(Width*2/4-0.5, imageHeight + height, 0.5, height*7)];
        V2Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V2Line];
        
        UIView *V3Line = [[UIView alloc]initWithFrame:CGRectMake(Width*3/4-0.5, imageHeight + height, 0.5, height*7)];
        V3Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V3Line];
    }else{
        UIView *H1Line = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height + height * 6 / 3 - 0.5, Width, 0.5)];
        H1Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:H1Line];
        
        UIView *H2Line = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height + height * 6 * 2 / 3 - 0.5, Width, 0.5)];
        H2Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:H2Line];
        
        UIView *H3Line = [[UIView alloc]initWithFrame:CGRectMake(0, imageHeight + height + height * 6 - 0.5, Width, 0.5)];
        H3Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:H3Line];
        
        
        UIView *V1Line = [[UIView alloc]initWithFrame:CGRectMake(Width / 4 - 0.5, imageHeight + height, 0.5, height * 6)];
        V1Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V1Line];
        
        UIView *V2Line = [[UIView alloc]initWithFrame:CGRectMake(Width * 2 / 4 - 0.5, imageHeight + height, 0.5, height * 6)];
        V2Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V2Line];
        
        UIView *V3Line = [[UIView alloc]initWithFrame:CGRectMake(Width * 3 / 4 - 0.5, imageHeight + height, 0.5, height * 6)];
        V3Line.backgroundColor = color(200, 200, 200, 1);
        [self.view addSubview:V3Line];
    }
    
}

#pragma mark - buttonClicked -
- (void)drawMoneyButtonClicked {
    
    WithDrawViewController *withDrawVC = [[WithDrawViewController alloc]init];
    withDrawVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:withDrawVC animated:YES];

}

- (void)detailButtonClicked:(UIButton *)sender {
    if (sender.tag == 1000) {
        PartsRequestViewController *partsRequestVC = [[PartsRequestViewController alloc]init];
        partsRequestVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:partsRequestVC animated:YES];
        
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
        
        QRCodeViewController *qrcodeVC = [[QRCodeViewController alloc]init];
        qrcodeVC.hidesBottomBarWhenPushed = YES;
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
//        RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
//        rechargeVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:rechargeVC animated:YES];
        
    }else if (sender.tag == 1011) {
        
        
    }
    
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

- (void) dealloc {
    NSLog(@"HomeVC dealloc");
}
@end
