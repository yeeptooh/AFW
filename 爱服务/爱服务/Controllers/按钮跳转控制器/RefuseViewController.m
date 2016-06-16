//
//  RefuseViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/27.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "RefuseViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UserModel.h"
#import "RefuseReasonViewController.h"
@interface RefuseViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end

@implementation RefuseViewController

- (NSMutableArray *)reasonList {
    if (!_reasonList) {
        _reasonList = [NSMutableArray array];
    }
    return _reasonList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviTitle];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = color(241, 241, 241, 1);
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, (Height - StatusBarAndNavigationBarHeight)*2/12) style:UITableViewStylePlain];
    self.tableView.backgroundColor = color(241, 241, 241, 1);
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    [self addKeyBoardNotification];
    [self setSubmitButton];
}

- (void)keyBoardWillShow {
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    self.tap.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:self.tap];
    [self.view addGestureRecognizer:self.tap];
}

- (void)keyBoardWillHide {
    [self.tableView removeGestureRecognizer:self.tap];
    [self.view removeGestureRecognizer:self.tap];
}

- (void)tap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)addKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"chargeBackCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSArray *labelList = @[
                           @"拒绝理由",
                           @"补充理由"
                           ];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, Width/4, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    label.text = labelList[indexPath.row];
    CGFloat fontsize;
    if (iPhone6_plus || iPhone6) {
        fontsize = 16;
    }else{
        fontsize = 14;
    }
    label.font = [UIFont systemFontOfSize:fontsize];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor blackColor];
    
    cell.backgroundColor = [UIColor clearColor];
    [cell addSubview:label];
    
    if (indexPath.row == 0) {
        
        UIButton *chargeBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chargeBackButton.tag = 500;
        chargeBackButton.backgroundColor = [UIColor whiteColor];
        [chargeBackButton setTitle:@"" forState:UIControlStateNormal];
        [chargeBackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        chargeBackButton.frame = CGRectMake(Width*5/16, 5, Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10);
        [chargeBackButton addTarget:self action:@selector(chargeBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        chargeBackButton.titleLabel.font = font(fontsize);
        chargeBackButton.layer.cornerRadius = 5;
        chargeBackButton.layer.masksToBounds = YES;
        [cell addSubview:chargeBackButton];
        
    }else {
        
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(Width*5/16, 5, Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
        
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.font = font(fontsize);
        textfield.layer.cornerRadius = 5;
        textfield.layer.masksToBounds = YES;
        
        textfield.tag = 1000;
        [cell addSubview:textfield];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (Height - StatusBarAndNavigationBarHeight)/12;
}

- (void)chargeBackButtonClicked:(UIButton *)sender {
    RefuseReasonViewController *rrVC = [[RefuseReasonViewController alloc]init];
    rrVC.reasonList = [NSMutableArray arrayWithArray:@[@"联系不上用户",@"价格太低了"]];
    rrVC.returnReason = ^(NSString *reason) {
        [sender setTitle:reason forState:UIControlStateNormal];
    };
    [self presentViewController:rrVC animated:YES completion:nil];
    
}

- (void)setSubmitButton {
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"拒绝" forState:UIControlStateNormal];
    
    [submit setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    submit.backgroundColor = color(23, 133, 255, 1);
    submit.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*11/12, Width, (Height - StatusBarAndNavigationBarHeight)/12);
    [self.view addSubview:submit];
    
}

- (void)submitClicked:(UIButton *)sender {
    
    if (!((UIButton *)[self.tableView viewWithTag:500]).titleLabel.text) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
        
        HUD.mode = MBProgressHUDModeText;
        HUD.label.text = @"请选择拒绝理由";
        CGFloat fontsize;
        if (iPhone4_4s || iPhone5_5s) {
            fontsize = 14;
        }else{
            fontsize = 16;
        }
        HUD.label.font = font(fontsize);
        [self.view addSubview:HUD];
        [HUD showAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
            [HUD removeFromSuperViewOnHide];
        });
        return;
    }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:HUD];
    [HUD showAnimated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 5;
    UserModel *userModel = [UserModel readUserModel];
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=refuse",HomeURL];
    NSDictionary *params = @{
                             @"id":@(self.ID),
                             @"comid":@(userModel.comid),
                             @"uid":@(userModel.uid),
                             @"reason":((UIButton *)[self.tableView viewWithTag:500]).titleLabel.text,
                             };
    __weak typeof(self)weakSelf = self;
    
    [manager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBadgeValueChanged object:nil];
        [HUD hideAnimated:YES];
        [HUD removeFromSuperViewOnHide];
        MBProgressHUD *successHUD = [[MBProgressHUD alloc]initWithView:self.view];
        successHUD.mode = MBProgressHUDModeText;
        successHUD.label.font = font(14);
        successHUD.label.text = @"拒绝成功";
        [weakSelf.view addSubview:successHUD];

        [successHUD showAnimated:YES];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [successHUD hideAnimated:YES];
            [successHUD removeFromSuperViewOnHide];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        NSLog(@"error = %@",error.userInfo);
        [HUD hideAnimated:YES];
        [HUD removeFromSuperViewOnHide];
        MBProgressHUD *errorHUD = [[MBProgressHUD alloc]initWithView:self.view];
        errorHUD.mode = MBProgressHUDModeText;
        errorHUD.label.font = font(14);
        errorHUD.label.text = @"拒绝失败";
        [weakSelf.view addSubview:errorHUD];

        [errorHUD showAnimated:YES];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [errorHUD hideAnimated:YES];
            [errorHUD removeFromSuperViewOnHide];
            
        });
        
    }];
    
    
    
//    [manager POST:URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [HUD hideAnimated:YES];
//        [HUD removeFromSuperViewOnHide];
//        MBProgressHUD *successHUD = [[MBProgressHUD alloc]initWithView:self.view];
//        successHUD.mode = MBProgressHUDModeText;
//        successHUD.label.font = font(14);
//        successHUD.label.text = @"拒绝成功";
//        [weakSelf.view addSubview:successHUD];
//        
//        [successHUD showAnimated:YES];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [successHUD hideAnimated:YES];
//            [successHUD removeFromSuperViewOnHide];
//            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//        });
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error = %@",error.userInfo);
//        [HUD hideAnimated:YES];
//        [HUD removeFromSuperViewOnHide];
//        MBProgressHUD *errorHUD = [[MBProgressHUD alloc]initWithView:self.view];
//        errorHUD.mode = MBProgressHUDModeText;
//        errorHUD.label.font = font(14);
//        errorHUD.label.text = @"拒绝失败";
//        [weakSelf.view addSubview:errorHUD];
//        
//        [errorHUD showAnimated:YES];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [errorHUD hideAnimated:YES];
//            [errorHUD removeFromSuperViewOnHide];
//            
//        });
//    }];
}

- (void)setNaviTitle {
    self.navigationItem.title = @"拒绝";
}


@end
