//
//  GatheringViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/7/6.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "GatheringViewController.h"
#import "ZDDBezierPathView.h"
#import "AFNetworking.h"
#import "UserModel.h"
#import <CoreImage/CoreImage.h>
#import "MBProgressHUD.h"
@interface GatheringViewController ()
<
UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate
>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) UIView *secondView;

@property (nonatomic, strong) UIImagePickerController *pickerController1;
@property (nonatomic, strong) UIImagePickerController *pickerController2;
@end

@implementation GatheringViewController

- (UIImageView *)imageView1 {
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width*3/5, Width*3/5)];
    }
    return _imageView1;
}

- (UIImageView *)imageView2 {
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width*3/5, Width*3/5)];
    }
    return _imageView2;
}

- (UIView *)firstView {
    if (!_firstView) {
        _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight)];
//        _firstView.backgroundColor = GreenColor;

    }
    return _firstView;
}

- (UIView *)secondView {
    if (!_secondView) {
        _secondView  = [[UIView alloc] initWithFrame:CGRectMake(Width, 0, Width, Height - StatusBarAndNavigationBarHeight)];
//        _secondView.backgroundColor =  BlueColor;
    }
    return _secondView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(Width * 2, Height - StatusBarAndNavigationBarHeight);
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [_scrollView addSubview:self.firstView];
        [_scrollView addSubview:self.secondView];
        _scrollView.backgroundColor = WXGreenColor;
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*8/9, Width, 1)];
        
        self.pageControl.numberOfPages = 2;
        self.pageControl.currentPage = 0;
        self.pageControl.selected = NO;
        self.pageControl.pageIndicatorTintColor =  [UIColor colorWithRed:1  green:1  blue:1 alpha:0.7];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:1  green:1  blue:1 alpha:0.9];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width, 50)];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = @"微信收款";
        label1.font = [UIFont fontWithName:@"HYQiHei-55S" size:16];
        label1.textColor = [UIColor whiteColor];
        
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width, 50)];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = @"支付宝收款";
        label2.font = [UIFont fontWithName:@"HYQiHei-55S" size:16];
        label2.textColor = [UIColor whiteColor];
        
        UIView *containerView1  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width*4/5, Height - StatusBarAndNavigationBarHeight - 200)];
        containerView1.backgroundColor = [UIColor clearColor];
        containerView1.center = self.firstView.center;
        
        UIView *containerView2  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width*4/5, Height - StatusBarAndNavigationBarHeight - 200)];
        containerView2.backgroundColor = [UIColor clearColor];
        containerView2.center = self.firstView.center;
        
        ZDDBezierPathView *bezierPathView1 = [[ZDDBezierPathView alloc] initWithFrame:CGRectMake(Width /10, 0, Width*3/5, Width*3/5)];
        bezierPathView1.backgroundColor = [UIColor clearColor];
        [containerView1 addSubview:bezierPathView1];
        [self.firstView addSubview:containerView1];
        
        UILabel *labelzz = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bezierPathView1.bounds.size.width * 3 / 5, 1)];
        labelzz.backgroundColor = [UIColor whiteColor];
        labelzz.center = CGPointMake(bezierPathView1.bounds.size.width/2, bezierPathView1.bounds.size.width/2 - 0.5);
        
        UILabel *labelxx = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, bezierPathView1.bounds.size.width * 3 / 5)];
        labelxx.backgroundColor = [UIColor whiteColor];
        labelxx.center = CGPointMake(bezierPathView1.bounds.size.width/2 - 0.5, bezierPathView1.bounds.size.width/2);
        
        [bezierPathView1 addSubview:labelxx];
        [bezierPathView1 addSubview:labelzz];
        
     
        [bezierPathView1 addSubview:self.imageView1];
        self.imageView1.userInteractionEnabled = YES;
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.backgroundColor = [UIColor clearColor];
        button1.frame = self.imageView1.bounds;
        [self.imageView1 addSubview:button1];
        [button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        ZDDBezierPathView *bezierPathView2 = [[ZDDBezierPathView alloc] initWithFrame:CGRectMake(Width /10, 0, Width*3/5, Width*3/5)];
        bezierPathView2.backgroundColor = [UIColor clearColor];
        [containerView2 addSubview:bezierPathView2];
        [self.secondView addSubview:containerView2];
        
        UILabel *labelzzz = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bezierPathView2.bounds.size.width * 3 / 5, 1)];
        labelzzz.backgroundColor = [UIColor whiteColor];
        labelzzz.center = CGPointMake(bezierPathView2.bounds.size.width/2, bezierPathView2.bounds.size.width/2 - 0.5);
        
        UILabel *labelxxx = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, bezierPathView2.bounds.size.width * 3 / 5)];
        labelxxx.backgroundColor = [UIColor whiteColor];
        labelxxx.center = CGPointMake(bezierPathView2.bounds.size.width/2 - 0.5, bezierPathView2.bounds.size.width/2);
        
        [bezierPathView2 addSubview:labelxxx];
        [bezierPathView2 addSubview:labelzzz];
        

        [bezierPathView2 addSubview:self.imageView2];
        self.imageView2.userInteractionEnabled = YES;
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.backgroundColor = [UIColor clearColor];
        button2.frame = self.imageView2.bounds;
        [self.imageView2 addSubview:button2];
        [button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (Height - StatusBarAndNavigationBarHeight) * 7 / 9, Width, 50)];
        leftLabel.text  = @"请点击按钮添加微信收款二维码";
        leftLabel.font = [UIFont fontWithName:@"HYQiHei-55S" size:16];
        leftLabel.textColor = [UIColor whiteColor];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.firstView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (Height - StatusBarAndNavigationBarHeight) * 7 / 9, Width, 50)];
        rightLabel.text  = @"请点击按钮添加支付宝收款二维码";
        rightLabel.font = [UIFont fontWithName:@"HYQiHei-55S" size:16];
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.secondView addSubview:rightLabel];
        
        
        [self.firstView addSubview:label1];
        [self.secondView addSubview:label2];
        
    }
    return _scrollView;
}


- (void)button1Clicked:(UIButton *)sender {
    
    self.pickerController1 = [[UIImagePickerController alloc] init];
    self.pickerController1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.pickerController1.delegate = self;
    self.pickerController1.allowsEditing = YES;
    
    self.pickerController1.navigationBar.barStyle = UIBarStyleBlack;
    
    [self presentViewController:self.pickerController1 animated:YES completion:nil];
    
    
}

- (void)button2Clicked:(UIButton *)sender {
    
    self.pickerController2 = [[UIImagePickerController alloc] init];
    self.pickerController2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.pickerController2.delegate = self;
    self.pickerController2.allowsEditing = YES;
    
    self.pickerController2.navigationBar.barStyle = UIBarStyleBlack;
    
    [self presentViewController:self.pickerController2 animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    CIQRCodeFeature *QRCodeFeature = (CIQRCodeFeature *)[[self detectQRCodeWithImage:image] firstObject];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.minSize = CGSizeMake(100, 100);
    hud.label.text = @"识别中...";
    hud.label.font = font(14);
    
    if ([self detectQRCodeWithImage:image].count != 0) {
        
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        
        [filter setDefaults];
        
        NSData *urlData = [QRCodeFeature.messageString dataUsingEncoding:NSUTF8StringEncoding];
        
        
        [filter setValue:urlData forKey:@"inputMessage"];
        CIImage *ciImage = [filter outputImage];
        
        UIImage *qrImage = [self createNonInterpolatedUIImageFromCIImage:ciImage withSize:self.imageView1.bounds.size.width];
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = NSLocalizedString(@"高清上传", @"HUD completed title");
        hud.label.font = font(14);
        
        
        if ([picker isEqual:self.pickerController1]) {
            self.imageView1.image = qrImage;
            NSData *qrData = UIImagePNGRepresentation(qrImage);
            UserModel *userModel = [UserModel readUserModel];
            
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 15;
            NSString *url = [NSString stringWithFormat:@"%@uploadFile.ashx?action=uploadimages",HomeURL];
            NSDictionary *params = @{@"userId":@(userModel.uid)};
            [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString *fileName = [NSString stringWithFormat:@"%@WX.jpeg",[formatter stringFromDate:date]];
                
                [formData appendPartWithFileData:qrData name:fileName fileName:fileName mimeType:@"image/jpeg"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                NSLog(@"uploadProgress.fractionCompleted = %f",uploadProgress.fractionCompleted);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"response = %@",response);
                if ([response isEqualToString:@"1"]) {
                    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    hud.customView = imageView;
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.label.text = NSLocalizedString(@"上传成功", @"HUD completed title");
                    hud.label.font = font(14);
                    [hud hideAnimated:YES afterDelay:1.5f];
                    [hud removeFromSuperViewOnHide];
                }else {
                    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                    UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    hud.customView = imageView;
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.label.text = NSLocalizedString(@"上传失败", @"HUD completed title");
                    hud.label.font = font(14);
                    [hud hideAnimated:YES afterDelay:1.5f];
                    [hud removeFromSuperViewOnHide];
                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"上传失败", @"HUD completed title");
                hud.label.font = font(14);
                [hud hideAnimated:YES afterDelay:1.5f];
                [hud removeFromSuperViewOnHide];
                NSLog(@"error.userInfo = %@",error.userInfo);
            }];
    
        }
        if ([picker isEqual:self.pickerController2]) {
            self.imageView2.image = qrImage;
            NSData *qrData = UIImagePNGRepresentation(qrImage);
            UserModel *userModel = [UserModel readUserModel];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 15;
            NSString *url = [NSString stringWithFormat:@"%@uploadFile.ashx?action=uploadimages",HomeURL];
            
            NSDictionary *params = @{@"userId":@(userModel.uid)};
            [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString *fileName = [NSString stringWithFormat:@"%@AL.jpeg",[formatter stringFromDate:date]];
                
                [formData appendPartWithFileData:qrData name:fileName fileName:fileName mimeType:@"image/jpeg"];
                
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if ([response isEqualToString:@"1"]) {
                    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    hud.customView = imageView;
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.label.text = NSLocalizedString(@"上传成功", @"HUD completed title");
                    hud.label.font = font(14);
                    [hud hideAnimated:YES afterDelay:1.5f];
                    [hud removeFromSuperViewOnHide];
                }else {
                    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                    UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    hud.customView = imageView;
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.label.text = NSLocalizedString(@"上传失败", @"HUD completed title");
                    hud.label.font = font(14);
                    [hud hideAnimated:YES afterDelay:1.5f];
                    [hud removeFromSuperViewOnHide];
                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"上传失败", @"HUD completed title");
                hud.label.font = font(14);
                [hud hideAnimated:YES afterDelay:1.5f];
                [hud removeFromSuperViewOnHide];
                NSLog(@"error.userInfo = %@",error.userInfo);
            }];
        }
    }else {
        
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = NSLocalizedString(@"原图上传", @"HUD completed title");
        hud.label.font = font(14);

        if ([picker isEqual:self.pickerController1]) {
            self.imageView1.image = image;
            
            UserModel *userModel = [UserModel readUserModel];
            
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 15;
            NSString *url = [NSString stringWithFormat:@"%@uploadFile.ashx?action=uploadimages",HomeURL];
            NSDictionary *params = @{@"userId":@(userModel.uid)};
            [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString *fileName = [NSString stringWithFormat:@"%@WX.jpeg",[formatter stringFromDate:date]];
                
                [formData appendPartWithFileData:data name:fileName fileName:fileName mimeType:@"image/jpeg"];
                
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if ([response isEqualToString:@"1"]) {
                    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    hud.customView = imageView;
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.label.text = NSLocalizedString(@"上传成功", @"HUD completed title");
                    hud.label.font = font(14);
                    [hud hideAnimated:YES afterDelay:1.5f];
                    [hud removeFromSuperViewOnHide];
                }else {
                    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                    UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    hud.customView = imageView;
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.label.text = NSLocalizedString(@"上传失败", @"HUD completed title");
                    hud.label.font = font(14);
                    [hud hideAnimated:YES afterDelay:1.5f];
                    [hud removeFromSuperViewOnHide];
                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"上传失败", @"HUD completed title");
                hud.label.font = font(14);
                [hud hideAnimated:YES afterDelay:1.5f];
                [hud removeFromSuperViewOnHide];
                NSLog(@"error.userInfo = %@",error.userInfo);
            }];
        }
        if ([picker isEqual:self.pickerController2]) {
            self.imageView2.image = image;
            
            UserModel *userModel = [UserModel readUserModel];
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 15;
            NSString *url = [NSString stringWithFormat:@"%@uploadFile.ashx?action=uploadimages",HomeURL];
            NSDictionary *params = @{@"userId":@(userModel.uid)};
            [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString *fileName = [NSString stringWithFormat:@"%@AL.jpeg",[formatter stringFromDate:date]];
                
                [formData appendPartWithFileData:data name:fileName fileName:fileName mimeType:@"image/jpeg"];
                
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if ([response isEqualToString:@"1"]) {
                    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    hud.customView = imageView;
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.label.text = NSLocalizedString(@"上传成功", @"HUD completed title");
                    hud.label.font = font(14);
                    [hud hideAnimated:YES afterDelay:1.5f];
                    [hud removeFromSuperViewOnHide];
                }else {
                    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                    UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    hud.customView = imageView;
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.label.text = NSLocalizedString(@"上传失败", @"HUD completed title");
                    hud.label.font = font(14);
                    [hud hideAnimated:YES afterDelay:1.5f];
                    [hud removeFromSuperViewOnHide];
                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
                UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                hud.customView = imageView;
                hud.mode = MBProgressHUDModeCustomView;
                hud.label.text = NSLocalizedString(@"上传失败", @"HUD completed title");
                hud.label.font = font(14);
                [hud hideAnimated:YES afterDelay:1.5f];
                [hud removeFromSuperViewOnHide];
                NSLog(@"error.userInfo = %@",error.userInfo);
            }];
        }
    }

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)detectQRCodeWithImage:(UIImage *)QRCodeImage {
    //通过type和options创建CIDetector的对象
    CIDetector *detector = [CIDetector
                            detectorOfType:CIDetectorTypeQRCode
                            context:nil
                            options:@{
                                      CIDetectorAccuracy:CIDetectorAccuracyLow
                                      }];
                            
    CIImage *image = [CIImage imageWithCGImage:QRCodeImage.CGImage];
    NSArray *features = [detector featuresInImage:image];
    
    return features;
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = scale * CGRectGetWidth(extent);
    size_t height = scale * CGRectGetHeight(extent);
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviTitle];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
   
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
    
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pageControl setCurrentPage:roundf(scrollView.contentOffset.x/self.view.bounds.size.width)];
    if (roundf(scrollView.contentOffset.x/self.view.bounds.size.width) == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.backgroundColor = WXGreenColor;
        }];
    }
    
    if (roundf(scrollView.contentOffset.x/self.view.bounds.size.width) == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.backgroundColor = ALiBlueColor;
        }];
    }
}

- (void)setNaviTitle {
    self.navigationItem.title = @"我要收款";
}

@end
