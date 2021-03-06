//
//  AppendReasonViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/7/21.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "AppendReasonViewController.h"
#import "HYBModalTransition.h"
#import "ReasonTableViewCell.h"
@interface AppendReasonViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIViewControllerTransitioningDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AppendReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 25, Width, self.view.bounds.size.height - 20) style:UITableViewStylePlain];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(Width*6/7, 5, 20, 20);
    [backBtn setImage:[UIImage imageNamed:@"icon_login_close_pre"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"icon_login_close_nor"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    [self.view addSubview:self.tableView];
}

- (void)backBtnClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reasonList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    ReasonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ReasonTableViewCell" owner:self options:nil].lastObject;
    }
    cell.reasonLabel.text = self.reasonList[indexPath.row][@"Name"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 24;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.returnReason(self.reasonList[indexPath.row][@"Name"]);
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [HYBModalTransition transitionWithType:kHYBModalTransitionPresent duration:0.25 presentHeight:(Height - StatusBarAndNavigationBarHeight)*8/12 scale:CGPointMake(0.9, 0.9)];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [HYBModalTransition transitionWithType:kHYBModalTransitionDismiss duration:0.25 presentHeight:(Height - StatusBarAndNavigationBarHeight)*8/12 scale:CGPointMake(0.9, 0.9)];
}


@end
