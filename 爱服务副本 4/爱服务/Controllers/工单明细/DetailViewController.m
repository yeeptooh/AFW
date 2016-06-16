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

#import "ButtonPresentAnimation.h"
#import "ButtonDismissAnimation.h"

#import "CompleteButtonViewController.h"
#import "ChargeBackViewController.h"

#import "RefuseViewController.h"
#import "AcceptViewController.h"

#import "MBProgressHUD.h"

#define ButtonHeight 35
#define BaseInfoViewHeight 150
#define SectionHeaderHeight 32
@interface DetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIViewControllerTransitioningDelegate
>

@property (nonatomic, strong) DetailTaskPlanTableViewCell *baseDetailInfoCell;
@property (nonatomic, strong) ProductTableViewCell *cell;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DetailViewController
- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame;
        if (self.state == 4 || self.state == 5) {
            frame = CGRectMake(0, BaseInfoViewHeight, Width, Height - BaseInfoViewHeight - StatusBarAndNavigationBarHeight - ButtonHeight);
        }else{
            frame = CGRectMake(0, BaseInfoViewHeight, Width, Height - BaseInfoViewHeight - StatusBarAndNavigationBarHeight);
        }
        
        
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
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
    self.baseDetailInfoCell = [[[NSBundle mainBundle] loadNibNamed:@"DetailTaskPlanTableViewCell" owner:self options:nil]lastObject];
    self.baseDetailInfoCell.frame = CGRectMake(0, 0, Width, BaseInfoViewHeight);
    self.baseDetailInfoCell.nameLabel.text = self.name;

    self.baseDetailInfoCell.taskId = [NSString stringWithFormat:@"%@",@(self.ID)];
    
    self.baseDetailInfoCell.phone = self.phone;
    
    
    self.baseDetailInfoCell.phoneLabel.text = self.phone;
    self.baseDetailInfoCell.fromLabel.text = self.from;
    self.baseDetailInfoCell.fromPhoneLabel.text = self.fromPhone;
    self.baseDetailInfoCell.priceLabel.text = self.price;
    [self.baseDetailInfoCell.locationButton setTitle:self.location forState:UIControlStateNormal];
    [self.baseDetailInfoCell.locationButton addTarget:self action:@selector(locationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.baseDetailInfoCell];
    
}

- (void)locationButtonClicked {
    
    ButtonViewController *buttonVC = [[ButtonViewController alloc]init];
    buttonVC.modalTransitionStyle = UIModalPresentationCustom;
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
    if (self.state == 4) {
        
        if (self.flag == 1) {
            
            UIButton *robButton = [UIButton buttonWithType:UIButtonTypeCustom];
            robButton.frame = CGRectMake(0, Height - StatusBarAndNavigationBarHeight - ButtonHeight, Width, ButtonHeight);
            robButton.backgroundColor = BlueColor;
            
            [robButton setTitle:@"立即抢单" forState:UIControlStateNormal];
            [robButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
            [robButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
            [robButton addTarget:self action:@selector(robButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:robButton];
            
        }else {
            
            UIButton *receiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            receiveButton.frame = CGRectMake(5, Height - StatusBarAndNavigationBarHeight - ButtonHeight, Width/2 - 10, ButtonHeight);
            receiveButton.backgroundColor = BlueColor;
            receiveButton.layer.cornerRadius = 3;
            receiveButton.layer.masksToBounds = YES;
            [receiveButton setTitle:@"接收" forState:UIControlStateNormal];
            [receiveButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
            [receiveButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
            [receiveButton addTarget:self action:@selector(receiveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:receiveButton];
            
            UIButton *refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            refuseButton.frame = CGRectMake(Width -5 - Width/2 + 10, Height - StatusBarAndNavigationBarHeight - ButtonHeight, Width/2 - 10, ButtonHeight);
            refuseButton.backgroundColor = BlueColor;
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
        completeButton.frame = CGRectMake(5, Height - StatusBarAndNavigationBarHeight - ButtonHeight, Width/2 - 10, ButtonHeight);
        completeButton.backgroundColor = BlueColor;
        completeButton.layer.cornerRadius = 3;
        completeButton.layer.masksToBounds = YES;
        [completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [completeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
        [completeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
        [completeButton addTarget:self action:@selector(completeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:completeButton];
        
        UIButton *recedeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        recedeButton.frame = CGRectMake(Width - 5 - Width/2 + 10, Height - StatusBarAndNavigationBarHeight - ButtonHeight, Width/2 - 10, ButtonHeight);
        recedeButton.backgroundColor = BlueColor;
        recedeButton.layer.cornerRadius = 3;
        recedeButton.layer.masksToBounds = YES;
        [recedeButton setTitle:@"退单" forState:UIControlStateNormal];
        [recedeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
        [recedeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
        [recedeButton addTarget:self action:@selector(recedeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:recedeButton];
        
    }
}

- (void)robButtonClicked {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:hud];
    [hud showAnimated:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer
    UserModel *userModel = [UserModel readUserModel];
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=grabsign&id=%ld&comid=%ld&uid=%ld&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)self.ID,(long)userModel.comid,(long)userModel.uid,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
    NSLog(@"%@",URL);
//    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
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
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    UserModel *userModel = [UserModel readUserModel];
    NSString *URL = [NSString stringWithFormat:@"%@Common.ashx?action=getwaiters&comid=%ld",HomeURL,(long)userModel.comid];
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
    
    
//    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        AcceptViewController *aVC = [[AcceptViewController alloc]init];
//        for (NSDictionary *dic in responseObject) {
//            [aVC.wList addObject:dic];
//        }
//        aVC.ID = self.ID;
//        [self.navigationController pushViewController:aVC animated:YES];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];

}

- (void)refuseButtonClicked {
    RefuseViewController *rVC = [[RefuseViewController alloc]init];
    rVC.ID = self.ID;
    [self.navigationController pushViewController:rVC animated:YES];
}

- (void)completeButtonClicked {
    CompleteButtonViewController *cbVC = [[CompleteButtonViewController alloc]init];
    cbVC.ID = self.ID;
    [self.navigationController pushViewController:cbVC animated:YES];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        self.cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductTableViewCell" owner:self options:nil] lastObject];
        [self.cell.typeButton setTitle:self.model forState:UIControlStateNormal];
        [self.cell.dateButton setTitle:self.buyDate forState:UIControlStateNormal];
        [self.cell.typeButton addTarget:self action:@selector(typeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.cell.dateButton addTarget:self action:@selector(dateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        self.cell.productCodeLabel.text = self.productCode;
        self.cell.orderCodeLabel.text = self.orderCode;
        self.cell.inOutLabel.text = self.inOut;
        self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.cell;
    }else if (indexPath.section == 1) {
        ServiceTypeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceTypeTableViewCell" owner:self options:nil] lastObject];
        if (!self.appointment) {
            self.appointment = @"";
        }
        cell.appointmentLabel.text = [NSString stringWithFormat:@"预约：%@",self.appointment];
        
        cell.psLabel.text = self.servicePs;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2) {
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
            cell.overDateLabel.text = [NSString stringWithFormat:@"完工时间：%@",@"2015年12月12日"];//self.overDate;
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
    if (indexPath.section == 0) {
        if ([self.orderCode isEqualToString:@""]) {
            return 108;
        }
        return 140;
    }else if (indexPath.section == 1) {
        if ([self.servicePs isEqualToString:@""]) {
            return 44;
        }
        return UITableViewAutomaticDimension;
    }else if (indexPath.section == 2) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


- (void)typeButtonClicked {
    PTypeViewController *ptypeVC = [[PTypeViewController alloc]init];
    ptypeVC.modalTransitionStyle = UIModalPresentationCustom;
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
    return [[ButtonPresentAnimation alloc]init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[ButtonDismissAnimation alloc]init];
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

@end
