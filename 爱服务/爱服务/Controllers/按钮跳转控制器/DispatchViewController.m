//
//  DispatchViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/7/13.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "DispatchViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DispatchTableViewCell.h"
#import "DetailViewController.h"
#import "AllOrderViewController.h"
@interface DispatchViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) DetailViewController *detailVC;
@end

@implementation DispatchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedRow = -1;
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
    self.detailVC = (DetailViewController *)[(UINavigationController *)[((UITabBarController *)[self presentingViewController]) selectedViewController] topViewController];
}

- (void)configView {
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (iPhone4_4s || iPhone5_5s) {
        closeButton.frame = CGRectMake(0, Height - 200 - 40, (self.view.bounds.size.width - 40)/2-0.3, 40);
    }else {
        closeButton.frame = CGRectMake(0, Height - 200 - 50, (self.view.bounds.size.width - 40)/2-0.3, 50);
    }
    closeButton.backgroundColor = BlueColor;
    [closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    UIButton *dispatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dispatchButton setTitle:@"确定" forState:UIControlStateNormal];
    [dispatchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (iPhone4_4s || iPhone5_5s) {
        dispatchButton.frame = CGRectMake((self.view.bounds.size.width - 40)/2+0.3, Height - 200 - 40, (self.view.bounds.size.width - 40)/2-0.3, 40);
    }else {
        dispatchButton.frame = CGRectMake((self.view.bounds.size.width - 40)/2+0.3, Height - 200 - 50, (self.view.bounds.size.width - 40)/2-0.3, 50);
    }
    
    dispatchButton.backgroundColor = BlueColor;
    [dispatchButton addTarget:self action:@selector(dispatchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dispatchButton];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width - 40, 50)];
    headerLabel.text = @"选择厂商";
    headerLabel.font = font(16);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = BlueColor;
    [self.view addSubview:headerLabel];
    
    if (iPhone5_5s || iPhone4_4s) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, Width - 40, Height - 200 - 90) style:UITableViewStylePlain];
    }else {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, Width - 40, Height - 200 - 100) style:UITableViewStylePlain];
    }
    
    //    self.tableView.backgroundColor = [UIColor blueColor];
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
  
}

- (void)closeButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dispatchButtonClicked {
    
    if (self.selectedRow == -1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请选择厂商";
        hud.label.font = font(14);
        [hud hideAnimated:YES afterDelay:0.75];
    }else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
//        hud.minSize = CGSizeMake(110, 100);
        hud.label.font = font(14);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString *touserId = self.List[self.selectedRow][@"ID"];
        NSString *touserName = self.List[self.selectedRow][@"ShowName"];
        
        NSString *URL = [NSString stringWithFormat:@"%@task.ashx?action=setwaiter",HomeURL];
        NSDictionary *params = @{
                                 @"taskId":self.taskId,
                                 @"touserId":touserId,
                                 @"touserName":touserName
                                 };
        
        URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [manager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dic = %@",dic);
            if ([dic[@"ret"] integerValue] == 0) {
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabel.text = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                hud.detailsLabel.font = font(14);
                [hud hideAnimated:YES afterDelay:1.25];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }else if ([dic[@"ret"] integerValue] == 1) {
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                
                UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                hud.label.font = font(14);
                [hud hideAnimated:YES afterDelay:1.25];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                        if ([self.detailVC.navigationController.viewControllers[0] isKindOfClass:[AllOrderViewController class]]) {
                            [self.detailVC.navigationController popViewControllerAnimated:YES];
                        }else {
                            [self.detailVC.navigationController popToRootViewControllerAnimated:YES];
                        }
                        
                    }];
                });
            }else if ([dic[@"ret"] integerValue] == 2) {
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabel.text = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                hud.detailsLabel.font = font(14);
                [hud hideAnimated:YES afterDelay:1.25];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.detailVC.navigationController popToRootViewControllerAnimated:YES];
                });
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
            UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.label.text = NSLocalizedString(@"请检查网络", @"HUD completed title");
            [hud hideAnimated:YES afterDelay:0.75];
            
        }];
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DispatchTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DispatchTableViewCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.CSLabel.text = [NSString stringWithFormat:@"%@[%@]",self.List[indexPath.row][@"ShowName"],self.List[indexPath.row][@"UserTypeStr"]];
    
    cell.nameLabel.text = self.List[indexPath.row][@"MasterName"];
    if (![self.List[indexPath.row][@"Mobile"] isEqualToString:@""] && ![self.List[indexPath.row][@"Tel"] isEqualToString:@""]) {
        cell.phoneLabel.text = [NSString stringWithFormat:@"%@/%@",self.List[indexPath.row][@"Mobile"],self.List[indexPath.row][@"Tel"]];
    }else if (![self.List[indexPath.row][@"Mobile"] isEqualToString:@""]) {
        cell.phoneLabel.text = self.List[indexPath.row][@"Mobile"];
    }else if (![self.List[indexPath.row][@"Tel"] isEqualToString:@""]) {
        cell.phoneLabel.text = self.List[indexPath.row][@"Tel"];
    }else {
        cell.phoneLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


@end
