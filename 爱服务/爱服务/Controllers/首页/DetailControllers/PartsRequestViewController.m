//
//  PartsRequestViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "PartsRequestViewController.h"
#import "UserModel.h"
#import "MBProgressHUD.h"
#import "CompleteViewController.h"
#import "AFNetworking.h"
#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>
@interface PartsRequestViewController ()
<
WKNavigationDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) MBProgressHUD *errorHUD;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;

@property (nonatomic, assign) NSInteger selectedBtnposition;

@property (nonatomic, strong) NSData *imageData1;
@property (nonatomic, strong) NSData *imageData2;
@property (nonatomic, strong) NSData *imageData3;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UIAlertController *alertController;

@end
static NSInteger number;
@implementation PartsRequestViewController




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


- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        _indicatorView.center = CGPointMake(self.webView.bounds.size.width/2, self.webView.bounds.size.height/3);
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.webView addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addKeyBoardNotification];
    [self setScrollView];
    [self setNaviTitle];
}

- (void)setScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight)];
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = color(241, 241, 241, 1);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(Width,(Height - StatusBarAndNavigationBarHeight) * 19/12);
    [self.view addSubview:self.scrollView];
    
    NSArray *labelList = @[
                           @"工单号",
                           @"商品品牌",
                           @"商品类别",
                           @"商品型号",
                           @"申请数量",
                           @"配件描述",
                           @"收货人",
                           @"联系电话",
                           @"收货地址",
                           @"附加照片",
                           ];
    
    for (NSInteger i = 0; i < 10; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5 + ((Height - StatusBarAndNavigationBarHeight)*i/12), Width/4, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
        
        label.text = labelList[i];
        CGFloat fontsize;
        if (iPhone6_plus || iPhone6) {
            fontsize = 16;
        }else{
            fontsize = 14;
        }
        label.font = [UIFont systemFontOfSize:fontsize];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor blackColor];
        [self.scrollView addSubview:label];
    }
    
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (!_ID) {
        [self.chooseButton setTitle:@"请先选择工单" forState:UIControlStateNormal];
    }else{
        [self.chooseButton setTitle:_ID forState:UIControlStateNormal];
    }
    if (self.flag) {
        self.chooseButton.enabled = NO;
    }
    CGFloat fontsize;
    if (iPhone4_4s || iPhone5_5s) {
        fontsize = 14;
    }else{
        fontsize = 16;
    }
    self.chooseButton.titleLabel.font = font(fontsize);
    [self.chooseButton setTitleColor:color(30, 30, 30, 1) forState:UIControlStateNormal];
    [self.chooseButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseButton.layer.cornerRadius = 5;
    self.chooseButton.layer.masksToBounds = YES;
    self.chooseButton.tag = 500;
    self.chooseButton.backgroundColor = [UIColor whiteColor];
    self.chooseButton.frame = CGRectMake(Width*5/16, 5, Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10);
    [self.scrollView addSubview:self.chooseButton];
    
    for (NSInteger i = 0; i < 3; i ++) {
        if (i == 0) {
            self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(Width*5/16, 5 + ((Height - StatusBarAndNavigationBarHeight)*(i+1)/12), Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
            self.label1.textColor = [UIColor grayColor];
            self.label1.backgroundColor = [UIColor whiteColor];
            self.label1.font = font(fontsize);
            self.label1.layer.cornerRadius = 5;
            self.label1.layer.masksToBounds = YES;
            self.label1.tag = 1000 + i;
            [self.scrollView addSubview:self.label1];
            self.label1.text = _brand;
           
        }else if (i == 1) {
            self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(Width*5/16, 5 + ((Height - StatusBarAndNavigationBarHeight)*(i+1)/12), Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
            self.label2.textColor = [UIColor grayColor];
            self.label2.backgroundColor = [UIColor whiteColor];
            self.label2.font = font(fontsize);
            self.label2.layer.cornerRadius = 5;
            self.label2.layer.masksToBounds = YES;
            self.label2.tag = 1000 + i;
            [self.scrollView addSubview:self.label2];
            self.label2.text = _type;
        }else {
            self.label3 = [[UILabel alloc]initWithFrame:CGRectMake(Width*5/16, 5 + ((Height - StatusBarAndNavigationBarHeight)*(i+1)/12), Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
            self.label3.textColor = [UIColor grayColor];
            self.label3.backgroundColor = [UIColor whiteColor];
            self.label3.font = font(fontsize);
            self.label3.layer.cornerRadius = 5;
            self.label3.layer.masksToBounds = YES;
            self.label3.tag = 1000 + i;
            [self.scrollView addSubview:self.label3];
            self.label3.text = _model;
        }
        
    }
    
    for (NSInteger i = 0; i < 5; i ++) {
        if (i == 2) {
            self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(Width*5/16, 5 + ((Height - StatusBarAndNavigationBarHeight)*(i+4)/12), Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
            self.textfield.text = self.WaiterName;
            self.textfield.backgroundColor = [UIColor whiteColor];
            self.textfield.font = font(fontsize);
            self.textfield.layer.cornerRadius = 5;
            self.textfield.layer.masksToBounds = YES;
            
            self.textfield.tag = 1003 + i;
            [self.scrollView addSubview: self.textfield];
        }else {
            UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(Width*5/16, 5 + ((Height - StatusBarAndNavigationBarHeight)*(i+4)/12), Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
            if (i == 0) {
                textfield.text = @"1";
            }
            textfield.backgroundColor = [UIColor whiteColor];
            textfield.font = font(fontsize);
            textfield.layer.cornerRadius = 5;
            textfield.layer.masksToBounds = YES;
            
            textfield.tag = 1003 + i;
            [self.scrollView addSubview: textfield];
        }
    }
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(20, 10 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), (Width - 120)/3, 4*(Width - 120)/9)];
    firstView.backgroundColor = color(230, 230, 230, 1);
    
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3, 10 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), (Width - 120)/3, 4*(Width - 120)/9)];
    secondView.backgroundColor = color(230, 230, 230, 1);
    UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3, 10 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), (Width - 120)/3, 4*(Width - 120)/9)];
    thirdView.backgroundColor = color(230, 230, 230, 1);
    
    [self.scrollView addSubview:firstView];
    [self.scrollView addSubview:secondView];
    [self.scrollView addSubview:thirdView];
    {
        UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(20 + (Width - 120)/6 - 1, 20 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), 1, 4*(Width - 120)/9 - 20)];
        firstLineView.backgroundColor = [UIColor whiteColor];
        UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(25, 10 + 2*(Width - 120)/9 - 1 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), (Width - 120)/3 - 10, 1)];
        secondLineView.backgroundColor = [UIColor whiteColor];
        
        [self.scrollView addSubview:firstLineView];
        [self.scrollView addSubview:secondLineView];
    }
    
    {
        UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3 + (Width - 120)/6 - 1, 20 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), 1, 4*(Width - 120)/9 - 20)];
        firstLineView.backgroundColor = [UIColor whiteColor];
        UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(65 + (Width - 120)/3, 10 + 2*(Width - 120)/9 - 1 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), (Width - 120)/3 - 10, 1)];
        secondLineView.backgroundColor = [UIColor whiteColor];
        
        [self.scrollView addSubview:firstLineView];
        [self.scrollView addSubview:secondLineView];
        
    }
    
    {
        UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3 + (Width - 120)/6 - 1, 20 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), 1, 4*(Width - 120)/9 - 20)];
        firstLineView.backgroundColor = [UIColor whiteColor];
        UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(Width - 15 - (Width - 120)/3, 10 + 2*(Width - 120)/9 - 1 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), (Width - 120)/3 - 10, 1)];
        secondLineView.backgroundColor = [UIColor whiteColor];
        
        [self.scrollView addSubview:firstLineView];
        [self.scrollView addSubview:secondLineView];
        
    }
    
    self.firstImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), (Width - 120)/3, 4*(Width - 120)/9)];
    self.secondImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3, 10 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), (Width - 120)/3, 4*(Width - 120)/9)];
    self.thirdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3, 10 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), (Width - 120)/3, 4*(Width - 120)/9)];
    
    [self.scrollView addSubview:self.firstImageView];
    [self.scrollView addSubview:self.secondImageView];
    [self.scrollView addSubview:self.thirdImageView];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    firstButton.backgroundColor = [UIColor clearColor];
    firstButton.frame = CGRectMake(20, 10 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), (Width - 120)/3, 4*(Width - 120)/9);
    [self.scrollView addSubview:firstButton];
    firstButton.tag = 4001;
    [firstButton addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.backgroundColor = [UIColor clearColor];
    secondButton.frame = CGRectMake(60 + (Width - 120)/3, 10 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), (Width - 120)/3, 4*(Width - 120)/9);
    [self.scrollView addSubview:secondButton];
    secondButton.tag = 4002;
    [secondButton addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdButton.backgroundColor = [UIColor clearColor];
    thirdButton.frame = CGRectMake(Width - 20 - (Width - 120)/3, 10 + ((Height - StatusBarAndNavigationBarHeight)*(10)/12), (Width - 120)/3, 4*(Width - 120)/9);
    [self.scrollView addSubview:thirdButton];
    thirdButton.tag = 4003;
    [thirdButton addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    submit.layer.cornerRadius = 5;
    submit.layer.masksToBounds = YES;
    submit.backgroundColor = MainBlueColor;
    submit.frame = CGRectMake(20, ((Height - StatusBarAndNavigationBarHeight)*(13)/12), Width - 40, (Height - StatusBarAndNavigationBarHeight)/12);
    [self.scrollView addSubview:submit];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    UserModel *userModel = [UserModel readUserModel];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(20, 5 + ((Height - StatusBarAndNavigationBarHeight)*(14)/12), Width - 40, (Height - StatusBarAndNavigationBarHeight)*5/12 - 10)];
    [self.indicatorView startAnimating];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@page.aspx?type=applymine&comid=%ld&uid=%ld",HomeURL,(long)userModel.comid,(long)userModel.uid]]]];
    [self.scrollView addSubview:self.webView];
    
}

- (void)chooseButtonClicked:(UIButton *)sender {
    
    CompleteViewController *cpVC = [[CompleteViewController alloc]init];
    cpVC.returnParts = ^(NSString *orderID, NSString *brand, NSString *type, NSString *model, NSString *FromUserID, NSString *FromUserName, NSString *ToUserID, NSString *ToUserName, NSString *HandlerID, NSString *HandlerName, NSString *ProductBreedID, NSString *ProductClassify1ID, NSString *ProductClassify2ID, NSString *ProductClassify2Name, NSString *WaiterName) {
        _ID = orderID;
        _brand = brand;
        _type = type;
        _model = model;
        UIButton *button = [self.scrollView viewWithTag:500];
        [button setTitle:_ID forState:UIControlStateNormal];
        UILabel *label1 = [self.scrollView viewWithTag:1000];
        label1.text = _brand;
        UILabel *label2 = [self.scrollView viewWithTag:1001];
        label2.text = _type;
        UILabel *label3 = [self.scrollView viewWithTag:1002];
        label3.text = _model;
        _FromUserID = FromUserID;
        _FromUserName = FromUserName;
        _ToUserID = ToUserID;
        _ToUserName = ToUserName;
        _ProductBreedID = ProductBreedID;
        _ProductClassify1ID = ProductClassify1ID;
        _ProductClassify2ID = ProductClassify2ID;
        _ProductClassify2Name = ProductClassify2Name;
        _WaiterName = WaiterName;
        
        UITextField *textfield = [self.scrollView viewWithTag:1005];
        textfield.text = WaiterName;
        
    };
    
    [self.navigationController pushViewController:cpVC animated:YES];
    
}

- (void)pictureAction:(UIButton *)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AVCan"]) {
            NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController.navigationBar.barStyle = UIBarStyleBlack;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AVCan"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            NSLog(@"%ld",(long)status);
            if (status == AVAuthorizationStatusAuthorized) {
                NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
                
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
                imagePickerController.navigationBar.barStyle = UIBarStyleBlack;
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                imagePickerController.sourceType = sourceType;
                
                [self presentViewController:imagePickerController animated:YES completion:^{
                    
                }];
                
            }else {
                [self presentViewController:self.alertController animated:YES completion:nil];
            }
        }
        
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.navigationBar.barStyle = UIBarStyleBlack;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];

    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:albumAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    if (sender.tag == 4001) {
        self.selectedBtnposition = 1;
    }else if (sender.tag == 4002) {
        self.selectedBtnposition = 2;
    }else if(sender.tag == 4003) {
        self.selectedBtnposition = 3;
    }
    
}

#pragma mark - UIImagePickcerControllerDelegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.selectedBtnposition != 0) {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        if (self.selectedBtnposition == 1) {
            self.firstImageView.image = image;
        }   
        if (self.selectedBtnposition == 2) {
            self.secondImageView.image = image;
        }
        if (self.selectedBtnposition == 3) {
            self.thirdImageView.image = image;
        }
        
        self.selectedBtnposition ++;
        if (self.selectedBtnposition == 4) {
            self.selectedBtnposition = 1;
        }
        
        return;
    }else{
        self.selectedBtnposition = 2;
        self.firstImageView.image = image;
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)submitClicked:(UIButton *)sender {
    
    if (number == 1) {
        number = 0;
        return;
    }
    
    number = 1;
    
    if ([self.chooseButton.titleLabel.text isEqualToString:@"请先选择工单"]) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
        HUD.mode = MBProgressHUDModeText;
        HUD.label.text = @"请先选择工单";
        HUD.label.font = font(14);
        [self.view addSubview:HUD];
        [HUD showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
            [HUD removeFromSuperViewOnHide];
        });
        
        return;
    }
    
    NSInteger count = 0;
    if (self.firstImageView.image) {
        count ++;
        self.imageData1 = UIImageJPEGRepresentation(self.firstImageView.image, 0.1);//UIImagePNGRepresentation(self.firstImageView.image);//
    }
    
    if (self.secondImageView.image) {
        count ++;
        self.imageData2 = UIImageJPEGRepresentation(self.secondImageView.image, 0.1);//UIImagePNGRepresentation(self.secondImageView.image);//
    }
    
    if (self.thirdImageView.image) {
        count ++;
        self.imageData3 = UIImageJPEGRepresentation(self.thirdImageView.image, 0.1);//UIImagePNGRepresentation(self.thirdImageView.image);//
    }
    
    NSArray *picArray = [[NSArray alloc]init];
    
    if (self.firstImageView.image) {
        if (self.secondImageView.image) {
            if (self.thirdImageView.image) {
                picArray = @[self.imageData1,self.imageData2,self.imageData3];
            }else{
                picArray = @[self.imageData1,self.imageData2];
            }
        }else{
            if (self.thirdImageView.image) {
                picArray = @[self.imageData1,self.imageData3];
            }else{
                picArray = @[self.imageData1];
            }
        }
    }else{
        if (self.secondImageView.image) {
            if (self.thirdImageView.image) {
                picArray = @[self.imageData2,self.imageData3];
            }else{
                picArray = @[self.imageData2];
            }
        }else{
            if (self.thirdImageView.image) {
                picArray = @[self.imageData3];
            }else{
                picArray = @[];
            }
        }
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.requestSerializer.timeoutInterval = 5;
    
    NSString *URL = [NSString stringWithFormat:@"%@apply.ashx?action=applysubmit",HomeURL];
    
    if (!((UITextField *)[self.scrollView viewWithTag:1003]).text) {
        ((UITextField *)[self.scrollView viewWithTag:1003]).text = @"";
    }
    if (!((UITextField *)[self.scrollView viewWithTag:1004]).text) {
        ((UITextField *)[self.scrollView viewWithTag:1004]).text = @"";
    }
    if (!((UITextField *)[self.scrollView viewWithTag:1005]).text) {
        ((UITextField *)[self.scrollView viewWithTag:1005]).text = @"";
    }
    if (!((UITextField *)[self.scrollView viewWithTag:1006]).text) {
        ((UITextField *)[self.scrollView viewWithTag:1006]).text = @"";
    }
    if (!((UITextField *)[self.scrollView viewWithTag:1007]).text) {
        ((UITextField *)[self.scrollView viewWithTag:1007]).text = @"";
    }
    
    if ([((UITextField *)[self.scrollView viewWithTag:1006]).text isEqualToString:@""]) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
        HUD.mode = MBProgressHUDModeText;
        HUD.label.text = @"请填写联系电话";
        HUD.label.font = font(14);
        [self.view addSubview:HUD];
        [HUD showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
            [HUD removeFromSuperViewOnHide];
        });
        
        return;
    }
    
    if ([((UITextField *)[self.scrollView viewWithTag:1007]).text isEqualToString:@""]) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
        HUD.mode = MBProgressHUDModeText;
        HUD.label.text = @"请填写收货地址";
        HUD.label.font = font(14);
        [self.view addSubview:HUD];
        [HUD showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
            [HUD removeFromSuperViewOnHide];
        });
        
        return;
    }
    
    
    UserModel *userModel = [UserModel readUserModel];
    NSDictionary *params = @{
                             @"fromuserid":self.ToUserID,
                             @"fromusername":self.ToUserName,
                             @"touserid":self.FromUserID,
                             @"tousername":self.FromUserName,
                             @"handlerid":@(userModel.uid),
                             @"handlername":userModel.name,
                             @"taskid":_ID,
                             @"breedid":self.ProductBreedID,
                             @"breed":self.brand,
                             @"bigcateid":self.ProductClassify1ID,
                             @"bigcate":@"",
                             @"smallcateid":self.ProductClassify2ID,
                             @"smallcate":self.ProductClassify2Name,
                             @"producttype":self.model,
                             @"number":((UITextField *)[self.scrollView viewWithTag:1003]).text,
                             @"describe":((UITextField *)[self.scrollView viewWithTag:1004]).text,
                             @"receivname":((UITextField *)[self.scrollView viewWithTag:1005]).text,
                             @"receivphone":((UITextField *)[self.scrollView viewWithTag:1006]).text,
                             @"receivaddress":((UITextField *)[self.scrollView viewWithTag:1007]).text
                             };
    
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:HUD];
    [HUD showAnimated:YES];
    
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSInteger i = 0; i < count; i ++) {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.jpeg",[formatter stringFromDate:date],(long)i];
            
            [formData appendPartWithFileData:picArray[i] name:fileName fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HUD hideAnimated:YES];
        [HUD removeFromSuperViewOnHide];
        MBProgressHUD *successHUD = [[MBProgressHUD alloc]initWithView:self.view];
        successHUD.mode = MBProgressHUDModeText;
        successHUD.label.font = font(14);
        successHUD.label.text = @"提交成功";
        [self.view addSubview:successHUD];
        
        [successHUD showAnimated:YES];
        number = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [successHUD hideAnimated:YES];
            [successHUD removeFromSuperViewOnHide];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        number = 0;

        [HUD hideAnimated:YES];
        [HUD removeFromSuperViewOnHide];
        MBProgressHUD *errorHUD = [[MBProgressHUD alloc]initWithView:self.view];
        errorHUD.mode = MBProgressHUDModeText;
        errorHUD.label.font = font(14);
        errorHUD.label.text = @"提交失败";
        [self.view addSubview:errorHUD];
        
        [errorHUD showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [errorHUD hideAnimated:YES];
            [errorHUD removeFromSuperViewOnHide];
            
        });
    }];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.indicatorView stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.indicatorView stopAnimating];
        UILabel *label = [[UILabel alloc] init];
        
        label.frame = CGRectMake(0, 0, self.webView.bounds.size.width, self.webView.bounds.size.height);
        label.center = CGPointMake(self.webView.bounds.size.width/2, self.webView.bounds.size.height/2);
        label.text = @"无法加载网页，请检查网络连接";
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = font(15);
        label.backgroundColor = [UIColor clearColor];
        [self.webView addSubview:label];
        
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.indicatorView stopAnimating];
        UILabel *label = [[UILabel alloc] init];
        
        label.frame = CGRectMake(0, 0, self.webView.bounds.size.width, self.webView.bounds.size.height);
        label.center = CGPointMake(self.webView.bounds.size.width/2, self.webView.bounds.size.height/2);
        label.text = @"无法加载网页，请检查网络连接";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = font(15);
        label.backgroundColor = [UIColor clearColor];
        [self.webView addSubview:label];
    }
}

- (void)setNaviTitle {
    self.navigationItem.title = @"配件申请";
}

- (void)keyBoardWillShow {
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    self.tap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:self.tap];
}

- (void)keyBoardWillHide {
    [self.scrollView removeGestureRecognizer:self.tap];
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

@end
