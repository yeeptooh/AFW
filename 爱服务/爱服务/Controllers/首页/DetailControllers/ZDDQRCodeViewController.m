//
//  ZDDQRCodeViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/7/8.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "ZDDQRCodeViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"
@interface ZDDQRCodeViewController ()
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;

@end

@implementation ZDDQRCodeViewController


- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), Width, 50)];
        _label1.text = @"点击二维码,保存到相册";
        _label1.font = [UIFont fontWithName:@"FZSongKeBenXiuKaiS-R-GB" size:16];
        _label1.textAlignment = NSTextAlignmentCenter;
    }
    return _label1;
}

- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.label1.frame), Width, 50)];
        _label2.text = @"使用微信扫一扫,更多惊喜等待您";
        _label2.font = [UIFont fontWithName:@"FZSongKeBenXiuKaiS-R-GB" size:16];
        _label2.textAlignment = NSTextAlignmentCenter;
    }
    return _label2;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width *3/5, Width *3/5)];
        
        _imageView.userInteractionEnabled = YES;
        _imageView.center = CGPointMake(Width/2, (Height - StatusBarAndNavigationBarHeight)/3);
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNaviTitle];
    self.definesPresentationContext = YES;
    [self.view addSubview:self.imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.imageView.bounds;
    button.backgroundColor = [UIColor clearColor];
    [self.imageView addSubview:button];
    
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successNotificationReceived:) name:@"success" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorNotificationReceived:) name:@"error" object:nil];
    
    
}

- (void)buttonClicked:(UIButton *)sender {
    
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
               
                [[NSNotificationCenter defaultCenter] postNotificationName:@"success" object:nil];
            }
            
            if (error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"error" object:nil];
            }
            
        }];
    
}


- (void)successNotificationReceived:(NSNotification *)noti {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.minSize = CGSizeMake(100, 100);
        hud.label.font = font(14);
        hud.label.text = NSLocalizedString(@"保存成功", @"HUD completed title");
        [hud hideAnimated:YES afterDelay:1.25f];
    });
    

}

- (void)errorNotificationReceived:(NSNotification *)noti {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        UIImage *image = [[UIImage imageNamed:@"Checkerror"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.minSize = CGSizeMake(100, 100);
        hud.label.font = font(14);
        hud.label.text = NSLocalizedString(@"保存失败", @"HUD completed title");
        [hud hideAnimated:YES afterDelay:1.25f];
    });
 
}


- (void)setNaviTitle {
    self.navigationItem.title = @"二维码";
}

@end
