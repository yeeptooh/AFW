//
//  MapViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/5/27.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "AFNetworking.h"
#import "UserModel.h"
#import "MBProgressHUD.h"
//#define ButtonHeight 35

@interface MapViewController ()
<
MKMapViewDelegate
>

@property (nonatomic, strong) MKMapView *mapView;
@end

@implementation MapViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviTitle];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - TabbarHeight)];
    
    self.mapView.mapType = MKMapTypeStandard;
    
    //设置代理
    self.mapView.delegate = self;
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:[NSString stringWithFormat:@"%@%@%@",self.BuyerProvince,self.BuyerFullAddress_Incept,self.BuyerAddress] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark = [placemarks firstObject];
        CLLocationCoordinate2D coordinate = placemark.location.coordinate;
        
        // 添加MapView
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01); //比例
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);// 范围、区域
        [self.mapView setRegion:region]; //animated:YES];
        
        
        // 添加Annotation
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = [NSString stringWithFormat:@"%@ %@",self.BuyerProvince,self.BuyerFullAddress_Incept];
        annotation.subtitle = self.BuyerAddress;
        
        [self.mapView addAnnotation:annotation];
    }];
    
    [self.view addSubview:self.mapView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Height - StatusBarAndNavigationBarHeight - TabbarHeight, Width, TabbarHeight)];
    view.backgroundColor = color(230, 230, 230, 1);
    [self.view addSubview:view];
    
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    effectView.frame = view.bounds;
    [view addSubview:effectView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.6)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [effectView.contentView addSubview:lineView];
    
    UIButton *robButton = [UIButton buttonWithType:UIButtonTypeCustom];
    robButton.frame = CGRectMake(0, 0, Width, TabbarHeight);
    robButton.backgroundColor = MainBlueColor;
    [robButton setTitle:@"立即抢单" forState:UIControlStateNormal];
    [robButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [robButton addTarget:self action:@selector(robButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [effectView.contentView addSubview:robButton];
}

- (void)robButtonClicked {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    UserModel *userModel = [UserModel readUserModel];
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=grabsign&id=%@&comid=%ld&uid=%ld&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,self.ID,(long)userModel.comid,(long)userModel.uid,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:hud];
    [hud showAnimated:YES];
 
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
            NSLog(@"%@",error.userInfo);
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

//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//    switch (status) {
//        case kCLAuthorizationStatusNotDetermined://用户还未决定
//        {
//            NSLog(@"用户还未决定");
//            break;
//        }
//        case kCLAuthorizationStatusRestricted://访问受限
//        {
//            NSLog(@"访问受限");
//            break;
//        }
//        case kCLAuthorizationStatusDenied://定位关闭时或用户APP授权为永不授权时调用
//        {
//            NSLog(@"定位关闭或者用户未授权");
//            break;
//        }
//        case kCLAuthorizationStatusAuthorizedAlways://获取前后台定位授权
//        {
//            NSLog(@"获取前后台定位授权");
//            [self.locationManager startUpdatingLocation];
//            break;
//        }
//        case kCLAuthorizationStatusAuthorizedWhenInUse://获得前台定位授权
//        {
//            NSLog(@"获得前台定位授权");
//            [self.locationManager startUpdatingLocation];
//            break;
//        }
//        default:break;
//    }
//    
//}


//- (void)locationManager:(CLLocationManager *)manager
//     didUpdateLocations:(NSArray<CLLocation*> *)locations
//{
//    CLLocation *location = [locations firstObject];//取出第一个位置
//    /*
//     使用位置前, 务必判断当前获取的位置是否有效
//     如果水平精确度小于零, 代表虽然可以获取位置对象, 但是数据错误, 不可用
//     */
//    if (location.horizontalAccuracy < 0)
//        return;
//    CLLocationCoordinate2D coordinate = location.coordinate;//位置坐标
//    CGFloat longitude = coordinate.longitude;//经度
//    CGFloat latitude = coordinate.latitude;//纬度
//    CGFloat altitude = location.altitude;//海拔
//    CGFloat course = location.course;//方向
//    CGFloat speed = location.speed;//速度
//    NSLog(@"经度:%f,纬度:%f",longitude,latitude);
//    NSLog(@"海拔:%f,方向:%f,速度:%f",altitude,course,speed);
//    //如果不需要实时定位，使用完即使关闭定位服务
//    [self.locationManager stopUpdatingLocation];
//}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier:@"PIN_ANNOTATION"];
    }
    
    
    annotationView.pinColor = MKPinAnnotationColorRed;//标注点颜色
    annotationView.animatesDrop = YES;// 动画
    annotationView.canShowCallout = YES;//YES;// 插图编号

    
    return annotationView;
}



- (void)setNaviTitle {
    self.navigationItem.title = @"马上抢单";
}

@end
