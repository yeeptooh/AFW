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
#import "ChangeOrderViewController.h"
#import "PartsRequestViewController.h"
#import "AppendFeesViewController.h"
#import "ChangeImageViewController.h"

#import "DialogAnimation.h"
#import "ButtonPresentAnimation.h"
#import "ButtonDismissAnimation.h"

#import "AddOrderViewController.h"


#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>

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
@property (nonatomic, strong) CTCallCenter *callCenter;
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
#if Environment_Mode == 1
        if (self.state == 4 || self.state == 5 || self.state >= 10) {
            frame = CGRectMake(0, BaseInfoViewHeight, Width, Height - BaseInfoViewHeight - StatusBarAndNavigationBarHeight - TabbarHeight);
        }else{
            frame = CGRectMake(0, BaseInfoViewHeight, Width, Height - BaseInfoViewHeight - StatusBarAndNavigationBarHeight);
        }
#elif Environment_Mode == 2
        if (self.state == 1 || self.state == 2 || self.state == 3 || self.state == 4 || self.state == 6) {
            frame = CGRectMake(0, BaseInfoViewHeight, Width, Height - BaseInfoViewHeight - StatusBarAndNavigationBarHeight - TabbarHeight + 0.6);
        }else{
            frame = CGRectMake(0, BaseInfoViewHeight, Width, Height - BaseInfoViewHeight - StatusBarAndNavigationBarHeight);
        }
#endif
        
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
    
    [self.baseDetailInfoCell.phoneButton addTarget:self action:@selector(phoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.baseDetailInfoCell.mailButton addTarget:self action:@selector(mailButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.baseDetailInfoCell.dialogButton addTarget:self action:@selector(dialogButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.baseDetailInfoCell.mapButton addTarget:self action:@selector(mapButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.baseDetailInfoCell.phoneLabel.text = [NSString stringWithFormat:@"电话:  %@",self.phone];
    self.baseDetailInfoCell.fromLabel.text = self.from;
    self.baseDetailInfoCell.fromPhoneLabel.text = self.fromPhone;
    
    self.baseDetailInfoCell.priceLabel.text = self.price;
    
    [self.baseDetailInfoCell.locationButton setTitle:self.location forState:UIControlStateNormal];
    if (self.state >= 15) {
        self.baseDetailInfoCell.locationButton.enabled = NO;
    }else {
        [self.baseDetailInfoCell.locationButton addTarget:self action:@selector(locationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
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
    
    if (self.state >= 15) {
        self.baseDetailInfoCell.locationButton.enabled = NO;
    }else {
        [self.baseDetailInfoCell.locationButton addTarget:self action:@selector(locationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:self.baseDetailInfoCell];
#endif
    
    
}


- (void)phoneButtonClicked {
    NSString *phoneString = [NSString stringWithFormat:@"telprompt://%@",self.phone];
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
                                         @"taskId":@(weakSelf.ID),
                                         @"waitername":userModel.name,
                                         @"phone":weakSelf.phone
                                         };
            [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error = %@",error.userInfo);
            }];
            
        }else if(call.callState == CTCallStateIncoming) {
            
        }else if (call.callState ==CTCallStateDialing) {
            //拨号
        }else {
            
        }
    };
}



- (void)mailButtonClicked {
    NSString *messageString = [NSString stringWithFormat:@"sms://%@",self.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:messageString]];
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

    if (self.state == 4) {
        
        if (self.flag == 1) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Height - StatusBarAndNavigationBarHeight - TabbarHeight-1.2, Width, TabbarHeight+1.2)];
            view.backgroundColor = color(230, 230, 230, 1);
            [self.view addSubview:view];
            
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
            effectView.frame = view.bounds;
            [view addSubview:effectView];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.6)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [effectView.contentView addSubview:lineView];
            
            UIButton *robButton = [UIButton buttonWithType:UIButtonTypeCustom];
            robButton.frame = CGRectMake(0, 0, Width, TabbarHeight+1.2);
//            robButton.titleLabel.font = font(12);
            [robButton setTitle:@"立即抢单" forState:UIControlStateNormal];
            [robButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            robButton.backgroundColor = MainBlueColor;
            [robButton addTarget:self action:@selector(robButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [effectView.contentView addSubview:robButton];
            
        }else {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Height - StatusBarAndNavigationBarHeight - TabbarHeight-1.2, Width, TabbarHeight+1.2)];
            view.backgroundColor = color(230, 230, 230, 1);
            [self.view addSubview:view];
            
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
            effectView.frame = view.bounds;
            [view addSubview:effectView];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.6)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [effectView.contentView addSubview:lineView];
            
            UIButton *receiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            receiveButton.frame = CGRectMake(0, 0, Width/2, TabbarHeight+1.2);
            [receiveButton setTitle:@"接收" forState:UIControlStateNormal];

            [receiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            receiveButton.backgroundColor = MainBlueColor;
            
            [receiveButton addTarget:self action:@selector(receiveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [effectView.contentView addSubview:receiveButton];
            
            UIButton *refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            refuseButton.frame = CGRectMake(Width/2, 0, Width/2, TabbarHeight+1.2);
            [refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
            [refuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            refuseButton.backgroundColor = MainBlueColor;
            [refuseButton addTarget:self action:@selector(refuseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [effectView.contentView addSubview:refuseButton];
            
            UIView *colView = [[UIView alloc] initWithFrame:CGRectMake(Width/2-0.7, 15, 1.4, TabbarHeight - 30)];
            colView.backgroundColor = [UIColor whiteColor];
            [effectView.contentView addSubview:colView];
            
        }
        
    }else if (self.state == 5){
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Height - StatusBarAndNavigationBarHeight - TabbarHeight-1.2, Width, TabbarHeight+1.2)];
        view.backgroundColor = color(230, 230, 230, 1);
        [self.view addSubview:view];
        
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        effectView.frame = view.bounds;
        [view addSubview:effectView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.6)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [effectView.contentView addSubview:lineView];
        
        UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        completeButton.frame = CGRectMake(0, 0, Width/4, TabbarHeight+1.2);
        completeButton.backgroundColor = MainBlueColor;
        [completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        completeButton.titleLabel.font = font(13);
        [completeButton addTarget:self action:@selector(completeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [effectView.contentView addSubview:completeButton];
        
        UIButton *recedeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        recedeButton.frame = CGRectMake(Width/4, 0, Width/4, TabbarHeight+1.2);
        recedeButton.backgroundColor = MainBlueColor;
        [recedeButton setTitle:@"退单" forState:UIControlStateNormal];
        [recedeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        recedeButton.titleLabel.font = font(13);
        [recedeButton addTarget:self action:@selector(recedeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [effectView.contentView addSubview:recedeButton];
        
        
        UIButton *requestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        requestButton.frame = CGRectMake(Width/2, 0, Width/4, TabbarHeight+1.2);
        [requestButton setTitle:@"申请配件" forState:UIControlStateNormal];
        [requestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        requestButton.titleLabel.font = font(13);
        requestButton.backgroundColor = MainBlueColor;
        [requestButton addTarget:self action:@selector(requestButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [effectView.contentView addSubview:requestButton];
        
        
        UIButton *appendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        appendButton.frame = CGRectMake(Width*3/4, 0, Width/4, TabbarHeight+1.2);
        
        [appendButton setTitle:@"追加费用" forState:UIControlStateNormal];
        [appendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        appendButton.titleLabel.font = font(13);
        appendButton.backgroundColor = MainBlueColor;
        [appendButton addTarget:self action:@selector(appendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [effectView.contentView addSubview:appendButton];
        
        UIView *colView1 = [[UIView alloc] initWithFrame:CGRectMake(Width/4-0.5, 15, 1, TabbarHeight - 30)];
        colView1.backgroundColor = [UIColor whiteColor];
        [effectView.contentView addSubview:colView1];
        
        UIView *colView2 = [[UIView alloc] initWithFrame:CGRectMake(Width/2-0.5, 15, 1, TabbarHeight - 30)];
        colView2.backgroundColor = [UIColor whiteColor];
        [effectView.contentView addSubview:colView2];
        
        UIView *colView3 = [[UIView alloc] initWithFrame:CGRectMake(Width*3/4-0.5, 15, 1, TabbarHeight - 30)];
        colView3.backgroundColor = [UIColor whiteColor];
        [effectView.contentView addSubview:colView3];
        
    }else if (self.state >= 10) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Height - StatusBarAndNavigationBarHeight - TabbarHeight - 1.2, Width, TabbarHeight+1.2)];
        view.backgroundColor = color(230, 230, 230, 1);
        [self.view addSubview:view];
        
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        effectView.frame = view.bounds;
        [view addSubview:effectView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.6)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [effectView.contentView addSubview:lineView];
        
        UIButton *exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        exchangeButton.frame = CGRectMake(0, 0, Width, TabbarHeight+1.2);
        //            robButton.titleLabel.font = font(12);
        [exchangeButton setTitle:@"添加图片" forState:UIControlStateNormal];
        [exchangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        exchangeButton.backgroundColor = MainBlueColor;
        [exchangeButton addTarget:self action:@selector(exchangeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [effectView.contentView addSubview:exchangeButton];
    }
#elif Environment_Mode == 2
    
    if (self.state == 1 || self.state == 3) {
        //待分配
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Height - StatusBarAndNavigationBarHeight - TabbarHeight, Width, TabbarHeight)];
        view.backgroundColor = color(230, 230, 230, 1);
        [self.view addSubview:view];
        
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        effectView.frame = view.bounds;
        [view addSubview:effectView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.6)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [effectView.contentView addSubview:lineView];
        
        UIButton *dispatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dispatchButton.frame = CGRectMake(0, 0, Width/2, TabbarHeight);
        [dispatchButton setTitle:@"派工" forState:UIControlStateNormal];
        [dispatchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        dispatchButton.backgroundColor = MainBlueColor;
        [dispatchButton addTarget:self action:@selector(dispatchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [effectView.contentView addSubview:dispatchButton];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(Width/2, 0, Width/2, TabbarHeight);
        [cancelButton setTitle:@"撤销" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelButton.backgroundColor = MainBlueColor;
        [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [effectView.contentView addSubview:cancelButton];
        
        UIView *colView = [[UIView alloc] initWithFrame:CGRectMake(Width/2-0.7, 15, 1.4, TabbarHeight - 30)];
        colView.backgroundColor = [UIColor whiteColor];
        [effectView.contentView addSubview:colView];
        
    }else if (self.state == 2) {
        //代付款
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Height - StatusBarAndNavigationBarHeight - TabbarHeight, Width, TabbarHeight)];
        view.backgroundColor = color(230, 230, 230, 1);
        [self.view addSubview:view];
        
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        effectView.frame = view.bounds;
        [view addSubview:effectView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.6)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [effectView.contentView addSubview:lineView];
        
        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        payButton.frame = CGRectMake(0, 0, Width/2, TabbarHeight);
        
        [payButton setTitle:@"付款" forState:UIControlStateNormal];
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        payButton.backgroundColor = MainBlueColor;
        [payButton addTarget:self action:@selector(payButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [effectView.contentView addSubview:payButton];
        
        UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        changeButton.frame = CGRectMake(Width/2, 0, Width/2, TabbarHeight);
        [changeButton setTitle:@"修改" forState:UIControlStateNormal];
        [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        changeButton.backgroundColor = MainBlueColor;
        [changeButton addTarget:self action:@selector(changeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [effectView.contentView addSubview:changeButton];
        
        UIView *colView = [[UIView alloc] initWithFrame:CGRectMake(Width/2-0.7, 15, 1.4, TabbarHeight - 30)];
        colView.backgroundColor = [UIColor whiteColor];
        [effectView.contentView addSubview:colView];
        
    }else if (self.state == 4) {
        //待接收
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Height - StatusBarAndNavigationBarHeight - TabbarHeight, Width, TabbarHeight)];
        view.backgroundColor = color(230, 230, 230, 1);
        [self.view addSubview:view];
        
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        effectView.frame = view.bounds;
        [view addSubview:effectView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.6)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [effectView.contentView addSubview:lineView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, Width, TabbarHeight);
        
        [cancelButton setTitle:@"撤销" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelButton.backgroundColor = MainBlueColor;
        [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [effectView.contentView addSubview:cancelButton];
        
    }else if (self.state == 5){
    //待完成
    }else if (self.state == 6){
        //退单中
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Height - StatusBarAndNavigationBarHeight - TabbarHeight, Width, TabbarHeight)];
        view.backgroundColor = color(230, 230, 230, 1);
        [self.view addSubview:view];
        
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        effectView.frame = view.bounds;
        [view addSubview:effectView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.6)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [effectView.contentView addSubview:lineView];
        
        UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        agreeButton.frame = CGRectMake(0, 0, Width/2, TabbarHeight);
        [agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        agreeButton.backgroundColor = MainBlueColor;
        [agreeButton addTarget:self action:@selector(agreeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [effectView.contentView addSubview:agreeButton];
        
        UIButton *disagreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        disagreeButton.frame = CGRectMake(Width/2, 0, Width/2, TabbarHeight);
        [disagreeButton setTitle:@"不同意" forState:UIControlStateNormal];
        [disagreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        disagreeButton.backgroundColor = MainBlueColor;
        [disagreeButton addTarget:self action:@selector(disagreeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [effectView.contentView addSubview:disagreeButton];
        
        UIView *colView = [[UIView alloc] initWithFrame:CGRectMake(Width/2-0.7, 15, 1.4, TabbarHeight - 30)];
        colView.backgroundColor = [UIColor whiteColor];
        [effectView.contentView addSubview:colView];
        
    }else if (self.state == 7){
            //已拒绝
    }else if (self.state == 10){
        //带确认
    }else if (self.state == 15){
        //已评价
        //17 已录入
    }
#endif
    
}


- (void)exchangeButtonClicked {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    ChangeImageViewController *changeImageVC = [[ChangeImageViewController alloc] init];
    UserModel *userModel = [UserModel readUserModel];
    NSString *URL= [NSString stringWithFormat:@"%@task.ashx?action=gettaskfile&taskid=%@&comid=%@",HomeURL, @(self.ID),@(userModel.comid)];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSMutableArray *photoList = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            [photoList addObject:dic[@"fileUrl"]];
        }
        for (NSInteger i = 0; i < photoList.count; i++) {
            if ([photoList[i] isEqualToString:@""]) {
                [photoList removeObjectAtIndex:i];
            }
        }
        
        changeImageVC.taskID = [NSString stringWithFormat:@"%@",@(self.ID)];
        changeImageVC.array = photoList;
        if (photoList.count >= 9) {
            changeImageVC.uploadCount = 0;
            changeImageVC.count = 0;
            changeImageVC.display = YES;
        }else {
            changeImageVC.uploadCount = photoList.count;
            changeImageVC.count = photoList.count;
            changeImageVC.display = NO;
        }
        
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        
        [hud hideAnimated:YES];
        [hud removeFromSuperViewOnHide];
        [self.navigationController pushViewController:changeImageVC animated:YES];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"请检查网络", @"HUD completed title");
        [hud hideAnimated:YES afterDelay:1.5f];
        [hud removeFromSuperViewOnHide];
    }];
}


- (void)requestButtonClicked {
    
    UserModel *userModel = [UserModel readUserModel];
    PartsRequestViewController *partVC = [[PartsRequestViewController alloc] init];
    partVC.flag = 1;
    partVC.ID = [NSString stringWithFormat:@"%@",@(self.ID)];
    partVC.brand = self.productBreed;
    partVC.type = self.productClassify;
    partVC.model = self.model;
    partVC.WaiterName = self.waiterName;
    partVC.ToUserID = self.toUserID;
    partVC.ToUserName = self.toUserName;
    partVC.FromUserID = self.fromUserID;
    partVC.FromUserName = self.fromUserName;
    partVC.HandlerID = [NSString stringWithFormat:@"%@",@(userModel.uid)];
    partVC.HandlerName = userModel.name;
    partVC.ProductBreedID = self.ProductBreedID;
    partVC.brand = self.productBreed;
    partVC.ProductClassify1ID = self.ProductClassify1ID;
    partVC.ProductClassify2ID = self.ProductClassify2ID;
    partVC.ProductClassify2Name = self.ProductClassify2Name;
    
    [self.navigationController pushViewController:partVC animated:YES];
}

- (void)appendButtonClicked {
    
    if ([self.payMoney integerValue] <= 0) {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        HUD.mode = MBProgressHUDModeText;
        HUD.label.text = @"无法追加";
        CGFloat fontsize;
        if (iPhone4_4s || iPhone5_5s) {
            fontsize = 14;
        }else{
            fontsize = 16;
        }
        HUD.label.font = font(fontsize);
        
        [HUD hideAnimated:YES afterDelay:1.0];
        return;
    }
    
    if ([self.addMoney integerValue] > 0) {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HUD.mode = MBProgressHUDModeText;
        HUD.label.text = @"已经追加,无法再次追加";
        CGFloat fontsize;
        if (iPhone4_4s || iPhone5_5s) {
            fontsize = 14;
        }else{
            fontsize = 16;
        }
        HUD.label.font = font(fontsize);
        
        [HUD hideAnimated:YES afterDelay:1.f];
        return;
    }
    
    AppendFeesViewController *appendVC = [[AppendFeesViewController alloc] init];
    appendVC.flag = 1;
    appendVC.ID = [NSString stringWithFormat:@"%@",@(self.ID)];
    appendVC.name = self.name;
    appendVC.address = self.location;
    appendVC.product = self.product;
    appendVC.price = self.productPrice;
    appendVC.comid = self.fromUserID;
    [self.navigationController pushViewController:appendVC animated:YES];
}

- (void)changeButtonClicked {
    
    ChangeOrderViewController *changeVC = [[ChangeOrderViewController alloc] init];
    changeVC.ID = self.ID;
    changeVC.userTableView.name = self.name;
    changeVC.userTableView.phone = self.phone;
    changeVC.userTableView.province = self.buyerProvince;
    changeVC.userTableView.city = self.buyerCity;
    changeVC.userTableView.district = self.buyerDistrict;
    changeVC.userTableView.town = self.buyerTown;
    changeVC.userTableView.address = self.buyerAddress;
    
    changeVC.userTableView.FprovinceID = self.buyerProvinceID;
    changeVC.userTableView.FcityID = self.buyerCityID;
    changeVC.userTableView.FregionID = self.buyerDistrictID;
    changeVC.userTableView.FstreetID = self.buyerTownID;
    
    changeVC.productTableView.productBreed = self.productBreed;
    changeVC.productTableView.ProductBreedID = self.ProductBreedID;
    changeVC.productTableView.productClassify = self.productClassify;
    changeVC.productTableView.ProductClassify1ID = self.ProductClassify1ID;
    changeVC.productTableView.ProductClassify2ID = self.ProductClassify2ID;
    changeVC.productTableView.orderNumber = self.orderNumber;
    
    changeVC.productTableView.FtypeID = self.ProductBreedID;
    changeVC.productTableView.FbigID = self.ProductClassify1ID;
    changeVC.productTableView.FsmallID = self.ProductClassify2ID;
    
    changeVC.productTableView.inOut = self.inOut;
    changeVC.productTableView.buyDate = self.buyDate;
    
    changeVC.businessTableView.serviceClassify = self.serviceClassify;
    changeVC.businessTableView.appointment = self.appointment;
    changeVC.businessTableView.postScript = self.postScript;
    changeVC.isFree = self.isFree;
    changeVC.businessTableView.serviceID = [self.serviceClassifyID integerValue];
    [self.navigationController pushViewController:changeVC animated:YES];
}

- (void)agreeButtonClicked {
    UserModel *userModel = [UserModel readUserModel];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minSize = CGSizeMake(110, 100);
    hud.label.font = font(14);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=backtrack",HomeURL];
    NSDictionary *params =@{
                            @"userId":@(userModel.uid),
                            @"taskId":@(self.ID)
                            };
    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([string isEqualToString:@"1"]) {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
            UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = @"同意成功";
            [hud hideAnimated:YES afterDelay:1.25f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
            UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = @"同意失败";
            [hud hideAnimated:YES afterDelay:1.25f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = @"同意失败";
        [hud hideAnimated:YES afterDelay:1.25f];
        
    }];
}

- (void)disagreeButtonClicked {
    UserModel *userModel = [UserModel readUserModel];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minSize = CGSizeMake(110, 100);
    hud.label.font = font(14);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=notbacktrack",HomeURL];
    NSDictionary *params =@{
                            @"userId":@(userModel.uid),
                            @"taskId":@(self.ID)
                            };
    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([string isEqualToString:@"1"]) {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
            UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = @"不同意成功";
            [hud hideAnimated:YES afterDelay:1.25f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
            UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = @"不同意失败";
            [hud hideAnimated:YES afterDelay:1.25f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = @"不同意失败";
        [hud hideAnimated:YES afterDelay:1.25f];
        
    }];
}

- (void)payButtonClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMoney object:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minSize = CGSizeMake(110, 100);
    hud.label.font = font(14);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=pay",HomeURL];
    NSDictionary *params =@{
                            @"taskId":@(self.ID)
                            };
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
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMoney object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
        if ([responseObject[@"ret"] integerValue] == 0) {
            [hud hideAnimated:YES];
            MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            hud1.mode = MBProgressHUDModeText;
            hud1.detailsLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            hud1.detailsLabel.font = font(14);
            [hud1 hideAnimated:YES afterDelay:1.25f];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = @"付款失败";
        [hud hideAnimated:YES afterDelay:1.25f];
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
    NSString *str = [self.serviceType substringFromIndex:1];
    NSInteger length = str.length;
    NSString *type = [str substringToIndex:length-1];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AVCan"]) {
        CompleteButtonViewController *cbVC = [[CompleteButtonViewController alloc]init];
        cbVC.inOut = self.inOut;
        cbVC.ID = self.ID;
        cbVC.type = type;
        [self.navigationController pushViewController:cbVC animated:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AVCan"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusAuthorized) {
            
            CompleteButtonViewController *cbVC = [[CompleteButtonViewController alloc]init];
            cbVC.inOut = self.inOut;
            cbVC.ID = self.ID;
            cbVC.type = type;
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
#if Environment_Mode == 1

    if (self.state == 6 || self.state == 7 ||(self.state >= 10 && self.state <15)) {
        return 4;
    }else if (self.state >= 15) {
        return 5;
    }else {
        return 3;
    }
#elif Environment_Mode == 2
    NSInteger i = 0;
    
    if ([self.priceStr floatValue] > 0) {
        i = 1;
    }else {
        i = 0;
    }
 
    if (self.state >= 10 && self.state <15) {
        return 3 + i;
    }else if (self.state >= 15) {
        return 4 + i;
    }else {
        return 2 + i;
    }
#endif
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#if Environment_Mode == 1

    if (indexPath.row == 0) {
        
        self.cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductTableViewCell" owner:self options:nil] lastObject];
        
        [self.cell.typeButton setTitle:self.model forState:UIControlStateNormal];
        [self.cell.dateButton setTitle:self.buyDate forState:UIControlStateNormal];
        
        if (self.state >= 15) {
            self.cell.typeButton.enabled = NO;
            self.cell.dateButton.enabled = NO;
            [self.cell.typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.cell.dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else {
            [self.cell.typeButton addTarget:self action:@selector(typeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.cell.dateButton addTarget:self action:@selector(dateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        }
        
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
        SettleAccountsTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SettleAccountsTableViewCell" owner:self options:nil] lastObject];
        if (!self.settleAccount) {
            self.settleAccount = @"";
        }
        cell.settleAccountLabel.text = [NSString stringWithFormat:@"要求: %@",self.settleAccount];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.row == 3) {
        if (self.state == 6) {
            RefuseTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"RefuseTableViewCell" owner:self options:nil] lastObject];
            if ([self.chargeBackContent isEqualToString:@""] || !self.chargeBackContent) {
                cell.refuseLabel.text = @"退单理由";
            }else {
                cell.refuseLabel.text = [NSString stringWithFormat:@"退单理由: %@",self.chargeBackContent];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

            
        }else if (self.state == 7) {
            ChargebackTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChargebackTableViewCell" owner:self options:nil] lastObject];
            if ([self.refuseContent isEqualToString:@""] || !self.refuseContent) {
                cell.chargeBackContentLabel.text = @"拒绝理由: ";
            }else {
                cell.chargeBackContentLabel.text = [NSString stringWithFormat:@"拒绝理由: %@",self.refuseContent];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if (self.state >= 10) {
            OverTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"OverTableViewCell" owner:self options:nil] lastObject];
            cell.overDateLabel.text = [NSString stringWithFormat:@"完工时间: %@",self.FinishTime];
            if ([self.overPs isEqualToString:@""] || !self.overPs) {
                cell.psLabel.text = @"备注: ";
            }else if ([self.overPs containsString:@"备注"]) {
                cell.psLabel.text = [NSString stringWithFormat:@"%@",self.overPs];
            }else {
                cell.psLabel.text = [NSString stringWithFormat:@"备注: %@",self.overPs];
            }
            cell.nameLabel.text = self.waiterName;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
    }else{
        
        if (self.state >= 15) {
            AssessTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AssessTableViewCell" owner:self options:nil] lastObject];
            if ([self.serviceAssess isEqualToString:@""] || !self.serviceAssess) {
                self.serviceAssess = @"备注: ";
                cell.assessLabel.text = self.serviceAssess;
            }else if ([self.serviceAssess containsString:@"备注"]) {
                cell.assessLabel.text = self.serviceAssess;
            }else {
                cell.assessLabel.text = [NSString stringWithFormat:@"备注: %@",self.serviceAssess];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
#elif Environment_Mode == 2
    
    if (indexPath.row == 0) {
        
        self.cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductTableViewCell" owner:self options:nil] lastObject];
        
        
        if (self.state >= 15) {
            self.cell.typeButton.enabled = NO;
            self.cell.dateButton.enabled = NO;
            [self.cell.typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.cell.dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else {
            [self.cell.typeButton addTarget:self action:@selector(typeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.cell.dateButton addTarget:self action:@selector(dateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.cell.proTypeLabel.text = self.productType;
        self.cell.productCodeLabel.text = self.productCode;
        self.cell.orderCodeLabel.text = @"";//self.model;
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
            RefuseTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"RefuseTableViewCell" owner:self options:nil] lastObject];
            if ([self.chargeBackContent isEqualToString:@""] || !self.chargeBackContent) {
                cell.refuseLabel.text = @"退单理由";
            }else {
                cell.refuseLabel.text = [NSString stringWithFormat:@"退单理由: %@",self.chargeBackContent];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if (self.state == 7) {
            ChargebackTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChargebackTableViewCell" owner:self options:nil] lastObject];
            if ([self.refuseContent isEqualToString:@""] || !self.refuseContent) {
                cell.chargeBackContentLabel.text = @"拒绝理由: ";
            }else {
                cell.chargeBackContentLabel.text = [NSString stringWithFormat:@"拒绝理由: %@",self.refuseContent];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if (self.state >= 10) {
            OverTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"OverTableViewCell" owner:self options:nil] lastObject];
            cell.overDateLabel.text = [NSString stringWithFormat:@"完工时间: %@",self.FinishTime];
            if ([self.overPs isEqualToString:@""] || !self.overPs) {
                cell.psLabel.text = @"备注: ";
            }else if ([self.overPs containsString:@"备注"]) {
                cell.psLabel.text = [NSString stringWithFormat:@"%@",self.overPs];
            }else {
                cell.psLabel.text = [NSString stringWithFormat:@"备注: %@",self.overPs];
            }
            cell.nameLabel.text = self.waiterName;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else {
            PayMoneyTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PayMoneyTableViewCell" owner:self options:nil] lastObject];
            
            if (![self.payMoneyStr floatValue]) {
                cell.hadPayMoneyLabel.text = @"未付款";
            }else {
                cell.hadPayMoneyLabel.text = @"已付款";
            }
            
            cell.payMoneyInfoLabel.text = [NSString stringWithFormat:@"金额: %@",self.payMoneyStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    
    }else if (indexPath.row == 3){
        
        if (self.state >= 15) {
            AssessTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AssessTableViewCell" owner:self options:nil] lastObject];
            if ([self.serviceAssess isEqualToString:@""] || !self.serviceAssess) {
                self.serviceAssess = @"备注: ";
                cell.assessLabel.text = self.serviceAssess;
            }else if ([self.serviceAssess containsString:@"备注"]) {
                cell.assessLabel.text = self.serviceAssess;
            }else {
                cell.assessLabel.text = [NSString stringWithFormat:@"备注: %@",self.serviceAssess];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            PayMoneyTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PayMoneyTableViewCell" owner:self options:nil] lastObject];
            
            if (![self.payMoneyStr floatValue]) {
                cell.hadPayMoneyLabel.text = @"未付款";
            }else {
                cell.hadPayMoneyLabel.text = @"已付款";
            }
            
            cell.payMoneyInfoLabel.text = [NSString stringWithFormat:@"金额: %@",self.payMoneyStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else {
        PayMoneyTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PayMoneyTableViewCell" owner:self options:nil] lastObject];
        
        if (![self.payMoneyStr floatValue]) {
            cell.hadPayMoneyLabel.text = @"未付款";
        }else {
            cell.hadPayMoneyLabel.text = @"已付款";
        }
        
        cell.payMoneyInfoLabel.text = [NSString stringWithFormat:@"金额: %@",self.payMoneyStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
#endif
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
#if Environment_Mode == 1

    if (indexPath.row == 0) {
        return 166;
    }else if (indexPath.row == 1) {
        if ([self.servicePs isEqualToString:@""]) {
            return 44;
        }
        return UITableViewAutomaticDimension;
    }else if (indexPath.row == 2) {
        if ([self.settleAccount isEqualToString:@""]) {
            return 69;
        }
        return UITableViewAutomaticDimension;
    }else if (indexPath.row == 3) {
        if (self.state == 6) {
            if ([self.chargeBackContent isEqualToString:@""]) {
                return 70;
            }
            return UITableViewAutomaticDimension;
        }else if (self.state ==  7) {
            if ([self.chargeBackContent isEqualToString:@""]) {
                return 70;
            }
            return UITableViewAutomaticDimension;
        }else{
            if ([self.overPs isEqualToString:@""]) {
                return 100;
            }
            return UITableViewAutomaticDimension;
        }
    }else{
        if ([self.serviceAssess isEqualToString:@""]) {
            return 65;
        }
        
        return UITableViewAutomaticDimension;
    }
#elif Environment_Mode == 2
    
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
                return 70;
            }
            return UITableViewAutomaticDimension;
        }else if (self.state ==  7) {
            if ([self.chargeBackContent isEqualToString:@""]) {
                return 70;
            }
            return UITableViewAutomaticDimension;
        }else if (self.state >= 10){
            if ([self.overPs isEqualToString:@""]) {
                return 100;
            }
            return UITableViewAutomaticDimension;
        }else {
            return 60;
        }
        
    }else if (indexPath.row == 3){
        if ([self.serviceAssess isEqualToString:@""]) {
            return 65;
        }
        
        return UITableViewAutomaticDimension;
    }else {
        return 60;
    }
    
#endif
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


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
    
#if Environment_Mode == 1
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][3] isEqualToString:@"0"]) {
        robVC.tabBarItem.badgeValue = nil;
    }else{
        robVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][3];
    }
#elif Environment_Mode == 2
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][4] isEqualToString:@"0"]) {
        robVC.tabBarItem.badgeValue = nil;
    }else{
        robVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][4];
    }
#endif
    
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
