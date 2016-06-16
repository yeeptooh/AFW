//
//  AcceptViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/27.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "AcceptViewController.h"
#import "EnsureOrderViewController.h"
@interface AcceptViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AcceptViewController

- (NSMutableArray *)wList {
    if (!_wList) {
        _wList = [NSMutableArray array];
    }
    return _wList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviTitle];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = color(241, 241, 241, 1);
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, (Height - StatusBarAndNavigationBarHeight)) style:UITableViewStylePlain];
    self.tableView.backgroundColor = color(241, 241, 241, 1);
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"acceptCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, Width/4, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
    
    label.text = self.wList[indexPath.row][@"Name"];
    CGFloat fontsize;
    if (iPhone6_plus || iPhone6) {
        fontsize = 16;
    }else{
        fontsize = 14;
    }
    label.font = [UIFont systemFontOfSize:fontsize];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = BlueColor;
    label.backgroundColor = [UIColor clearColor];
    
    [cell addSubview:label];
    
    
        
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width*5/16, 5, Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
    
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.font = font(fontsize);
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.textColor = BlueColor;
    phoneLabel.text = self.wList[indexPath.row][@"Phone"];
    [cell addSubview:phoneLabel];
        
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (Height - StatusBarAndNavigationBarHeight)/12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EnsureOrderViewController *eoVC = [[EnsureOrderViewController alloc]init];
    eoVC.ID = self.ID;
    eoVC.wID = self.wList[indexPath.row][@"ID"];
    eoVC.wName = self.wList[indexPath.row][@"Name"];
    eoVC.wPhone = self.wList[indexPath.row][@"Phone"];
    [self presentViewController:eoVC animated:YES completion:^{
        [eoVC.textfield becomeFirstResponder];
    }];
    
}


- (void)setNaviTitle {
    self.navigationItem.title = @"选择师傅";
}

@end
