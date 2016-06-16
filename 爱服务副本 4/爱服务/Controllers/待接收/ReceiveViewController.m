//
//  ReceiveViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/9.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "ReceiveViewController.h"
#import "AFNetworking.h"
#import "MainTableViewCell.h"
#import "UserModel.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Assoication.h"
#import "OrderModel.h"
#import "DetailViewController.h"

@interface ReceiveViewController ()
<
UINavigationControllerDelegate,
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
>

@property (nonatomic, strong) UIView *noOrderView;
@property (nonatomic, strong) UIView *noNetWorkingView;
@property (nonatomic, strong) UIView *noSearchResultView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) OrderModel *orderModel;
@property (nonatomic, strong) NSMutableArray *dicList;


@property (nonatomic, strong) UITableView *searchResultTableView;
@property (nonatomic, strong) UIView *searchResultView;
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) NSMutableArray *searchResultList;


@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger searchPage;

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) MBProgressHUD *searchHUD;

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation ReceiveViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"待接收";
        self.tabBarItem.image = [UIImage imageNamed:@"drawable_no_select_djs"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"drawable_select_djs.png"];
        
    }
    return self;
}


- (NSMutableArray *)dicList {
    if (!_dicList) {
        _dicList = [NSMutableArray array];
    }
    return _dicList;
}

- (NSMutableArray *)searchResultList {
    if (!_searchResultList) {
        _searchResultList = [NSMutableArray array];
    }
    return _searchResultList;
}


- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,SearchBarHeight, Width, Height - StatusBarAndNavigationBarHeight - TabbarHeight - SearchBarHeight) style:UITableViewStylePlain];
        _tableView.tag = 300;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
        
    }
    return _tableView;
}


- (UITableView *)searchResultTableView {
    if (!_searchResultTableView) {
        
        _searchResultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,SearchBarHeight, Width, Height - StatusBarAndNavigationBarHeight - TabbarHeight - SearchBarHeight) style:UITableViewStylePlain];
        _searchResultTableView.tag = 500;
        _searchResultTableView.tableFooterView = [[UIView alloc]init];
        _searchResultTableView.delegate = self;
        _searchResultTableView.dataSource = self;
        
        __weak typeof(self) weakSelf = self;
        _searchResultTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreSearchData];
        }];
        
    }
    return _searchResultTableView;
}

- (UIView *)searchResultView {
    
    if (!_searchResultView) {
        
        _searchResultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight - TabbarHeight)];
        _searchResultView.backgroundColor = [UIColor whiteColor];
        _searchResultView.alpha = 0;
        
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, SearchBarHeight)];
        containerView.backgroundColor = color(235, 235, 235, 1);
        [_searchResultView addSubview:containerView];
        
        self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(8, 7, Width - 16, SearchBarHeight - 14)];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        self.whiteView.layer.cornerRadius = 5;
        self.whiteView.layer.masksToBounds = YES;
        [containerView addSubview:self.whiteView];
        
        self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.searchButton setTitle:@" 客户姓名／客户电话" forState:UIControlStateNormal];
        [self.searchButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
        
        CGFloat fontSize;
        if (iPhone6 || iPhone6_plus) {
            fontSize = 16;
        }else{
            fontSize = 14;
        }
        self.searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.searchButton.titleLabel.font = font(fontSize);
        self.searchButton.backgroundColor = [UIColor whiteColor];
        self.searchButton.frame = CGRectMake(8, 7, Width - 60, SearchBarHeight - 14);
        self.searchButton.layer.cornerRadius = 5;
        self.searchButton.layer.masksToBounds = YES;
        [containerView addSubview:self.searchButton];
        
        self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(8, 7, Width - 60, SearchBarHeight - 14)];
        self.textfield.backgroundColor = [UIColor clearColor];
        self.textfield.clearsOnBeginEditing = YES;
        self.textfield.keyboardType = UIKeyboardTypeWebSearch;
        self.textfield.delegate = self;
        //监听textfield的text时时变化
        self.textfield.font = font(fontSize);
        [self.textfield addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
        [containerView addSubview:self.textfield];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:color(51, 102, 255, 1) forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateHighlighted];
        [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat fontsize;
        if (iPhone6 || iPhone6_plus) {
            fontsize = 18;
        }else{
            fontsize = 16;
        }
        self.cancelButton.titleLabel.font = font(fontsize);
        self.cancelButton.frame = CGRectMake(Width, 7, 60, 30);
        [_searchResultView addSubview:self.cancelButton];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, SearchBarHeight - 0.7, Width, 0.7)];
        line.backgroundColor = color(210, 210, 210, 1);
        [_searchResultView addSubview:line];
        
    }
    return _searchResultView;
}

- (void)editingChanged:(UITextField *)sender {
    if (![sender.text isEqualToString:@""]) {
        self.searchButton.titleLabel.text = @"";
    }else{
        self.searchButton.titleLabel.text = @" 客户姓名／客户电话";
    }
    
    if (self.searchResultList.count) {
        [self.searchResultList removeAllObjects];
    }
}

- (UIView *)noOrderView {
    if (!_noOrderView) {
        _noOrderView = [[UIView alloc]initWithFrame:CGRectMake(0, SearchBarHeight, Width, Height - StatusBarAndNavigationBarHeight - TabbarHeight - SearchBarHeight)];
        _noOrderView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loding_wrong"]];
        imageView.center = CGPointMake(Width/2, _noOrderView.center.y - imageView.bounds.size.height/2 - 25);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width, 50)];
        label.center = _noOrderView.center;
        label.text = @"无待接收订单";
        label.font = font(18);
        label.textAlignment = NSTextAlignmentCenter;
        [_noOrderView addSubview:imageView];
        [_noOrderView addSubview:label];
        
    }
    return _noOrderView;
}

- (UIView *)noNetWorkingView {
    
    if (!_noNetWorkingView) {
        _noNetWorkingView = [[UIView alloc]initWithFrame:CGRectMake(0, SearchBarHeight, Width, Height - StatusBarAndNavigationBarHeight - TabbarHeight - SearchBarHeight)];
        _noNetWorkingView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loding_wrong"]];
        imageView.center = CGPointMake(Width/2, _noNetWorkingView.center.y - imageView.bounds.size.height/2 - 25);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width, 50)];
        label.center = _noNetWorkingView.center;
        label.text = @"请检查网络";
        label.font = font(18);
        label.textAlignment = NSTextAlignmentCenter;
        [_noNetWorkingView addSubview:imageView];
        [_noNetWorkingView addSubview:label];
        
    }
    return _noNetWorkingView;
}

- (UIView *)noSearchResultView {
    if (!_noSearchResultView) {
        _noSearchResultView = [[UIView alloc]initWithFrame:CGRectMake(0, SearchBarHeight, Width, Height - StatusBarAndNavigationBarHeight - TabbarHeight - SearchBarHeight)];
        _noSearchResultView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loding_wrong"]];
        imageView.center = CGPointMake(Width/2, _noSearchResultView.center.y - imageView.bounds.size.height/2 - 25);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width, 50)];
        label.center = _noSearchResultView.center;
        label.text = @"无搜索结果";
        label.font = font(18);
        label.textAlignment = NSTextAlignmentCenter;
        [_noSearchResultView addSubview:imageView];
        [_noSearchResultView addSubview:label];
    }
    return _noSearchResultView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNaviTitle];
    [self setSearchButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badgeValueChanged:) name:kBadgeValueChanged object:nil];
}

- (void)badgeValueChanged:(NSNotification *)noti {
    UIViewController *receiveVC = [self.tabBarController viewControllers][1];
    UIViewController *completeVC = [self.tabBarController viewControllers][2];
    UIViewController *robVC = [self.tabBarController viewControllers][3];
    UIViewController *allorderVC = [self.tabBarController viewControllers][4];
    
    UserModel *userModel = [UserModel readUserModel];
    
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *countString = [NSString stringWithFormat:@"%@Task.ashx?action=gettaskcount&comid=%ld&uid=%ld&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:countString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *allString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *countList = [allString componentsSeparatedByString:@","];
        NSLog(@"－－－%@",countList);
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

- (void)setSearchButton {
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setTitle:@" 客户姓名／客户电话" forState:UIControlStateNormal];
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [searchButton setTitleColor:color(150, 150, 150, 1) forState:UIControlStateNormal];
    [searchButton setTitleColor:color(200, 200, 200, 0.8) forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.layer.cornerRadius = 5;
    searchButton.layer.masksToBounds = YES;
    
    CGFloat fontSize;
    if (iPhone6 || iPhone6_plus) {
        fontSize = 16;
    }else{
        fontSize = 14;
    }
    
    searchButton.titleLabel.font = font(fontSize);
    searchButton.backgroundColor = color(235, 235, 235, 1);
    searchButton.frame = CGRectMake(8, 7, Width - 16, SearchBarHeight - 14);
    [self.view addSubview:searchButton];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, SearchBarHeight - 0.7, Width, 0.7)];
    line.backgroundColor = color(210, 210, 210, 1);
    [self.view addSubview:line];
    
}

- (void)searchButtonClicked:(UIButton *)sender {
    [self.view addSubview:self.searchResultView];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.searchResultView.alpha = 1;
        
        CGRect frame = self.whiteView.frame;
        frame.size.width = Width - 60;
        self.whiteView.frame = frame;
        self.cancelButton.frame = CGRectMake(Width - 60, 7, 60, 30);
        [self.textfield becomeFirstResponder];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)cancelButtonClicked:(UIButton *)sender {
    self.searchPage = 1;
    [UIView animateWithDuration:0.5 animations:^{
        self.searchResultView.alpha = 0;
        [self.textfield resignFirstResponder];
        CGRect frame = self.whiteView.frame;
        frame.size.width = Width - 16;
        self.whiteView.frame = frame;
        self.cancelButton.frame = CGRectMake(Width, 7, 60, 30);
        
    } completion:^(BOOL finished) {
        [self.searchResultView removeFromSuperview];
        self.searchResultView = nil;
    }];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewWillAppear:animated];
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_noOrderView) {
        [self.noOrderView removeFromSuperview];
        self.noOrderView = nil;
    }
    if (_noNetWorkingView) {
        [self.noNetWorkingView removeFromSuperview];
        self.noNetWorkingView = nil;
    }
    self.HUD = [[MBProgressHUD alloc]initWithView:self.view];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.animationType = MBProgressHUDAnimationZoom;
    [self.view addSubview:self.HUD];
    
    [self.HUD showAnimated:YES];
    self.page = 1;
    self.searchPage = 1;
    [self setBadgeValue];
    
    [self loadNewDate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.manager.operationQueue cancelAllOperations];
    if (_searchResultView) {
        CGRect frame = self.whiteView.frame;
        frame.size.width = Width - 16;
        self.whiteView.frame = frame;
        self.cancelButton.frame = CGRectMake(Width, 7, 60, 30);
        [self.searchResultView removeFromSuperview];
        self.searchResultView = nil;
    }
    
    if (_noOrderView) {
        [self.noOrderView removeFromSuperview];
        self.noOrderView = nil;
    }
    if (_noNetWorkingView) {
        [self.noNetWorkingView removeFromSuperview];
        self.noNetWorkingView = nil;
    }
    
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    if (self.dicList) {
        [self.dicList removeAllObjects];
    }
}

- (void)loadNewDate {
    [self netWorking];
}

- (void)loadMoreData {
    self.page ++;
    [self netWorking];
}
- (void)netWorking {
    
    __weak typeof(self)weakSelf = self;
    
    self.manager = [AFHTTPSessionManager manager];
    UserModel *userModel = [UserModel readUserModel];
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=getlist&comid=%ld&uid=%ld&state=4&page=%ld&query=&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)self.page,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
    self.manager.requestSerializer.timeoutInterval = 5;
    
    [self.manager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf.HUD hideAnimated:YES];
        [weakSelf.HUD removeFromSuperViewOnHide];
        
        for (NSDictionary *dic in responseObject[@"task"]) {
            OrderModel *ordelModel = [OrderModel orderFromDictionary:dic];
            [weakSelf.dicList addObject:ordelModel];
        }
        
        if (!weakSelf.dicList.count) {
            [weakSelf.view addSubview:weakSelf.noOrderView];
            return ;
        }
        [weakSelf.view addSubview:weakSelf.tableView];
        [weakSelf.tableView reloadData];
        
        if ([responseObject[@"ResponseInfo"][0][@"PageNow"] integerValue] == [responseObject[@"ResponseInfo"][0][@"PageRowCount"] integerValue]) {
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.tableView.mj_footer.hidden = YES;
            return ;
        }else {
            weakSelf.tableView.mj_footer.hidden = NO;
        }
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
        
        return ;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
        [weakSelf.manager.operationQueue cancelAllOperations];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        [weakSelf.HUD hideAnimated:YES];
        [weakSelf.HUD removeFromSuperViewOnHide];
        
        [weakSelf.view addSubview:weakSelf.noNetWorkingView];
        weakSelf.tableView.mj_footer.hidden = YES;
        return ;
    }];
    
    
//    [self.manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [weakSelf.HUD hideAnimated:YES];
//        [weakSelf.HUD removeFromSuperViewOnHide];
//        
//        for (NSDictionary *dic in responseObject[@"task"]) {
//            OrderModel *ordelModel = [OrderModel orderFromDictionary:dic];
//            [weakSelf.dicList addObject:ordelModel];
//        }
//        
//        if (!weakSelf.dicList.count) {
//            [weakSelf.view addSubview:weakSelf.noOrderView];
//            return ;
//        }
//        [weakSelf.view addSubview:weakSelf.tableView];
//        [weakSelf.tableView reloadData];
//        
//        if ([responseObject[@"ResponseInfo"][0][@"PageNow"] integerValue] == [responseObject[@"ResponseInfo"][0][@"PageRowCount"] integerValue]) {
//            [weakSelf.tableView.mj_footer endRefreshing];
//            weakSelf.tableView.mj_footer.hidden = YES;
//            return ;
//        }else {
//            weakSelf.tableView.mj_footer.hidden = NO;
//        }
//        
//        [weakSelf.tableView.mj_footer endRefreshing];
//        
//        
//        return ;
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        [weakSelf.manager.operationQueue cancelAllOperations];
//        [weakSelf.tableView.mj_footer endRefreshing];
//        
//        [weakSelf.HUD hideAnimated:YES];
//        [weakSelf.HUD removeFromSuperViewOnHide];
//        
//        [weakSelf.view addSubview:weakSelf.noNetWorkingView];
//        weakSelf.tableView.mj_footer.hidden = YES;
//        return ;
//    }];
}

#pragma mark - UITableViewDelegate And DataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 300) {
        return self.dicList.count;
    }else{
        return self.searchResultList.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:self options:nil].lastObject;
        
    }
    
    if (tableView.tag == 300) {
        self.orderModel = self.dicList[indexPath.row];
    }else{
        self.orderModel = self.searchResultList[indexPath.row];
    }
    
    
    cell.dateLabel.text = self.orderModel.date;
    
    cell.serviceTypeLabel.text = self.orderModel.serviceType;
    cell.productTypeLabel.text = self.orderModel.productType;
    cell.nameLabel.text = self.orderModel.name;
    cell.phoneLabel.text = self.orderModel.phone;
    cell.locationLabel.text = self.orderModel.location;
    cell.assessLabel.text = self.orderModel.assess;
    cell.priceLabel.text = self.orderModel.price;
    cell.areaLabel.text = self.orderModel.area;
    cell.robButton.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    
    if (tableView.tag == 300) {
        self.orderModel = self.dicList[indexPath.row];
    }else{
        self.orderModel = self.searchResultList[indexPath.row];
    }
    detailVC.ID = self.orderModel.ID;
    detailVC.state = [self.orderModel.state integerValue];
    
    detailVC.name = self.orderModel.name;
    detailVC.phone = self.orderModel.phone;
    detailVC.from = [NSString stringWithFormat:@"来源：%@",self.orderModel.fromUserName];
    detailVC.fromPhone = [NSString stringWithFormat:@"厂商电话：%@",self.orderModel.fromUserPhone];
    detailVC.price = [NSString stringWithFormat:@"价格：%@",self.orderModel.price];
    detailVC.location = self.orderModel.location;
    
    detailVC.productType = self.orderModel.productType;
    detailVC.model = self.orderModel.model;
    detailVC.buyDate = self.orderModel.buyDate;
    detailVC.productCode = self.orderModel.productCode;
    detailVC.orderCode = self.orderModel.orderCode;
    detailVC.inOut = self.orderModel.inOut;
    
    
    detailVC.serviceType = self.orderModel.serviceType;
    detailVC.appointment = self.orderModel.appointment;
    detailVC.servicePs = self.orderModel.postScript;
    detailVC.chargeBackContent = self.orderModel.chargeBackContent;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - UITextFieldDelegate -
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    __weak typeof(self)weakSelf = self;
    self.searchHUD = [[MBProgressHUD alloc]initWithView:self.searchResultView];
    self.searchHUD.mode = MBProgressHUDModeIndeterminate;
    self.searchHUD.animationType = MBProgressHUDAnimationZoom;
    [self.searchResultView addSubview:self.searchHUD];
    self.searchHUD.showing = YES;
    [self.searchHUD showAnimated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    UserModel *userModel = [UserModel readUserModel];
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=getlist&comid=%ld&uid=%ld&state=4&page=%ld&query=%@&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)self.page,textField.text,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
    //297错误，URL中有中文，需转码
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    manager.requestSerializer.timeoutInterval = 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [manager.operationQueue cancelAllOperations];
    });
    
    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf.searchHUD hideAnimated:YES];
        [weakSelf.searchHUD removeFromSuperViewOnHide];
        
        for (NSDictionary *dic in responseObject[@"task"]) {
            OrderModel *ordelModel = [OrderModel orderFromDictionary:dic];
            [weakSelf.searchResultList addObject:ordelModel];
        }
        
        if (!weakSelf.searchResultList.count) {
            [weakSelf.searchResultView addSubview:weakSelf.noSearchResultView];
            return ;
        }
        [weakSelf.searchResultView addSubview:weakSelf.searchResultTableView];
        [weakSelf.searchResultTableView reloadData];
        
        if ([responseObject[@"ResponseInfo"][0][@"PageNow"] integerValue] == [responseObject[@"ResponseInfo"][0][@"PageRowCount"] integerValue]) {
            [weakSelf.searchResultTableView.mj_footer endRefreshing];
            weakSelf.searchResultTableView.mj_footer.hidden = YES;
            return ;
        }else {
            weakSelf.searchResultTableView.mj_footer.hidden = NO;
        }
        
        [weakSelf.searchResultTableView.mj_footer endRefreshing];
        
        
        return ;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.searchHUD.showing = NO;
        [weakSelf.searchResultTableView.mj_footer endRefreshing];
        
        [weakSelf.searchHUD hideAnimated:YES];
        [weakSelf.searchHUD removeFromSuperViewOnHide];
        
        [weakSelf.searchResultView addSubview:weakSelf.noNetWorkingView];
        weakSelf.searchResultTableView.mj_footer.hidden = YES;
        return ;
    }];
    
    
//    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [weakSelf.searchHUD hideAnimated:YES];
//        [weakSelf.searchHUD removeFromSuperViewOnHide];
//        
//        for (NSDictionary *dic in responseObject[@"task"]) {
//            OrderModel *ordelModel = [OrderModel orderFromDictionary:dic];
//            [weakSelf.searchResultList addObject:ordelModel];
//        }
//        
//        if (!weakSelf.searchResultList.count) {
//            [weakSelf.searchResultView addSubview:weakSelf.noSearchResultView];
//            return ;
//        }
//        [weakSelf.searchResultView addSubview:weakSelf.searchResultTableView];
//        [weakSelf.searchResultTableView reloadData];
//        
//        if ([responseObject[@"ResponseInfo"][0][@"PageNow"] integerValue] == [responseObject[@"ResponseInfo"][0][@"PageRowCount"] integerValue]) {
//            [weakSelf.searchResultTableView.mj_footer endRefreshing];
//            weakSelf.searchResultTableView.mj_footer.hidden = YES;
//            return ;
//        }else {
//            weakSelf.searchResultTableView.mj_footer.hidden = NO;
//        }
//        
//        [weakSelf.searchResultTableView.mj_footer endRefreshing];
//        
//        
//        return ;
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        weakSelf.searchHUD.showing = NO;
//        [weakSelf.searchResultTableView.mj_footer endRefreshing];
//        
//        [weakSelf.searchHUD hideAnimated:YES];
//        [weakSelf.searchHUD removeFromSuperViewOnHide];
//        
//        [weakSelf.searchResultView addSubview:weakSelf.noNetWorkingView];
//        weakSelf.searchResultTableView.mj_footer.hidden = YES;
//        return ;
//    }];
    
    return YES;
}

- (void)loadMoreSearchData {
    self.searchPage ++;
    
    __weak typeof(self)weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    UserModel *userModel = [UserModel readUserModel];
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=getlist&comid=%ld&uid=%ld&state=4&page=%ld&query=%@&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)self.searchPage,self.textfield.text,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
    //297错误，URL中有中文，需转码
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    manager.requestSerializer.timeoutInterval = 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [manager.operationQueue cancelAllOperations];
    });
    
    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf.searchHUD hideAnimated:YES];
        [weakSelf.searchHUD removeFromSuperViewOnHide];
        
        for (NSDictionary *dic in responseObject[@"task"]) {
            OrderModel *ordelModel = [OrderModel orderFromDictionary:dic];
            [weakSelf.searchResultList addObject:ordelModel];
        }
        
        if (!weakSelf.searchResultList.count) {
            [weakSelf.searchResultView addSubview:weakSelf.noSearchResultView];
            return ;
        }
        [weakSelf.searchResultView addSubview:weakSelf.searchResultTableView];
        [weakSelf.searchResultTableView reloadData];
        if ([responseObject[@"ResponseInfo"][0][@"PageNow"] integerValue] == [responseObject[@"ResponseInfo"][0][@"PageRowCount"] integerValue]) {
            [weakSelf.searchResultTableView.mj_footer endRefreshing];
            weakSelf.searchResultTableView.mj_footer.hidden = YES;
            return ;
        }else {
            weakSelf.searchResultTableView.mj_footer.hidden = NO;
        }
        [weakSelf.searchResultTableView.mj_footer endRefreshing];
        
        
        return ;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        weakSelf.searchHUD.showing = NO;
        [weakSelf.searchResultTableView.mj_footer endRefreshing];
        
        [weakSelf.searchHUD hideAnimated:YES];
        [weakSelf.searchHUD removeFromSuperViewOnHide];
        
        [weakSelf.searchResultView addSubview:weakSelf.noNetWorkingView];
        weakSelf.searchResultTableView.mj_footer.hidden = YES;
        return ;
        
    }];
//    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [weakSelf.searchHUD hideAnimated:YES];
//        [weakSelf.searchHUD removeFromSuperViewOnHide];
//        
//        for (NSDictionary *dic in responseObject[@"task"]) {
//            OrderModel *ordelModel = [OrderModel orderFromDictionary:dic];
//            [weakSelf.searchResultList addObject:ordelModel];
//        }
//        
//        if (!weakSelf.searchResultList.count) {
//            [weakSelf.searchResultView addSubview:weakSelf.noSearchResultView];
//            return ;
//        }
//        [weakSelf.searchResultView addSubview:weakSelf.searchResultTableView];
//        [weakSelf.searchResultTableView reloadData];
//        if ([responseObject[@"ResponseInfo"][0][@"PageNow"] integerValue] == [responseObject[@"ResponseInfo"][0][@"PageRowCount"] integerValue]) {
//            [weakSelf.searchResultTableView.mj_footer endRefreshing];
//            weakSelf.searchResultTableView.mj_footer.hidden = YES;
//            return ;
//        }else {
//            weakSelf.searchResultTableView.mj_footer.hidden = NO;
//        }
//        [weakSelf.searchResultTableView.mj_footer endRefreshing];
//        
//        
//        return ;
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        weakSelf.searchHUD.showing = NO;
//        [weakSelf.searchResultTableView.mj_footer endRefreshing];
//        
//        [weakSelf.searchHUD hideAnimated:YES];
//        [weakSelf.searchHUD removeFromSuperViewOnHide];
//        
//        [weakSelf.searchResultView addSubview:weakSelf.noNetWorkingView];
//        weakSelf.searchResultTableView.mj_footer.hidden = YES;
//        return ;
//    }];
}

- (void)setNaviTitle {
    self.navigationItem.title = @"待接收";
}

- (void)setBadgeValue {
    UIViewController *receiveVC = [self.tabBarController viewControllers][1];
    UIViewController *completeVC = [self.tabBarController viewControllers][2];
    UIViewController *robVC = [self.tabBarController viewControllers][3];
    UIViewController *allorderVC = [self.tabBarController viewControllers][4];
    
    UserModel *userModel = [UserModel readUserModel];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *countString = [NSString stringWithFormat:@"%@Task.ashx?action=gettaskcount&comid=%ld&uid=%ld&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:countString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *allString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *countList = [allString componentsSeparatedByString:@","];
        NSLog(@"－－－%@",countList);
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
    
//    [manager GET:countString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *allString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSArray *countList = [allString componentsSeparatedByString:@","];
//        NSLog(@"－－－%@",countList);
//        [[NSUserDefaults standardUserDefaults] setObject:countList forKey:@"countList"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][1] isEqualToString:@"0"]) {
//            
//            receiveVC.tabBarItem.badgeValue = nil;
//        }else{
//            receiveVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][1];
//        }
//        
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][2] isEqualToString:@"0"]) {
//            completeVC.tabBarItem.badgeValue = nil;
//        }else{
//            completeVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][2];
//        }
//        
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][3] isEqualToString:@"0"]) {
//            robVC.tabBarItem.badgeValue = nil;
//        }else{
//            robVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][3];
//        }
//        
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][0] isEqualToString:@"0"]) {
//            allorderVC.tabBarItem.badgeValue = nil;
//        }else{
//            allorderVC.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"countList"][0];
//        }
//
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
    
    
}

@end
