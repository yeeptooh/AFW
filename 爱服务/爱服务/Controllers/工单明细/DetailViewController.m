//
//  DetailViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/14.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "DetailViewController.h"
#import "AFNetworking.h"
#import "UserModel.h"

#import "ButtonViewController.h"
#import "PTypeViewController.h"
#import "DatePickerViewController.h"
#import "DialogViewController.h"

#import "CompleteButtonViewController.h"
#import "ChargeBackViewController.h"
#import "RefuseViewController.h"
#import "AcceptViewController.h"
#import "DispatchViewController.h"

#import "DialogAnimation.h"
#import "ButtonPresentAnimation.h"
#import "ButtonDismissAnimation.h"

#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
//#define ButtonHeight 35
#if Environment_Mode == 1
#define BaseInfoViewHeight 150
#elif Environment_Mode == 2
#define BaseInfoViewHeight 144
#endif

#define SectionHeaderHeight 32
@interface DetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIViewControllerTransitioningDelegate
>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
#if Environment_Mode == 1
@property (nonatomic, strong) DetailTaskPlanTableViewCell *baseDetailInfoCell;
#elif Environment_Mode == 2
@property (nonatomic, strong) CSDetailTaskTableViewCell *baseDetailInfoCell;
#endif

@property (nonatomic, strong) ProductTableViewCell *cell;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIAlertController *alertController;

@property (nonatomic, strong) NSMutableArray *diaLogList;
@property (nonatomic, strong) NSMutableArray *CSList;
@end

@implementation DetailViewController

- (NSMutableArray *)CSList {
    if (!_CSList) {
        _CSList = [NSMutableArray array];
    }
    return _CSList;
}

- (NSMutableArray *)diaLogList {
    if (!_diaLogList) {
        _diaLogList = [NSMutableArray array];
    }
    return _diaLogList;
}

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


- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame;
        CGFloat height;
        if (iPhone4_4s || iPhone5_5s) {
            height = 35;
        }else {
            height = 44;
        }
        if (self.state == 4 || self.state == 5) {
            frame = CGRectMake(0, BaseInfoViewHeight, Width, Height - BaseInfoViewHeight - StatusBarAndNavigationBarHeight - height);
        }else{
            frame = CGRectMake(0, BaseInfoViewHeight, Width, Height - BaseInfoViewHeight - StatusBarAndNavigationBarHeight);
        }
        
        
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setNaviTitle];
    [self setBaseInfoView];
    [self setBottomButton];
    
}

- (void)setBaseInfoView {
#if Environment_Mode == 1
    self.baseDetailInfoCell = [[[NSBundle mainBundle] loadNibNamed:@"DetailTaskPlanTableViewCell" owner:self options:nil]lastObject];
    self.baseDetailInfoCell.frame = CGRectMake(0, 0, Width, BaseInfoViewHeight);
    self.baseDetailInfoCell.nameLabel.text = self.name;
    
    self.baseDetailInfoCell.taskId = [NSString stringWithFormat:@"%@",@(self.ID)];
    
    self.baseDetailInfoCell.phone = self.phone;
    
    [self.baseDetailInfoCell.dialogButton addTarget:self action:@selector(dialogButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.baseDetailInfoCell.mapButton addTarget:self action:@selector(mapButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.baseDetailInfoCell.phoneLabel.text = [NSString stringWithFormat:@"电话:  %@",self.phone];
    self.baseDetailInfoCell.fromLabel.text = self.from;
    self.baseDetailInfoCell.fromPhoneLabel.text = self.fromPhone;
    
    self.baseDetailInfoCell.priceLabel.text = self.price;
    
    [self.baseDetailInfoCell.locationButton setTitle:self.location forState:UIControlStateNormal];
    
    [self.baseDetailInfoCell.locationButton addTarget:self action:@selector(locationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.baseDetailInfoCell];
#elif Environment_Mode == 2
    self.baseDetailInfoCell = [[[NSBundle mainBundle] loadNibNamed:@"CSDetailTaskTableViewCell" owner:self options:nil]lastObject];
    self.baseDetailInfoCell.frame = CGRectMake(0, 0, Width, BaseInfoViewHeight);
    self.baseDetailInfoCell.nameLabel.text = self.name;
    self.baseDetailInfoCell.taskId = [NSString stringWithFormat:@"%@",@(self.ID)];
    self.baseDetailInfoCell.phone = self.phone;
    
    [self.baseDetailInfoCell.mapButton addTarget:self action:@selector(mapButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.baseDetailInfoCell.phoneLabel.text = self.phone;
    self.baseDetailInfoCell.fromLabel.text = self.from;
    self.baseDetailInfoCell.fromPhoneLabel.text = self.fromPhone;
    
    [self.baseDetailInfoCell.locationButton setTitle:self.location forState:UIControlStateNormal];
    
    [self.baseDetailInfoCell.locationButton addTarget:self action:@selector(locationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.baseDetailInfoCell];
#endif
    
    
}

- (void)dialogButtonClicked {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@Task.ashx?action=getfeedbacklist&taskid=%@",HomeURL,@(self.ID)];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (self.diaLogList.count != 0) {
            [self.diaLogList removeAllObjects];
        }
        
        for (NSDictionary *dic in responseObject) {
            [self.diaLogList addObject:dic];
        }
        
        DialogViewController *dialogVC = [[DialogViewController alloc] init];
        dialogVC.modalPresentationStyle = UIModalPresentationCustom;
        dialogVC.transitioningDelegate = self;
        dialogVC.dialogList = self.diaLogList;
        
        dialogVC.taskID = [NSString stringWithFormat:@"%@",@(self.ID)];
        dialogVC.fromUserName = self.fromUserName;
        dialogVC.fromUserID = self.fromUserID;
        dialogVC.toUserName = self.toUserName;
        dialogVC.toUserID = self.toUserID;
 
        [self presentViewController:dialogVC animated:YES completion:^{

        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error.userInfo);
    }];

}

- (void)mapButtonClick {
    
    __weak typeof(self) weakSelf = self;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {

        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:self.BuyerFullAddress_Incept completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            //获取目的地地理坐标
            CLPlacemark *placemark = [placemarks lastObject];
            weakSelf.coordinate = placemark.location.coordinate;

        }];


        UIAlertAction *appleAction = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];

            [geocoder geocodeAddressString:self.BuyerFullAddress_Incept completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                //获取目的地地理坐标
                CLPlacemark *placemark = [placemarks lastObject];
                //Mapkit框架下的地标
                MKPlacemark *mkPlacemark = [[MKPlacemark alloc] initWithPlacemark:placemark];
                //目的地的item
                MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:mkPlacemark];
                MKMapItem *currentmapItem = [MKMapItem mapItemForCurrentLocation];
                NSMutableDictionary *options = [NSMutableDictionary dictionary];
                //MKLaunchOptionsDirectionsModeDriving:导航类型设置为驾车模式
                options[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
                //设置地图显示类型为标准模式
                options[MKLaunchOptionsMapTypeKey] = @(MKMapTypeStandard);
                options[MKLaunchOptionsShowsTrafficKey] =@(YES);
                //打开苹果地图应用
                [MKMapItem openMapsWithItems:@[currentmapItem,mapItem] launchOptions:options];
            }];
        }];

        UIAlertAction *baiduAction;
        UIAlertAction *gdAction;
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            baiduAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",weakSelf.coordinate.latitude, weakSelf.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }];
        }

        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            gdAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"爱服务",@"",weakSelf.coordinate.latitude, weakSelf.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }];
        }

        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:appleAction];
        if (baiduAction) {
            [actionSheet addAction:baiduAction];
        }
        if (gdAction) {
            [actionSheet addAction:gdAction];
        }

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [actionSheet addAction:cancelAction];

        [self presentViewController:actionSheet animated:YES completion:nil];

    }else{
        //创建CLGeocoder对象
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:self.BuyerFullAddress_Incept completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            //获取目的地地理坐标
            CLPlacemark *placemark = [placemarks lastObject];
            //Mapkit框架下的地标
            MKPlacemark *mkPlacemark = [[MKPlacemark alloc] initWithPlacemark:placemark];
            //目的地的item
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:mkPlacemark];
            MKMapItem *currentmapItem = [MKMapItem mapItemForCurrentLocation];
            NSMutableDictionary *options = [NSMutableDictionary dictionary];
            //MKLaunchOptionsDirectionsModeDriving:导航类型设置为驾车模式
            options[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
            //设置地图显示类型为标准模式
            options[MKLaunchOptionsMapTypeKey] = @(MKMapTypeStandard);
            options[MKLaunchOptionsShowsTrafficKey] =@(YES);
            //打开苹果地图应用
            [MKMapItem openMapsWithItems:@[currentmapItem,mapItem] launchOptions:options];
        }];
    }
    
    
}

- (void)locationButtonClicked {
    
    ButtonViewController *buttonVC = [[ButtonViewController alloc]init];
    buttonVC.modalPresentationStyle = UIModalPresentationCustom;
    buttonVC.transitioningDelegate = self;
    buttonVC.text = self.baseDetailInfoCell.locationButton.titleLabel.text;
    buttonVC.ID = self.ID;
    
    __weak typeof(self) weakSelf = self;
    buttonVC.returnText = ^(NSString *text){
        [weakSelf.baseDetailInfoCell.locationButton setTitle:text forState:UIControlStateNormal];
    };
    
    [self presentViewController:buttonVC animated:YES completion:nil];
    

    
}

- (void)setBottomButton {
#if Environment_Mode == 1
    CGFloat height;
    if (iPhone4_4s || iPhone5_5s) {
        height = 35;
    }else {
        height = 44;
    }

    if (self.state == 4) {
        
        if (self.flag == 1) {
            
            UIButton *robButton = [UIButton buttonWithType:UIButtonTypeCustom];
            robButton.frame = CGRectMake(0, Height - StatusBarAndNavigationBarHeight - height, Width, height);
            robButton.backgroundColor = MainBlueColor;
            
            [robButton setTitle:@"立即抢单" forState:UIControlStateNormal];
            [robButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
            [robButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
            [robButton addTarget:self action:@selector(robButtonClicked) forControlEvents:UIControlEventTouchUpInside];

            [self.view addSubview:robButton];
            
        }else {
            
            UIButton *receiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            receiveButton.frame = CGRectMake(5, Height - StatusBarAndNavigationBarHeight - height, Width/2 - 10, height);
            receiveButton.backgroundColor = MainBlueColor;
            receiveButton.layer.cornerRadius = 3;
            receiveButton.layer.masksToBounds = YES;
            [receiveButton setTitle:@"接收" forState:UIControlStateNormal];
            [receiveButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
            [receiveButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
            [receiveButton addTarget:self action:@selector(receiveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:receiveButton];
            
            UIButton *refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            refuseButton.frame = CGRectMake(Width -5 - Width/2 + 10, Height - StatusBarAndNavigationBarHeight - height, Width/2 - 10, height);
            refuseButton.backgroundColor = MainBlueColor;
            refuseButton.layer.cornerRadius = 3;
            refuseButton.layer.masksToBounds = YES;
            [refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
            [refuseButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
            [refuseButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
            [refuseButton addTarget:self action:@selector(refuseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:refuseButton];
            
        }
        
    }else if (self.state == 5){
        
        UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        completeButton.frame = CGRectMake(5, Height - StatusBarAndNavigationBarHeight - height, Width/2 - 10, height);
        completeButton.backgroundColor = MainBlueColor;
        completeButton.layer.cornerRadius = 3;
        completeButton.layer.masksToBounds = YES;
        [completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [completeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
        [completeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
        [completeButton addTarget:self action:@selector(completeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:completeButton];
        
        UIButton *recedeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        recedeButton.frame = CGRectMake(Width - 5 - Width/2 + 10, Height - StatusBarAndNavigationBarHeight - height, Width/2 - 10, height);
        recedeButton.backgroundColor = MainBlueColor;
        recedeButton.layer.cornerRadius = 3;
        recedeButton.layer.masksToBounds = YES;
        [recedeButton setTitle:@"退单" forState:UIControlStateNormal];
        [recedeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
        [recedeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
        [recedeButton addTarget:self action:@selector(recedeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:recedeButton];
        
    }
#elif Environment_Mode == 2
    CGFloat height;
    if (iPhone4_4s || iPhone5_5s) {
        height = 35;
    }else {
        height = 44;
    }
    
    if (self.state == 1) {
        UIButton *dispatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dispatchButton.frame = CGRectMake(5, Height - StatusBarAndNavigationBarHeight - height, Width/2 - 10, height);
        dispatchButton.backgroundColor = BlueColor;
        dispatchButton.layer.cornerRadius = 3;
        dispatchButton.layer.masksToBounds = YES;
        [dispatchButton setTitle:@"派工" forState:UIControlStateNormal];
        [dispatchButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
        [dispatchButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
        [dispatchButton addTarget:self action:@selector(dispatchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dispatchButton];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(Width - 5 - Width/2 + 10, Height - StatusBarAndNavigationBarHeight - height, Width/2 - 10, height);
        cancelButton.backgroundColor = BlueColor;
        cancelButton.layer.cornerRadius = 3;
        cancelButton.layer.masksToBounds = YES;
        [cancelButton setTitle:@"撤销" forState:UIControlStateNormal];
        [cancelButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
        [cancelButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelButton];
        
    }else if (self.state == 2) {
        
        UIButton *dispatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dispatchButton.frame = CGRectMake(5, Height - StatusBarAndNavigationBarHeight - height, Width/2 - 10, height);
        dispatchButton.backgroundColor = BlueColor;
        dispatchButton.layer.cornerRadius = 3;
        dispatchButton.layer.masksToBounds = YES;
        [dispatchButton setTitle:@"付款" forState:UIControlStateNormal];
        [dispatchButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
        [dispatchButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
        [dispatchButton addTarget:self action:@selector(payButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dispatchButton];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(Width - 5 - Width/2 + 10, Height - StatusBarAndNavigationBarHeight - height, Width/2 - 10, height);
        cancelButton.backgroundColor = BlueColor;
        cancelButton.layer.cornerRadius = 3;
        cancelButton.layer.masksToBounds = YES;
        [cancelButton setTitle:@"撤销" forState:UIControlStateNormal];
        [cancelButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
        [cancelButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelButton];
        
    }else if (self.state == 4) {
        
        if (self.flag == 1) {
   
        }else {
            
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.frame = CGRectMake(0, Height - StatusBarAndNavigationBarHeight - height, Width, height);
            cancelButton.backgroundColor = BlueColor;
            
            [cancelButton setTitle:@"撤销" forState:UIControlStateNormal];
            [cancelButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
            [cancelButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
            [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:cancelButton];
            
        }
        
    }else if (self.state == 5){
    
    }else if (self.state == 6){
        
        UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        agreeButton.frame = CGRectMake(5, Height - StatusBarAndNavigationBarHeight - height, Width/2 - 10, height);
        agreeButton.backgroundColor = BlueColor;
        agreeButton.layer.cornerRadius = 3;
        agreeButton.layer.masksToBounds = YES;
        [agreeButton setTitle:@"付款" forState:UIControlStateNormal];
        [agreeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
        [agreeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
        [agreeButton addTarget:self action:@selector(agreeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:agreeButton];
        
        
        UIButton *disagreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        disagreeButton.frame = CGRectMake(Width - 5 - Width/2 + 10, Height - StatusBarAndNavigationBarHeight - height, Width/2 - 10, height);
        disagreeButton.backgroundColor = BlueColor;
        disagreeButton.layer.cornerRadius = 3;
        disagreeButton.layer.masksToBounds = YES;
        [disagreeButton setTitle:@"撤销" forState:UIControlStateNormal];
        [disagreeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
        [disagreeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
        [disagreeButton addTarget:self action:@selector(disagreeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:disagreeButton];
        
    }
#endif
    
}

- (void)agreeButtonClicked {
    
}

- (void)disagreeButtonClicked {
    
}

- (void)payButtonClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMoney object:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minSize = CGSizeMake(110, 100);
    hud.label.font = font(14);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=pay",HomeURL];
    NSDictionary *params =@{@"taskId":@(self.ID)};
    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"ret"] integerValue] == 1) {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
            UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = @"付款成功";
            [hud hideAnimated:YES afterDelay:1.25f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
        if ([responseObject[@"ret"] integerValue] == 0) {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
            
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            hud.detailsLabel.font = font(14);
            [hud hideAnimated:YES afterDelay:1.25f];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}

- (void)dispatchButtonClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMoney object:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minSize = CGSizeMake(110, 100);
    hud.label.font = font(14);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    UserModel *userModel = [UserModel readUserModel];
    
    NSString *URL = [NSString stringWithFormat:@"%@Common.ashx?action=getassigner&taskId=%@&comId=%@",HomeURL,@(self.ID),@(userModel.comid)];
    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if (self.CSList.count != 0) {
            [self.CSList removeAllObjects];
        }
        
        for (NSDictionary *dic in responseObject) {
            [self.CSList addObject:dic];
        }

        
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        [hud hideAnimated:YES];
        DispatchViewController *dispatchVC = [[DispatchViewController alloc] init];
        dispatchVC.List = self.CSList;
        dispatchVC.taskId = [NSString stringWithFormat:@"%@",@(self.ID)];
        dispatchVC.modalPresentationStyle = UIModalPresentationCustom;
        dispatchVC.transitioningDelegate = self;
        [self presentViewController:dispatchVC animated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"请检查网络", @"HUD completed title");
        [hud hideAnimated:YES afterDelay:0.75f];
        [hud removeFromSuperViewOnHide];
    }];
    
    
}

- (void)cancelButtonClicked {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minSize = CGSizeMake(100, 100);
    hud.label.font = font(14);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    UserModel *userModel = [UserModel readUserModel];
    //m:347,url中有中文
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=canceltask",HomeURL];
    
    NSDictionary *params = @{
                             @"taskId":@(self.ID),
                             @"comId":@(userModel.comid),
                             @"username":userModel.name
                             };
    
    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"撤销成功", @"HUD completed title");
        [hud hideAnimated:YES afterDelay:0.75f];
        [hud removeFromSuperViewOnHide];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"撤销失败", @"HUD completed title");
        [hud hideAnimated:YES afterDelay:0.75f];
        [hud removeFromSuperViewOnHide];
    }];
    
}

- (void)robButtonClicked {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:hud];
    [hud showAnimated:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    UserModel *userModel = [UserModel readUserModel];
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=grabsign&id=%ld&comid=%ld&uid=%ld&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)self.ID,(long)userModel.comid,(long)userModel.uid,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
    NSLog(@"%@",URL);

    [manager POST:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBadgeValueChanged object:nil];
        [hud hideAnimated:YES];
        [hud removeFromSuperViewOnHide];
        MBProgressHUD *successHUD = [[MBProgressHUD alloc] initWithView:self.view];
        successHUD.mode = MBProgressHUDModeText;
        successHUD.label.text = @"抢单成功";
        successHUD.label.font = font(14);
        [self.view addSubview:successHUD];
        [successHUD showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [successHUD hideAnimated:YES];
            [successHUD removeFromSuperViewOnHide];
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [hud hideAnimated:YES];
        [hud removeFromSuperViewOnHide];
        MBProgressHUD *successHUD = [[MBProgressHUD alloc] initWithView:self.view];
        successHUD.mode = MBProgressHUDModeText;
        successHUD.label.text = @"抢单失败,请检查网络";
        successHUD.label.font = font(14);
        [self.view addSubview:successHUD];
        [successHUD showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [successHUD hideAnimated:YES];
            [successHUD removeFromSuperViewOnHide];
            
            
        });
    }];
    
    
    
}

- (void)receiveButtonClicked {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    UserModel *userModel = [UserModel readUserModel];
    NSString *URL = [NSString stringWithFormat:@"%@Common.ashx?action=getwaiters&comid=%ld",HomeURL,(long)userModel.comid];
    NSLog(@"%@",URL);
    __weak typeof(self)weakSelf = self;
    
    [manager POST:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBadgeValueChanged object:nil];
        
        AcceptViewController *aVC = [[AcceptViewController alloc]init];
        for (NSDictionary *dic in responseObject) {
            [aVC.wList addObject:dic];
        }
        aVC.ID = weakSelf.ID;
        [weakSelf.navigationController pushViewController:aVC animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

- (void)refuseButtonClicked {
    RefuseViewController *rVC = [[RefuseViewController alloc]init];
    rVC.ID = self.ID;
    [self.navigationController pushViewController:rVC animated:YES];
}

- (void)completeButtonClicked {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AVCan"]) {
        CompleteButtonViewController *cbVC = [[CompleteButtonViewController alloc]init];
        cbVC.inOut = self.inOut;
        cbVC.ID = self.ID;
        
        [self.navigationController pushViewController:cbVC animated:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AVCan"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusAuthorized) {
            
            CompleteButtonViewController *cbVC = [[CompleteButtonViewController alloc]init];
            cbVC.inOut = self.inOut;
            cbVC.ID = self.ID;
            [self.navigationController pushViewController:cbVC animated:YES];
        }else {
            [self presentViewController:self.alertController animated:YES completion:nil];
        }
    }
}

- (void)recedeButtonClicked {
    
    ChargeBackViewController *cbVC = [[ChargeBackViewController alloc]init];
    cbVC.ID = self.ID;
    [self.navigationController pushViewController:cbVC animated:YES];
}


- (void)setNaviTitle {
    self.navigationItem.title = @"工单明细";
}

#pragma mark - UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
    //接口没做好，先只显示两个section
    if (self.state == 6 || self.state == 7 ||(self.state >= 10 && self.state <15)) {
        return 3;
    }else if (self.state >= 15) {
        return 4;
    }else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        self.cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductTableViewCell" owner:self options:nil] lastObject];
        
        [self.cell.typeButton setTitle:self.model forState:UIControlStateNormal];
        [self.cell.dateButton setTitle:self.buyDate forState:UIControlStateNormal];
        [self.cell.typeButton addTarget:self action:@selector(typeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.cell.dateButton addTarget:self action:@selector(dateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        self.cell.proTypeLabel.text = self.productType;
        self.cell.productCodeLabel.text = self.productCode;
        self.cell.orderCodeLabel.text = self.orderCode;
        self.cell.inOutLabel.text = self.inOut;
        self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.cell;
    }else if (indexPath.row == 1) {
        ServiceTypeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceTypeTableViewCell" owner:self options:nil] lastObject];
        if (!self.appointment) {
            self.appointment = @"";
        }
        cell.appointmentLabel.text = [NSString stringWithFormat:@"预约: %@",self.appointment];
        if (!self.servicePs || [self.servicePs isEqualToString:@""]) {
            self.servicePs = @" ";
        }
        
        cell.psLabel.text = [NSString stringWithFormat:@"备注: %@",self.servicePs];
        NSString *str = [self.serviceType substringFromIndex:1];
        NSInteger length = str.length;
        cell.serviceLabel.text = [str substringToIndex:length-1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 2) {
        if (self.state == 6) {
            ChargebackTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChargebackTableViewCell" owner:self options:nil] lastObject];
            cell.chargeBackContentLabel.text = self.chargeBackContent;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

            
        }else if (self.state == 7) {
            ChargebackTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChargebackTableViewCell" owner:self options:nil] lastObject];
            cell.chargeBackContentLabel.text = self.refuseContent;
            cell.chargeBackReasonLabel.text = @"拒绝理由";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if (self.state >= 10) {
            OverTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"OverTableViewCell" owner:self options:nil] lastObject];
            cell.overDateLabel.text = [NSString stringWithFormat:@"完工时间: %@",@"2015年12月12日"];//self.overDate;
            cell.psLabel.text = self.overPs;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
    }else{
        
        if (self.state >= 15) {
            AssessTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AssessTableViewCell" owner:self options:nil] lastObject];
            cell.assessLabel.text = self.serviceAssess;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 166;
    }else if (indexPath.row == 1) {
        if ([self.servicePs isEqualToString:@""]) {
            return 44;
        }
        return UITableViewAutomaticDimension;
    }else if (indexPath.row == 2) {
        if (self.state == 6) {
            if ([self.chargeBackContent isEqualToString:@""]) {
                return 44;
            }
            return UITableViewAutomaticDimension;
        }else if (self.state ==  7) {
            if ([self.chargeBackContent isEqualToString:@""]) {
                return 44;
            }
            return UITableViewAutomaticDimension;
        }else{
            if ([self.overPs isEqualToString:@""]) {
                return 44;
            }
            return UITableViewAutomaticDimension;
        }
    }else{
        if ([self.serviceAssess isEqualToString:@""]) {
            return 0;
        }
        
        return UITableViewAutomaticDimension;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, SectionHeaderHeight)];
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Width/4, SectionHeaderHeight)];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width - Width/2 - 10, 0, Width/2, SectionHeaderHeight)];
    typeLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:infoLabel];
    [headerView addSubview:typeLabel];
    infoLabel.font = font(16);
    typeLabel.font = font(16);
    if (section == 0) {
        infoLabel.text = @"产品信息";
        typeLabel.text = self.productType;
    }else if (section == 1) {
        infoLabel.text = @"业务信息";
        NSString *str = [self.serviceType substringFromIndex:1];
        NSInteger length = str.length;
        typeLabel.text = [str substringToIndex:length-1];
    }else if (section == 2) {
        if (self.state == 6) {
            infoLabel.text = @"退单信息";
        }else if (self.state == 7) {
            infoLabel.text = @"拒绝信息";
        }else {
            infoLabel.text = @"完工信息";
        }
    }else{
        infoLabel.text = @"服务评价";
    }
    headerView.backgroundColor = GrayColor;
    return headerView;
}


*/

- (void)typeButtonClicked {
    PTypeViewController *ptypeVC = [[PTypeViewController alloc]init];
    ptypeVC.modalPresentationStyle = UIModalPresentationCustom;
    ptypeVC.transitioningDelegate = self;
    ptypeVC.text = self.cell.typeButton.titleLabel.text;
    ptypeVC.ID = self.ID;
    
    __weak typeof(self) weakSelf = self;
    ptypeVC.returnText = ^(NSString *text){
        [weakSelf.cell.typeButton setTitle:text forState:UIControlStateNormal];
    };
    
    [self presentViewController:ptypeVC animated:YES completion:nil];
}

- (void)dateButtonClicked {
    DatePickerViewController *datePickerVC = [[DatePickerViewController alloc]init];
    datePickerVC.ID = self.ID;
    __weak typeof(self) weakSelf = self;

    datePickerVC.returnDate = ^(NSString *dateStr){
        NSString *year = [dateStr substringToIndex:4];
        NSString *month = [dateStr substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [dateStr substringFromIndex:8];

        NSString *date = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
        
        [weakSelf.cell.dateButton setTitle:date forState:UIControlStateNormal];
    };

    [self presentViewController:datePickerVC animated:YES completion:nil];

}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
//    NSLog(@"%@",[presented class]);
    if ([presented isKindOfClass:[DialogViewController class]] || [presented isKindOfClass:[DispatchViewController class]]) {
        return [DialogAnimation dialogAnimationWithType:DialogAnimationTypePresent duration:0.75];
    }else {
        return [[ButtonPresentAnimation alloc]init];
    }
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:[DialogViewController class]] || [dismissed isKindOfClass:[DispatchViewController class]]) {
        return [DialogAnimation dialogAnimationWithType:DialogAnimationTypeDismiss duration:0.75];
    }else {
        return [[ButtonDismissAnimation alloc]init];
    }
    
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
#if Environment_Mode == 1
#elif Environment_Mode == 2
- (void)backLastView:(UIBarButtonItem *)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.fromFuck == 1) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#endif


@end
