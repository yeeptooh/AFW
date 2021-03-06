//
//  CompleteViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/9.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "CompleteViewController.h"
#import "AFNetworking.h"
#import "MainTableViewCell.h"
#import "CSMainTableViewCell.h"
#import "UserModel.h"
#import "MBProgressHUD.h"
#import "OrderModel.h"
#import "DetailViewController.h"

#import "PartsRequestViewController.h"
#import "AppendFeesViewController.h"

@interface CompleteViewController ()
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

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIActivityIndicatorView *searchActivityView;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, assign, getter = isSelected) BOOL selected;
#pragma mark 
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *model;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *money;

@property (nonatomic, assign) NSInteger flag;
@end

@implementation CompleteViewController

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.center = CGPointMake(self.view.center.x, self.view.center.y - 40);
        
    }
    return _activityView;
}

- (UIActivityIndicatorView *)searchActivityView {
    if (!_searchActivityView) {
        _searchActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _searchActivityView.center = CGPointMake(self.view.center.x, self.view.center.y - 40);
    }
    return _searchActivityView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"待完成";
        self.tabBarItem.image = [UIImage imageNamed:@"drawable_no_select_dwc"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"drawable_select_dwc"];
        self.selected = NO;
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
        
        CGRect frame;
        NSArray *vcList = self.navigationController.viewControllers;
        NSInteger count = vcList.count;
        if (count == 3) {
            frame = CGRectMake(0,SearchBarHeight, Width, Height - StatusBarAndNavigationBarHeight - SearchBarHeight);
        }else {
            frame = CGRectMake(0,SearchBarHeight, Width, Height - StatusBarAndNavigationBarHeight - TabbarHeight - SearchBarHeight);
        }
        
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableView.tag = 300;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.alpha = 0;
        __weak typeof(self) weakSelf = self;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
        
    }
    return _tableView;
}


- (UITableView *)searchResultTableView {
    if (!_searchResultTableView) {
        
        CGRect frame;
        NSArray *vcList = self.navigationController.viewControllers;
        NSInteger count = vcList.count;
        if (count == 3) {
            frame = CGRectMake(0,SearchBarHeight, Width, Height - StatusBarAndNavigationBarHeight - SearchBarHeight);
        }else {
            frame = CGRectMake(0,SearchBarHeight, Width, Height - StatusBarAndNavigationBarHeight - TabbarHeight - SearchBarHeight);
        }
        
        _searchResultTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _searchResultTableView.tag = 500;
        _searchResultTableView.tableFooterView = [[UIView alloc]init];
        _searchResultTableView.delegate = self;
        _searchResultTableView.dataSource = self;
        _searchResultTableView.alpha = 0;
        __weak typeof(self) weakSelf = self;
        _searchResultTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreSearchData];
        }];
        
    }
    return _searchResultTableView;
}

- (UIView *)searchResultView {
    
    if (!_searchResultView) {
        
        CGRect frame;
        NSArray *vcList = self.navigationController.viewControllers;
        NSInteger count = vcList.count;
        if (count == 3) {
            frame = CGRectMake(0,0, Width, Height - StatusBarAndNavigationBarHeight);
        }else {
            frame = CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight - TabbarHeight);
        }
        
        _searchResultView = [[UIView alloc]initWithFrame:frame];
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
        [self.searchButton setTitleColor:color(100, 100, 100, 1) forState:UIControlStateNormal];
        
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
        [self.cancelButton setTitleColor:beautifulBlueColor forState:UIControlStateNormal];
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
        [_searchResultView addSubview:self.searchActivityView];
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
        label.text = @"无待完成订单";
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
    [self.view addSubview:self.activityView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badgeValueChanged:) name:kBadgeValueChanged object:nil];

}

- (void)badgeValueChanged:(NSNotification *)noti {
    UIViewController *receiveVC = [self.tabBarController viewControllers][1];
    UIViewController *completeVC = [self.tabBarController viewControllers][2];
    UIViewController *robVC = [self.tabBarController viewControllers][3];
    UIViewController *allorderVC = [self.tabBarController viewControllers][4];
    
    UserModel *userModel = [UserModel readUserModel];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
#if Environment_Mode == 1
    NSString *countString = [NSString stringWithFormat:@"%@Task.ashx?action=gettaskcount&comid=%ld&uid=%ld&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
#elif Environment_Mode == 2
    NSString *countString = [NSString stringWithFormat:@"%@Task.ashx?action=gettaskcount&comid=%ld&uid=%ld&handler_name=%@&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,userModel.name,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
    countString = [countString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
#endif
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:countString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *allString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *countList = [allString componentsSeparatedByString:@","];
        
        [[NSUserDefaults standardUserDefaults] setObject:countList forKey:@"countList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (((NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"countList"]).lastObject) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kupdateBadgeNum object:nil];
        }
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
    self.flag = 1;
    [UIView animateWithDuration:0.4 animations:^{
        self.searchResultView.alpha = 1;
        
        CGRect frame = self.whiteView.frame;
        frame.size.width = Width - 60;
        self.whiteView.frame = frame;
        self.cancelButton.frame = CGRectMake(Width - 55, 7, 60, 30);
        [self.textfield becomeFirstResponder];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)cancelButtonClicked:(UIButton *)sender {
    self.searchPage = 1;
    self.flag = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.alpha = 1;
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
    if (self.dicList.count) {
        [self.dicList removeAllObjects];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_noOrderView) {
        [self.noOrderView removeFromSuperview];
        self.noOrderView = nil;
    }
    if (_noNetWorkingView) {
        [self.noNetWorkingView removeFromSuperview];
        self.noNetWorkingView = nil;
    }
    self.flag = 0;
    self.page = 1;
    self.searchPage = 1;
    [self setBadgeValue];
    [self.activityView startAnimating];
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
    if (self.dicList.count) {
       [self.dicList removeAllObjects];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.manager.operationQueue cancelAllOperations];
    if (self.dicList.count) {
        
        [self.dicList removeAllObjects];
        self.dicList = nil;
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
    
    self.manager = [AFHTTPSessionManager manager];
    UserModel *userModel = [UserModel readUserModel];
#if Environment_Mode == 1
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=getlist&comid=%ld&uid=%ld&state=5&page=%ld&query=&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)self.page,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
#elif Environment_Mode == 2
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=getlist&comid=%ld&uid=%ld&handler_name=%@&state=5&page=%ld&query=&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid, userModel.name, (long)self.page,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
#endif
    
    
    self.manager.requestSerializer.timeoutInterval = 5;
    
    [self.manager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.activityView stopAnimating];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"ResponseInfo"][0][@"PageCount"] forKey:@"PageCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (self.page == 1) {
            if (self.dicList) {
                [self.dicList removeAllObjects];
            }
        }
        for (NSDictionary *dic in responseObject[@"task"]) {
            OrderModel *ordelModel = [OrderModel orderFromDictionary:dic];
            [self.dicList addObject:ordelModel];
        }
        
        
        if (!self.dicList.count) {
            [self.view addSubview:self.noOrderView];
            return ;
        }
        [self.view addSubview:self.tableView];
        if (self.flag != 1) {
            [UIView animateWithDuration:0.3 animations:^{
                self.tableView.alpha = 1;
            }];
        }
        [self.tableView reloadData];
        
        if ([responseObject[@"ResponseInfo"][0][@"PageNow"] integerValue] == [responseObject[@"ResponseInfo"][0][@"PageRowCount"] integerValue]) {
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer.hidden = YES;
            return ;
        }else {
            self.tableView.mj_footer.hidden = NO;
        }
        
        [self.tableView.mj_footer endRefreshing];
        
        
        return ;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [self.manager.operationQueue cancelAllOperations];
        [self.tableView.mj_footer endRefreshing];
        
        [self.activityView stopAnimating];

        [self.view addSubview:self.noNetWorkingView];
        self.tableView.mj_footer.hidden = YES;
        return ;

    }];
    

}

#pragma mark - UITableViewDelegate And DataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView.tag == 300) {
        NSInteger count = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PageCount"] integerValue];
        if (self.dicList.count <= count) {
            return self.dicList.count;
        }else {
            return count;
        }
    }else{
        return self.searchResultList.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#if Environment_Mode == 1
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
    
    cell.acceptDateLabel.text = self.orderModel.acceptDate;
    cell.dateLabel.text = self.orderModel.date;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",self.orderModel.serviceType, self.orderModel.productType]];
    
    [attributedString addAttributes:@{NSForegroundColorAttributeName:color(248, 89, 34, 1)} range:[self.orderModel.serviceType rangeOfString:self.orderModel.serviceType]];
    cell.productTypeLabel.attributedText = attributedString;
    cell.nameLabel.text = self.orderModel.name;
    cell.phoneLabel.text = self.orderModel.phone;
    cell.locationLabel.text = self.orderModel.location;
    cell.assessLabel.text = self.orderModel.assess;
    cell.priceLabel.text = self.orderModel.price;
    cell.areaLabel.text = self.orderModel.area;
    cell.robButton.hidden = YES;
#elif Environment_Mode == 2
    static NSString *identifier = @"Cell";
    CSMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CSMainTableViewCell" owner:self options:nil].lastObject;
        
    }
    
    if (tableView.tag == 300) {
        self.orderModel = self.dicList[indexPath.row];
    }else{
        self.orderModel = self.searchResultList[indexPath.row];
    }
    
    
    cell.dateLabel.text = self.orderModel.date;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",self.orderModel.serviceType, self.orderModel.productType]];
    
    [attributedString addAttributes:@{NSForegroundColorAttributeName:color(248, 89, 34, 1)} range:[self.orderModel.serviceType rangeOfString:self.orderModel.serviceType]];
    cell.productTypeLabel.attributedText = attributedString;
    cell.nameLabel.text = self.orderModel.name;
    cell.phoneLabel.text = self.orderModel.phone;
    cell.locationLabel.text = self.orderModel.location;
    cell.assessLabel.text = self.orderModel.assess;
    cell.areaLabel.text = self.orderModel.area;
#endif
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSelected) {
        return;
    }else {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSArray *vcList = self.navigationController.viewControllers;
        NSInteger count = vcList.count;
        if (count == 3) {
            UIViewController *vc = vcList[count - 2];
            if ([vc isKindOfClass:[PartsRequestViewController class]]) {
                
                if (tableView.tag == 300) {
                    self.orderModel = self.dicList[indexPath.row];
                    
                }else{
                    self.orderModel = self.searchResultList[indexPath.row];
                }
                self.returnParts([NSString stringWithFormat:@"%ld",(long)self.orderModel.ID], self.orderModel.productBreed, self.orderModel.productClassify, self.orderModel.model, self.orderModel.FromUserID, self.orderModel.fromUserName, self.orderModel.ToUserID, self.orderModel.ToUserName, self.orderModel.HandlerID, self.orderModel.HandlerName, self.orderModel.ProductBreedID, self.orderModel.ProductClassify1ID, self.orderModel.ProductClassify2ID, self.orderModel.ProductClassify2Name, self.orderModel.WaiterName);
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if ([vc isKindOfClass:[AppendFeesViewController class]]) {
                
                if (tableView.tag == 300) {
                    self.orderModel = self.dicList[indexPath.row];
                }else{
                    self.orderModel = self.searchResultList[indexPath.row];
                }
                
                if ([self.orderModel.PayMoney integerValue] <= 0) {
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
                    
                    [HUD hideAnimated:YES afterDelay:1.f];
                    return;
                    
                }
                
                if ([self.orderModel.AddMoney integerValue] > 0) {
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
                
                NSInteger count = self.orderModel.price.length;
                self.returnAppend([NSString stringWithFormat:@"%ld",(long)self.orderModel.ID], self.orderModel.name, self.orderModel.location, [NSString stringWithFormat:@"%@ %@ %@",self.orderModel.productBreed, self.orderModel.productClassify, self.orderModel.model], [self.orderModel.price substringToIndex:count - 1], self.orderModel.FromUserID);
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }
        }else {
            
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
            detailVC.waiterName = self.orderModel.WaiterName;
            detailVC.fromUserID = self.orderModel.FromUserID;
            detailVC.fromUserName = self.orderModel.fromUserName;
            detailVC.toUserID = self.orderModel.ToUserID;
            detailVC.toUserName = self.orderModel.ToUserName;
            detailVC.BuyerFullAddress_Incept = self.orderModel.BuyerFullAddress_Incept;
            detailVC.payMoneyStr = self.orderModel.PayMoney;
            detailVC.priceStr = self.orderModel.price;
            detailVC.overPs = self.orderModel.FinishRemark;
            detailVC.productBreed = self.orderModel.productBreed;
            detailVC.productClassify = self.orderModel.productClassify;
            
            detailVC.HandlerID = self.orderModel.HandlerID;
            detailVC.HandlerName = self.orderModel.HandlerName;
            
            detailVC.ProductBreedID = self.orderModel.ProductBreedID;
            detailVC.ProductClassify1ID = self.orderModel.ProductClassify1ID;
            detailVC.ProductClassify2ID = self.orderModel.ProductClassify2ID;
            detailVC.ProductClassify2Name = self.orderModel.ProductClassify2Name;
            detailVC.location = self.orderModel.location;
            detailVC.product = [NSString stringWithFormat:@"%@ %@ %@",self.orderModel.productBreed, self.orderModel.productClassify, self.orderModel.model];
            NSInteger count = self.orderModel.price.length;
            detailVC.productPrice = [self.orderModel.price substringToIndex:count - 1];
            detailVC.payMoney = self.orderModel.PayMoney;
            detailVC.addMoney = self.orderModel.AddMoney;
            detailVC.payMoneyStr = self.orderModel.PayMoney;
            detailVC.priceStr = self.orderModel.price;
#if Environment_Mode == 1
            self.selected = YES;
            NSString *url = [NSString stringWithFormat:@"%@/Common.ashx?action=get_finish_require&&comid=%@",HomeURL,detailVC.fromUserID];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                detailVC.settleAccount = str;
                self.selected = NO;
                [self.navigationController pushViewController:detailVC animated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                self.selected = NO;
            }];
#elif Environment_Mode == 2
            [self.navigationController pushViewController:detailVC animated:YES];
#endif
            
        }
    }
}

#pragma mark - UITextFieldDelegate -
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (_noSearchResultView) {
        [self.noSearchResultView removeFromSuperview];
        self.noSearchResultView = nil;
    }
    
    if (_searchResultTableView) {
        [self.searchResultTableView removeFromSuperview];
        self.searchResultTableView = nil;
    }

    [self.searchActivityView startAnimating];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    UserModel *userModel = [UserModel readUserModel];
#if Environment_Mode == 1
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=getlist&comid=%ld&uid=%ld&state=5&page=%ld&query=%@&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)self.page,textField.text,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
#elif Environment_Mode == 2
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=getlist&comid=%ld&uid=%ld&handler_name=%@&state=5&page=%ld&query=%@&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,userModel.name,(long)self.page,textField.text,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
#endif
    //297错误，URL中有中文，需转码
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    manager.requestSerializer.timeoutInterval = 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [manager.operationQueue cancelAllOperations];
    });
    
    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.searchActivityView stopAnimating];
        if (self.searchResultList.count != 0) {
            [self.searchResultList removeAllObjects];
        }
        for (NSDictionary *dic in responseObject[@"task"]) {
            OrderModel *ordelModel = [OrderModel orderFromDictionary:dic];
            [self.searchResultList addObject:ordelModel];
        }
        
        if (!self.searchResultList.count) {
            [self.searchResultView addSubview:self.noSearchResultView];
            return ;
        }
        [self.searchResultView addSubview:self.searchResultTableView];
        [UIView animateWithDuration:0.3 animations:^{
            self.searchResultTableView.alpha = 1;
        }];
        [self.searchResultTableView reloadData];
        
        if ([responseObject[@"ResponseInfo"][0][@"PageNow"] integerValue] == [responseObject[@"ResponseInfo"][0][@"PageRowCount"] integerValue]) {
            [self.searchResultTableView.mj_footer endRefreshing];
            self.searchResultTableView.mj_footer.hidden = YES;
            return ;
        }else {
            self.searchResultTableView.mj_footer.hidden = NO;
        }
        
        [self.searchResultTableView.mj_footer endRefreshing];
        
        
        return ;

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.searchResultTableView.mj_footer endRefreshing];
        
        [self.searchActivityView stopAnimating];
        [self.searchResultView addSubview:self.noNetWorkingView];
        self.searchResultTableView.mj_footer.hidden = YES;
        return ;
        
    }];

    return YES;
}

- (void)loadMoreSearchData {
    self.searchPage ++;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    UserModel *userModel = [UserModel readUserModel];
#if Environment_Mode == 1
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=getlist&comid=%ld&uid=%ld&state=5&page=%ld&query=%@&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)self.searchPage,self.textfield.text,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
#elif Environment_Mode == 2
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=getlist&comid=%ld&uid=%ld&handler_name=%@&state=5&page=%ld&query=%@&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,userModel.name,(long)self.searchPage,self.textfield.text,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
#endif
    //297错误，URL中有中文，需转码
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    manager.requestSerializer.timeoutInterval = 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [manager.operationQueue cancelAllOperations];
    });
    
    
    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.searchActivityView stopAnimating];
      
        for (NSDictionary *dic in responseObject[@"task"]) {
            OrderModel *ordelModel = [OrderModel orderFromDictionary:dic];
            [self.searchResultList addObject:ordelModel];
        }
        
        if (!self.searchResultList.count) {
            [self.searchResultView addSubview:self.noSearchResultView];
            return ;
        }
        [self.searchResultView addSubview:self.searchResultTableView];
        [self.searchResultTableView reloadData];
        if ([responseObject[@"ResponseInfo"][0][@"PageNow"] integerValue] == [responseObject[@"ResponseInfo"][0][@"PageRowCount"] integerValue]) {
            [self.searchResultTableView.mj_footer endRefreshing];
            self.searchResultTableView.mj_footer.hidden = YES;
            return ;
        }else {
            self.searchResultTableView.mj_footer.hidden = NO;
        }
        [self.searchResultTableView.mj_footer endRefreshing];
        
        
        return ;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.searchResultTableView.mj_footer endRefreshing];
        [self.searchActivityView stopAnimating];

        [self.searchResultView addSubview:self.noNetWorkingView];
        self.searchResultTableView.mj_footer.hidden = YES;
        return ;
    }];

}

- (void)setNaviTitle {
    self.navigationItem.title = @"待完成";
}

- (void)setBadgeValue {
    UIViewController *receiveVC = [self.tabBarController viewControllers][1];
    UIViewController *completeVC = [self.tabBarController viewControllers][2];
    UIViewController *robVC = [self.tabBarController viewControllers][3];
    UIViewController *allorderVC = [self.tabBarController viewControllers][4];
    
    UserModel *userModel = [UserModel readUserModel];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
#if Environment_Mode == 1
    NSString *countString = [NSString stringWithFormat:@"%@Task.ashx?action=gettaskcount&comid=%ld&uid=%ld&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
#elif Environment_Mode == 2
    NSString *countString = [NSString stringWithFormat:@"%@Task.ashx?action=gettaskcount&comid=%ld&uid=%ld&handler_name=%@&provinceid=%ld&cityid=%ld&districtid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid,userModel.name,(long)userModel.provinceid,(long)userModel.cityid,(long)userModel.districtid];
    countString = [countString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
#endif
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


@end
