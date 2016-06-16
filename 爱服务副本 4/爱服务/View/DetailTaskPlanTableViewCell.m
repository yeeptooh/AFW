//
//  DetailTaskPlanTableViewCell.m
//  WeiKe
//
//  Created by Ji_YuFeng on 15/11/26.
//  Copyright © 2015年 Ji_YuFeng. All rights reserved.
//

#import "DetailTaskPlanTableViewCell.h"
#import <MapKit/MapKit.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import "AFNetworking.h"
#import "UserModel.h"
@interface DetailTaskPlanTableViewCell ()
<
UIViewControllerTransitioningDelegate
>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) CTCallCenter *callCenter;


@end
@implementation DetailTaskPlanTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)phoneButtonClicked:(UIButton *)sender {
    
    NSString *phoneString = [NSString stringWithFormat:@"telprompt://%@",self.phoneLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
    
    [self detectCall];
}


-(void)detectCall {
    __weak typeof(self)weakSelf = self;
    UserModel *userModel = [UserModel readUserModel];
    self.callCenter = [[CTCallCenter alloc] init];
    self.callCenter.callEventHandler=^(CTCall* call) {
        
        if (call.callState == CTCallStateDisconnected) {
             //挂断
            
        }else if (call.callState == CTCallStateConnected) {
             //连通了
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSString *url = [NSString stringWithFormat:@"%@Task.ashx?action=callphone",HomeURL];
            NSDictionary *parameters = @{
                                         @"taskId":weakSelf.taskId,
                                         @"waitername":userModel.name,
                                         @"phone":weakSelf.phone
                                         };
            [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"responseObject = %@",responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error = %@",error.userInfo);
            }];
            
        }else if(call.callState == CTCallStateIncoming) {
            
        }else if (call.callState ==CTCallStateDialing) {
              //拨号
        }else {
            //NSLog(@"Nothing is done????????????2");
        }
    };
}



- (IBAction)messageButtonClicked:(UIButton *)sender {
    
    NSString *messageString = [NSString stringWithFormat:@"sms://%@",self.phoneLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:messageString]];
}


- (IBAction)mapButtonClicked:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:self.locationButton.titleLabel.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            //获取目的地地理坐标
            CLPlacemark *placemark = [placemarks lastObject];
            weakSelf.coordinate = placemark.location.coordinate;
            
        }];

        
        UIAlertAction *appleAction = [UIAlertAction actionWithTitle:@"使用苹果自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];

            [geocoder geocodeAddressString:self.locationButton.titleLabel.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
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
            baiduAction = [UIAlertAction actionWithTitle:@"使用百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",weakSelf.coordinate.latitude, weakSelf.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }];
        }
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            gdAction = [UIAlertAction actionWithTitle:@"使用高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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

        [[self viewController] presentViewController:actionSheet animated:YES completion:nil];
        
    }else{
        //创建CLGeocoder对象
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:self.locationButton.titleLabel.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
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

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end
