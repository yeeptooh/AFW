//
//  AddOrderViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/6/21.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "AddOrderViewController.h"
#import "UserDetailTableView.h"
#import "ProductDetailTableView.h"
#import "BusinessDetailTableView.h"


#import "AFNetworking.h"
#import "UserModel.h"
#import "MBProgressHUD.h"

@interface AddOrderViewController ()

@property (nonatomic, strong) UserDetailTableView *userTableView;
@property (nonatomic, strong) ProductDetailTableView *productTableView;
@property (nonatomic, strong) BusinessDetailTableView *businessTableView;

//三条title cell
@property (nonatomic, strong) UIView *firstTitleView;
@property (nonatomic, strong) UIView *secondTitleView;
@property (nonatomic, strong) UIView *thirdTitleView;
//三块detailViewMask
@property (nonatomic, strong) UIView *userInfoDetailView;
@property (nonatomic, strong) UIView *productInfoDetailView;
@property (nonatomic, strong) UIView *businessInfoDetailView;
//title上的三个button
@property (nonatomic, strong) UIButton *userBtn;
@property (nonatomic, strong) UIButton *productBtn;
@property (nonatomic, strong) UIButton *businessBtn;

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UITapGestureRecognizer *tapUserInfo;
@property (nonatomic, strong) UITapGestureRecognizer *tapProductInfo;
@property (nonatomic, strong) UITapGestureRecognizer *tapBusinessInfo;


@end

@implementation AddOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setNavigationBar];
    self.view.backgroundColor = color(241, 241, 241, 1);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self configSaveButton];
    [self configBaseView];
    
    [self configDetailView];
    self.tapUserInfo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userBtnClicked:)];
    self.tapUserInfo.numberOfTapsRequired = 1;
    [self.firstTitleView addGestureRecognizer:self.tapUserInfo];
    self.tapProductInfo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(productBtnClicked:)];
    self.tapProductInfo.numberOfTapsRequired = 1;
    [self.secondTitleView addGestureRecognizer:self.tapProductInfo];
    self.tapBusinessInfo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(businessBtnClicked:)];
    self.tapBusinessInfo.numberOfTapsRequired = 1;
    [self.thirdTitleView addGestureRecognizer:self.tapBusinessInfo];
    
    
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    self.tap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:self.tap];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    [self.view removeGestureRecognizer:self.tap];
}


- (void)configSaveButton {
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*10/11, Width, (Height - StatusBarAndNavigationBarHeight)/11);
    saveBtn.backgroundColor = color(59, 165, 249, 1);
    [saveBtn setTitle:@"下单" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

- (void)configBaseView {
    
    self.firstTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, (Height - StatusBarAndNavigationBarHeight)/11)];
    self.firstTitleView.backgroundColor = color(74, 129, 212, 1);
    [self.view addSubview:self.firstTitleView];
    
    
    self.secondTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*8/11, Width, (Height - StatusBarAndNavigationBarHeight)/11)];
    
    self.secondTitleView.backgroundColor = color(74, 154, 185, 1);
    [self.view addSubview:self.secondTitleView];
    
    
    self.thirdTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*9/11 , Width, (Height - StatusBarAndNavigationBarHeight)/11)];
    self.thirdTitleView.backgroundColor = color(130, 142, 203, 1);
    [self.view addSubview:self.thirdTitleView];
    
    
    UILabel *userInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, Width/2, (Height - StatusBarAndNavigationBarHeight)/11)];
    UILabel *productInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, Width/2, (Height - StatusBarAndNavigationBarHeight)/11)];
    UILabel *businessInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, Width/2, (Height - StatusBarAndNavigationBarHeight)/11)];
    
    [self.firstTitleView addSubview:userInfoLabel];
    [self.secondTitleView addSubview:productInfoLabel];
    [self.thirdTitleView addSubview:businessInfoLabel];
    
    userInfoLabel.text = @"用户信息";
    productInfoLabel.text = @"产品信息";
    businessInfoLabel.text = @"业务信息";
    
    userInfoLabel.textAlignment = NSTextAlignmentLeft;
    productInfoLabel.textAlignment = NSTextAlignmentLeft;
    businessInfoLabel.textAlignment = NSTextAlignmentLeft;
    
    userInfoLabel.font = [UIFont systemFontOfSize:15];
    productInfoLabel.font = [UIFont systemFontOfSize:15];
    businessInfoLabel.font = [UIFont systemFontOfSize:15];
    self.userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.userBtn setTitle:@"单击隐藏" forState:UIControlStateNormal];
    [self.userBtn setTitle:@"单击展开" forState:UIControlStateSelected];
    self.userBtn.frame = CGRectMake(Width*3/4, 0, Width/4, (Height - StatusBarAndNavigationBarHeight)/11);
    self.userBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.userBtn setTitleColor:color(245, 245, 245, 1) forState:UIControlStateNormal];
    [self.userBtn addTarget:self action:@selector(userBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.firstTitleView addSubview:self.userBtn];
    
    
    self.productBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.productBtn setTitle:@"单击展开" forState:UIControlStateNormal];
    [self.productBtn setTitle:@"单击隐藏" forState:UIControlStateSelected];
    self.productBtn.frame = CGRectMake(Width*3/4, 0, Width/4, (Height - StatusBarAndNavigationBarHeight)/11);
    self.productBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.productBtn setTitleColor:color(245, 245, 245, 1) forState:UIControlStateNormal];
    [self.productBtn addTarget:self action:@selector(productBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.secondTitleView addSubview:self.productBtn];
    
    self.businessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.businessBtn setTitle:@"单击展开" forState:UIControlStateNormal];
    [self.businessBtn setTitle:@"单击隐藏" forState:UIControlStateSelected];
    self.businessBtn.frame = CGRectMake(Width*3/4, 0, Width/4, (Height - StatusBarAndNavigationBarHeight)/11);
    self.businessBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.businessBtn setTitleColor:color(245, 245, 245, 1) forState:UIControlStateNormal];
    [self.businessBtn addTarget:self action:@selector(businessBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.thirdTitleView addSubview:self.businessBtn];
}


- (void)configDetailView {
    
    self.userInfoDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)/11, Width, (Height - StatusBarAndNavigationBarHeight)*7/11)];
    self.userInfoDetailView.backgroundColor =  color(241, 241, 241, 1);
    self.userInfoDetailView.layer.masksToBounds = YES;
    
    [self.view addSubview:self.userInfoDetailView];
    self.userTableView = [[UserDetailTableView alloc]initWithFrame:self.userInfoDetailView.bounds style:UITableViewStylePlain];
    [self.userInfoDetailView addSubview:self.userTableView];
    
    //原始
    self.productInfoDetailView = [[UIView alloc]initWithFrame:CGRectMake(0,  (Height - StatusBarAndNavigationBarHeight)*8/11, Width, 0)];
    self.productInfoDetailView.backgroundColor =  color(241, 241, 241, 1);
    [self.view addSubview:self.productInfoDetailView];
    self.productInfoDetailView.layer.masksToBounds = YES;
    
    self.productTableView = [[ProductDetailTableView alloc]initWithFrame:CGRectMake(0, 0, Width, (Height - StatusBarAndNavigationBarHeight)*6/11) style:UITableViewStylePlain];
    [self.productInfoDetailView addSubview:self.productTableView];
    
    
    //原始
    self.businessInfoDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*9/11, Width, 0)];
    self.businessInfoDetailView.backgroundColor =  color(241, 241, 241, 1);
    [self.view addSubview:self.businessInfoDetailView];
    self.businessInfoDetailView.layer.masksToBounds = YES;
    self.businessTableView = [[BusinessDetailTableView alloc]initWithFrame:CGRectMake(0, 0, Width, (Height - StatusBarAndNavigationBarHeight)*3/11) style:UITableViewStylePlain];
    [self.businessInfoDetailView addSubview:self.businessTableView];
    
}


- (void)userBtnClicked:(NSNotification *)sender {
    [self.view endEditing:YES];
    //    sender.selected = !sender.selected;
    self.userBtn.selected = !self.userBtn.selected;
    if (self.userInfoDetailView.bounds.size.height != 0) {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.userInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)/11 , Width, 0);
            self.secondTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)/11, Width, (Height - StatusBarAndNavigationBarHeight)/11);
            self.productInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*2/11, Width, 0);
            self.thirdTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*2/11 , Width, (Height - StatusBarAndNavigationBarHeight)/11);
            self.businessInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*3/11, Width, 0);
            
        }];
    }else{
        if (self.productInfoDetailView.bounds.size.height != 0) {
            self.productBtn.selected = !self.productBtn.selected;
            [UIView animateWithDuration:0.4 animations:^{
                self.userInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)/11 , Width, (Height - StatusBarAndNavigationBarHeight)*7/11);
                
                self.secondTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*8/11, Width, (Height - StatusBarAndNavigationBarHeight)/11);
                
                self.productInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*9/11, Width, 0);
                
            }];
        }else if (self.businessInfoDetailView.bounds.size.height != 0) {
            self.businessBtn.selected = !self.businessBtn.selected;
            [UIView animateWithDuration:0.4 animations:^{
                self.userInfoDetailView.frame = CGRectMake(0,(Height - StatusBarAndNavigationBarHeight)/11 , Width, (Height - StatusBarAndNavigationBarHeight)*7/11);
                
                self.secondTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*8/11, Width, (Height - StatusBarAndNavigationBarHeight)/11);
                
                self.productInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*9/11, Width, 0);
                
                self.thirdTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*9/11, Width, (Height - StatusBarAndNavigationBarHeight)/11);
                
                self.businessInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*10/11, Width, 0);
                
            }];
        }else{
            [UIView animateWithDuration:0.4 animations:^{
                self.userInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)/11 , Width, (Height - StatusBarAndNavigationBarHeight)*7/11);
                
                self.secondTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*8/11, Width, (Height - StatusBarAndNavigationBarHeight)/11);
                self.productInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*9/11, Width, 0);
                
                self.thirdTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*9/11, Width, (Height - StatusBarAndNavigationBarHeight)/12);
                self.businessInfoDetailView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight + (Height - StatusBarAndNavigationBarHeight)*10/11, Width, 0);
                
            }];
        }
    }
}

- (void)productBtnClicked:(NSNotification *)sender {
    [self.view endEditing:YES];
    //    sender.selected = !sender.selected;
    self.productBtn.selected = !self.productBtn.selected;
    if (self.productInfoDetailView.bounds.size.height != 0) {
        [UIView animateWithDuration:0.4 animations:^{
            
            self.productInfoDetailView.frame = CGRectMake(0,(Height - StatusBarAndNavigationBarHeight)*2/11 , Width, 0);
            
            self.thirdTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*2/11, Width, (Height - StatusBarAndNavigationBarHeight)/11);
            self.businessInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*3/11, Width, 0);
        }];
    }else{
        if (self.userInfoDetailView.bounds.size.height != 0) {
            self.userBtn.selected = !self.userBtn.selected;
            
            [UIView animateWithDuration:0.4 animations:^{
                self.userInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)/11 , Width, 0);
                
                self.secondTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)/11 , Width, (Height - StatusBarAndNavigationBarHeight)/11);
                
                self.productInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*2/11 , Width, (Height - StatusBarAndNavigationBarHeight)*6/11);
                
            }];
            
        }else if (self.businessInfoDetailView.bounds.size.height != 0) {
            self.businessBtn.selected = !self.businessBtn.selected;
            [UIView animateWithDuration:0.4 animations:^{
                
                self.productInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*2/11 , Width, (Height - StatusBarAndNavigationBarHeight)*6/11);
                
                self.thirdTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*9/11, Width, (Height - StatusBarAndNavigationBarHeight)/11);
                
                self.businessInfoDetailView.frame = CGRectMake(0,(Height - StatusBarAndNavigationBarHeight)*10/11, Width, 0);
            }];
            
        }else{
            [UIView animateWithDuration:0.4 animations:^{
                
                self.productInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*2/11 , Width, (Height - StatusBarAndNavigationBarHeight)*6/11);
                
                self.thirdTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*9/11, Width, (Height - StatusBarAndNavigationBarHeight)/11);
                self.businessInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*10/11, Width, 0);
                
            }];
        }
    }
}

- (void)businessBtnClicked:(NSNotification *)sender {
    [self.view endEditing:YES];
//        sender.selected = !sender.selected;
    self.businessBtn.selected = !self.businessBtn.selected;
    if (self.businessInfoDetailView.bounds.size.height != 0) {
        [UIView animateWithDuration:0.4 animations:^{
            self.businessInfoDetailView.frame = CGRectMake(0,(Height - StatusBarAndNavigationBarHeight)*3/11 , Width, 0);
        }];
    }else{
        
        if (self.productInfoDetailView.bounds.size.height != 0) {
            self.productBtn.selected = !self.productBtn.selected;
            [UIView animateWithDuration:0.4 animations:^{
                
                self.productInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*2/11 , Width,0);
                
                self.thirdTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*2/11, Width, (Height - StatusBarAndNavigationBarHeight)/11);
                
                self.businessInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*3/11 , Width, (Height - StatusBarAndNavigationBarHeight)*3/11);
                
            }];
        }else if (self.userInfoDetailView.bounds.size.height != 0) {
            self.userBtn.selected = !self.userBtn.selected;
            [UIView animateWithDuration:0.4 animations:^{
                
                self.userInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)/11 , Width, 0);
                self.secondTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)/11 , Width, (Height - StatusBarAndNavigationBarHeight)/11);
                self.productInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*2/11, Width, 0);
                self.thirdTitleView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*2/11 , Width, (Height - StatusBarAndNavigationBarHeight)/11);
                
                self.businessInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*3/11 , Width, (Height - StatusBarAndNavigationBarHeight)*3/11);
                
            }];
        }else{
            
            [UIView animateWithDuration:0.4 animations:^{
                self.businessInfoDetailView.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*3/11 , Width, (Height - StatusBarAndNavigationBarHeight)*3/11);
            }];
        }
    }
}

- (void)saveButtonClicked:(UIButton *)sender {
    
}


-(void)setNavigationBar {
    
    self.navigationItem.title = @"我要下单";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
