//
//  ChangeImageViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/7/28.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "ChangeImageViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UserModel.h"
#import "ZDDPhotoBrowerViewController.h"

@interface ChangeImageViewController ()
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *firstImageView1;
@property (nonatomic, strong) UIImageView *secondImageView1;
@property (nonatomic, strong) UIImageView *thirdImageView1;

@property (nonatomic, strong) UIImageView *firstMaskView1;
@property (nonatomic, strong) UIImageView *secondMaskView1;
@property (nonatomic, strong) UIImageView *thirdMaskView1;

@property (nonatomic, strong) UIImageView *firstImageView2;
@property (nonatomic, strong) UIImageView *secondImageView2;
@property (nonatomic, strong) UIImageView *thirdImageView2;

@property (nonatomic, strong) UIImageView *firstMaskView2;
@property (nonatomic, strong) UIImageView *secondMaskView2;
@property (nonatomic, strong) UIImageView *thirdMaskView2;

@property (nonatomic, strong) UIImageView *firstImageView3;
@property (nonatomic, strong) UIImageView *secondImageView3;
@property (nonatomic, strong) UIImageView *thirdImageView3;

@property (nonatomic, strong) UIImageView *firstMaskView3;
@property (nonatomic, strong) UIImageView *secondMaskView3;
@property (nonatomic, strong) UIImageView *thirdMaskView3;

@property (nonatomic, assign) NSInteger selectedBtnposition;


@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;
@property (nonatomic, strong) UIButton *button6;
@property (nonatomic, strong) UIButton *button7;
@property (nonatomic, strong) UIButton *button8;
@property (nonatomic, strong) UIButton *button9;
@end

@implementation ChangeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setNaviTitle];
    [self setSubmitButton];
    [self setBackgroundView];
    
}

- (void)setBackgroundView{
    self.view.backgroundColor = color(241, 241, 241, 1);
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, (Height - StatusBarAndNavigationBarHeight)*10/12)];
    self.containerView.backgroundColor = color(241, 241, 241, 1);
    [self.view addSubview:self.containerView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, Width/4, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
    label.text = @"现场拍照";
    CGFloat fontsize;
    if (iPhone6_plus || iPhone6) {
        fontsize = 16;
    }else{
        fontsize = 14;
    }
    label.font = [UIFont systemFontOfSize:fontsize];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor blackColor];
    [self.containerView addSubview:label];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(Width*3/4 - 5, 5, Width/4, (Height - StatusBarAndNavigationBarHeight)/12 - 10);
    [button setTitle:@"已上传图片" forState:UIControlStateNormal];
    [button setBackgroundColor:MainBlueColor];
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(displayPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = font(fontsize);
    [self.containerView addSubview:button];
    
    if (!self.isDisplay) {
        [button removeFromSuperview];
    }
    
    
    {
        UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(20, (Height - StatusBarAndNavigationBarHeight)/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
        firstView.backgroundColor = color(230, 230, 230, 1);
        
        UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
        secondView.backgroundColor = color(230, 230, 230, 1);
        UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
        thirdView.backgroundColor = color(230, 230, 230, 1);
        
        [self.containerView addSubview:firstView];
        [self.containerView addSubview:secondView];
        [self.containerView addSubview:thirdView];
    }
    {
        UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(20 + (Width - 120)/6 - 1, (Height - StatusBarAndNavigationBarHeight)/12 + 20, 1, 4*(Width - 120)/9 - 20)];
        firstLineView.backgroundColor = [UIColor whiteColor];
        UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(25, (Height - StatusBarAndNavigationBarHeight)/12 + 10 + 2*(Width - 120)/9 - 1, (Width - 120)/3 - 10, 1)];
        secondLineView.backgroundColor = [UIColor whiteColor];
        
        [self.containerView addSubview:firstLineView];
        [self.containerView addSubview:secondLineView];
    }
    
    {
        UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3 + (Width - 120)/6 - 1, (Height - StatusBarAndNavigationBarHeight)/12 + 20, 1, 4*(Width - 120)/9 - 20)];
        firstLineView.backgroundColor = [UIColor whiteColor];
        UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(65 + (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)/12 + 10 + 2*(Width - 120)/9 - 1, (Width - 120)/3 - 10, 1)];
        secondLineView.backgroundColor = [UIColor whiteColor];
        
        [self.containerView addSubview:firstLineView];
        [self.containerView addSubview:secondLineView];
        
    }
    
    {
        UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3 + (Width - 120)/6 - 1, (Height - StatusBarAndNavigationBarHeight)/12 + 20, 1, 4*(Width - 120)/9 - 20)];
        firstLineView.backgroundColor = [UIColor whiteColor];
        UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(Width - 15 - (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)/12 + 10 + 2*(Width - 120)/9 - 1, (Width - 120)/3 - 10, 1)];
        secondLineView.backgroundColor = [UIColor whiteColor];
        
        [self.containerView addSubview:firstLineView];
        [self.containerView addSubview:secondLineView];
        
    }
        
    self.firstImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, (Height - StatusBarAndNavigationBarHeight)/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
    self.firstImageView1.tag = 2001;
    self.secondImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
    self.secondImageView1.tag = 2002;
    self.thirdImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
    self.thirdImageView1.tag = 2003;
    self.firstImageView1.userInteractionEnabled = YES;
    self.secondImageView1.userInteractionEnabled = YES;
    self.thirdImageView1.userInteractionEnabled = YES;
    [self.containerView addSubview:self.firstImageView1];
    [self.containerView addSubview:self.secondImageView1];
    [self.containerView addSubview:self.thirdImageView1];
        
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.button1.backgroundColor = [UIColor clearColor];
    self.button1.frame = CGRectMake(20, (Height - StatusBarAndNavigationBarHeight)/12 + 10, (Width - 120)/3, 4*(Width - 120)/9);
    [self.containerView addSubview:self.button1];
    
    self.button1.tag = 4001;
    [self.button1 addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button2.backgroundColor = [UIColor clearColor];
    self.button2.frame = CGRectMake(60 + (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)/12 + 10, (Width - 120)/3, 4*(Width - 120)/9);
    [self.containerView addSubview:self.button2];
    
    self.button2.tag = 4002;
    [self.button2 addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button3.backgroundColor = [UIColor clearColor];
    self.button3.frame = CGRectMake(Width - 20 - (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)/12 + 10, (Width - 120)/3, 4*(Width - 120)/9);
    [self.containerView addSubview:self.button3];
    
    self.button3.tag = 4003;
    [self.button3 addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
        
    self.firstMaskView1 = [[UIImageView alloc] init];
    self.firstMaskView1.frame = self.button1.bounds;
    self.firstMaskView1.backgroundColor = color(241, 241, 241, 1);
    [self.button1 addSubview:self.firstMaskView1];
    self.firstMaskView1.tag = 8001;
    self.secondMaskView1 = [[UIImageView alloc] init];
    self.secondMaskView1.frame = self.button2.bounds;
    self.secondMaskView1.backgroundColor = color(241, 241, 241, 1);
    [self.button2 addSubview:self.secondMaskView1];
    self.secondMaskView1.tag = 8002;
    self.thirdMaskView1 = [[UIImageView alloc] init];
    self.thirdMaskView1.frame = self.button3.bounds;
    self.thirdMaskView1.backgroundColor = color(241, 241, 241, 1);
    [self.button3 addSubview:self.thirdMaskView1];
    self.thirdMaskView1.tag = 8003;
        
    {
        UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(20, (Height - StatusBarAndNavigationBarHeight)*4/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
        firstView.backgroundColor = color(230, 230, 230, 1);
        
        UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*4/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
        secondView.backgroundColor = color(230, 230, 230, 1);
        UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*4/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
        thirdView.backgroundColor = color(230, 230, 230, 1);
        
        [self.containerView addSubview:firstView];
        [self.containerView addSubview:secondView];
        [self.containerView addSubview:thirdView];
    }
    {
        UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(20 + (Width - 120)/6 - 1, (Height - StatusBarAndNavigationBarHeight)*4/12 + 20, 1, 4*(Width - 120)/9 - 20)];
        firstLineView.backgroundColor = [UIColor whiteColor];
        UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(25, (Height - StatusBarAndNavigationBarHeight)*4/12 + 10 + 2*(Width - 120)/9 - 1, (Width - 120)/3 - 10, 1)];
        secondLineView.backgroundColor = [UIColor whiteColor];
        
        [self.containerView addSubview:firstLineView];
        [self.containerView addSubview:secondLineView];
    }
        
    {
        UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3 + (Width - 120)/6 - 1, (Height - StatusBarAndNavigationBarHeight)*4/12 + 20, 1, 4*(Width - 120)/9 - 20)];
        firstLineView.backgroundColor = [UIColor whiteColor];
        UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(65 + (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*4/12 + 10 + 2*(Width - 120)/9 - 1, (Width - 120)/3 - 10, 1)];
        secondLineView.backgroundColor = [UIColor whiteColor];
        
        [self.containerView addSubview:firstLineView];
        [self.containerView addSubview:secondLineView];
        
    }
        
    {
        UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3 + (Width - 120)/6 - 1, (Height - StatusBarAndNavigationBarHeight)*4/12 + 20, 1, 4*(Width - 120)/9 - 20)];
        firstLineView.backgroundColor = [UIColor whiteColor];
        UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(Width - 15 - (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*4/12 + 10 + 2*(Width - 120)/9 - 1, (Width - 120)/3 - 10, 1)];
        secondLineView.backgroundColor = [UIColor whiteColor];
        
        [self.containerView addSubview:firstLineView];
        [self.containerView addSubview:secondLineView];
        
    }
        
    self.firstImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, (Height - StatusBarAndNavigationBarHeight)*4/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
    self.secondImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*4/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
    self.thirdImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*4/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
    self.firstImageView2.tag = 2004;
    self.secondImageView2.tag = 2005;
    self.thirdImageView2.tag = 2006;
    
    self.firstImageView2.userInteractionEnabled = YES;
    self.secondImageView2.userInteractionEnabled = YES;
    self.thirdImageView2.userInteractionEnabled = YES;
    
    [self.containerView addSubview:self.firstImageView2];
    [self.containerView addSubview:self.secondImageView2];
    [self.containerView addSubview:self.thirdImageView2];
    
    self.button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.button4.backgroundColor = [UIColor clearColor];
    self.button4.frame = CGRectMake(20, (Height - StatusBarAndNavigationBarHeight)*4/12 + 10, (Width - 120)/3, 4*(Width - 120)/9);
    [self.containerView addSubview:self.button4];
    self.button4.tag = 4004;
    [self.button4 addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
    self.button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button5.backgroundColor = [UIColor clearColor];
    self.button5.frame = CGRectMake(60 + (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*4/12 + 10, (Width - 120)/3, 4*(Width - 120)/9);
    [self.containerView addSubview:self.button5];
    self.button5.tag = 4005;
    [self.button5 addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button6 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button6.backgroundColor = [UIColor clearColor];
    self.button6.frame = CGRectMake(Width - 20 - (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*4/12 + 10, (Width - 120)/3, 4*(Width - 120)/9);
    [self.containerView addSubview:self.button6];
    self.button6.tag = 4006;
    [self.button6 addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.firstMaskView2 = [[UIImageView alloc] init];
    self.firstMaskView2.frame = self.button4.bounds;
    self.firstMaskView2.backgroundColor = color(241, 241, 241, 1);
    [self.button4 addSubview:self.firstMaskView2];
    self.firstMaskView2.tag = 8004;
    self.secondMaskView2 = [[UIImageView alloc] init];
    self.secondMaskView2.frame = self.button5.bounds;
    self.secondMaskView2.backgroundColor = color(241, 241, 241, 1);
    [self.button5 addSubview:self.secondMaskView2];
    self.secondMaskView2.tag = 8005;
    self.thirdMaskView2 = [[UIImageView alloc] init];
    self.thirdMaskView2.frame = self.button6.bounds;
    self.thirdMaskView2.backgroundColor = color(241, 241, 241, 1);
    [self.button6 addSubview:self.thirdMaskView2];
    self.thirdMaskView2.tag = 8006;
        
        
    {
        UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(20, (Height - StatusBarAndNavigationBarHeight)*7/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
        firstView.backgroundColor = color(230, 230, 230, 1);
        
        UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*7/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
        secondView.backgroundColor = color(230, 230, 230, 1);
        UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*7/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
        thirdView.backgroundColor = color(230, 230, 230, 1);
        
        [self.containerView addSubview:firstView];
        [self.containerView addSubview:secondView];
        [self.containerView addSubview:thirdView];
    }
    {
        UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(20 + (Width - 120)/6 - 1, (Height - StatusBarAndNavigationBarHeight)*7/12 + 20, 1, 4*(Width - 120)/9 - 20)];
        firstLineView.backgroundColor = [UIColor whiteColor];
        UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(25, (Height - StatusBarAndNavigationBarHeight)*7/12 + 10 + 2*(Width - 120)/9 - 1, (Width - 120)/3 - 10, 1)];
        secondLineView.backgroundColor = [UIColor whiteColor];
        
        [self.containerView addSubview:firstLineView];
        [self.containerView addSubview:secondLineView];
    }
        
    {
        UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3 + (Width - 120)/6 - 1, (Height - StatusBarAndNavigationBarHeight)*7/12 + 20, 1, 4*(Width - 120)/9 - 20)];
        firstLineView.backgroundColor = [UIColor whiteColor];
        UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(65 + (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*7/12 + 10 + 2*(Width - 120)/9 - 1, (Width - 120)/3 - 10, 1)];
        secondLineView.backgroundColor = [UIColor whiteColor];
        
        [self.containerView addSubview:firstLineView];
        [self.containerView addSubview:secondLineView];
        
    }
        
    {
        UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3 + (Width - 120)/6 - 1, (Height - StatusBarAndNavigationBarHeight)*7/12 + 20, 1, 4*(Width - 120)/9 - 20)];
        firstLineView.backgroundColor = [UIColor whiteColor];
        UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(Width - 15 - (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*7/12 + 10 + 2*(Width - 120)/9 - 1, (Width - 120)/3 - 10, 1)];
        secondLineView.backgroundColor = [UIColor whiteColor];
        
        [self.containerView addSubview:firstLineView];
        [self.containerView addSubview:secondLineView];
        
    }
        
    self.firstImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, (Height - StatusBarAndNavigationBarHeight)*7/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
    self.secondImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*7/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
    self.thirdImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*7/12 + 10, (Width - 120)/3, 4*(Width - 120)/9)];
    
    self.firstImageView3.tag = 2007;
    self.secondImageView3.tag = 2008;
    self.thirdImageView3.tag = 2009;
    
    self.firstImageView3.userInteractionEnabled = YES;
    self.secondImageView3.userInteractionEnabled = YES;
    self.thirdImageView3.userInteractionEnabled = YES;
    
    [self.containerView addSubview:self.firstImageView3];
    [self.containerView addSubview:self.secondImageView3];
    [self.containerView addSubview:self.thirdImageView3];
    
    self.button7 = [UIButton buttonWithType:UIButtonTypeCustom];
        
    self.button7.backgroundColor = [UIColor clearColor];
    self.button7.frame = CGRectMake(20, (Height - StatusBarAndNavigationBarHeight)*7/12 + 10, (Width - 120)/3, 4*(Width - 120)/9);
    [self.containerView addSubview:self.button7];
    self.button7.tag = 4007;
    [self.button7 addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
    self.button8 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button8.backgroundColor = [UIColor clearColor];
    self.button8.frame = CGRectMake(60 + (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*7/12 + 10, (Width - 120)/3, 4*(Width - 120)/9);
    [self.containerView addSubview:self.button8];
    self.button8.tag = 4008;
    [self.button8 addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button9 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button9.backgroundColor = [UIColor clearColor];
    self.button9.frame = CGRectMake(Width - 20 - (Width - 120)/3, (Height - StatusBarAndNavigationBarHeight)*7/12 + 10, (Width - 120)/3, 4*(Width - 120)/9);
    [self.containerView addSubview:self.button9];
    self.button9.tag = 4009;
    [self.button9 addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.firstMaskView3 = [[UIImageView alloc] init];
    self.firstMaskView3.frame = self.button7.bounds;
    self.firstMaskView3.backgroundColor = color(241, 241, 241, 1);
    [self.button7 addSubview:self.firstMaskView3];
    self.firstMaskView3.tag = 8007;
    self.secondMaskView3 = [[UIImageView alloc] init];
    self.secondMaskView3.frame = self.button8.bounds;
    self.secondMaskView3.backgroundColor = color(241, 241, 241, 1);
    [self.button8 addSubview:self.secondMaskView3];
    self.secondMaskView3.tag = 8008;
    self.thirdMaskView3 = [[UIImageView alloc] init];
    self.thirdMaskView3.frame = self.button9.bounds;
    self.thirdMaskView3.backgroundColor = color(241, 241, 241, 1);
    [self.button9 addSubview:self.thirdMaskView3];
    self.thirdMaskView3.tag = 8009;
        
    
    
    for (NSInteger i = 1; i <= self.count; i++) {
        UIImageView *imageView = [self.containerView viewWithTag:2000 + i];
        NSString *urlString = [NSString stringWithFormat:@"%@upload/voucher/finish/%@",subHomeURL, self.array[i - 1]];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        imageView.image = [UIImage imageWithData:data];
    }
    
    
    for (NSInteger i = 1; i <= self.count + 1; i++) {
        if (i == 10) {
            break;
        }
        UIImageView *maskView = [self.containerView viewWithTag:8000 + i];
        [maskView removeFromSuperview];
        
    }
    
    for (NSInteger i = 1; i <= self.count; i++) {
        UIButton *button = [self.containerView viewWithTag:4000 + i];
        button.enabled = NO;
    }
    
    for (NSInteger i = self.count + 2; i < 10; i++) {
        UIButton *button = [self.containerView viewWithTag:4000 + i];
        button.enabled = NO;
    }
    
    
}

- (void)displayPhotoButtonClick {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSMutableArray *list = [NSMutableArray array];
    
    for (NSString *url in self.array) {
            NSString *urlString = [NSString stringWithFormat:@"%@upload/voucher/finish/%@",subHomeURL,url];
        
            [list addObject:urlString];
        
    }
    
    [hud hideAnimated:YES];
    NSLog(@"%@",list);
    ZDDPhotoBrowerViewController *photoVC = [[ZDDPhotoBrowerViewController alloc] init];
    photoVC.photoList = list;
    [self.navigationController pushViewController:photoVC animated:YES];
    
}


- (void)pictureAction:(UIButton *)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AVCan"];
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
        
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        imagePickerController.navigationBar.barStyle = UIBarStyleBlack;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
        
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:albumAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    self.selectedBtnposition = sender.tag - 4000;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    if (self.selectedBtnposition <= self.count) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else {
        
        UIImageView *maskView;
        if (self.count == 0) {
            maskView = self.secondMaskView1;
            self.button2.enabled = YES;
        }else if (self.count == 1) {
            maskView = self.thirdMaskView1;
            self.button3.enabled = YES;
        }else if (self.count == 2) {
            maskView = self.firstMaskView2;
            self.button4.enabled = YES;
        }else if (self.count == 3) {
            maskView = self.secondMaskView2;
            self.button5.enabled = YES;
        }else if (self.count == 4) {
            maskView = self.thirdMaskView2;
            self.button6.enabled = YES;
        }else if (self.count == 5) {
            maskView = self.firstMaskView3;
            self.button7.enabled = YES;
        }else if (self.count == 6) {
            maskView = self.secondMaskView3;
            self.button8.enabled = YES;
        }else if (self.count == 7) {
            maskView = self.thirdMaskView3;
            self.button9.enabled = YES;
        }
        
        [maskView removeFromSuperview];
        self.count++;
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
    
    if (self.selectedBtnposition == 1) {
        self.firstImageView1.image = image;
    }
    if (self.selectedBtnposition == 2) {
        self.secondImageView1.image = image;
    }
    if (self.selectedBtnposition == 3) {
        self.thirdImageView1.image = image;
    }
    if (self.selectedBtnposition == 4) {
        self.firstImageView2.image = image;
    }
    if (self.selectedBtnposition == 5) {
        self.secondImageView2.image = image;
    }
    if (self.selectedBtnposition == 6) {
        self.thirdImageView2.image = image;
    }
    if (self.selectedBtnposition == 7) {
        self.firstImageView3.image = image;
    }
    if (self.selectedBtnposition == 8) {
        self.secondImageView3.image = image;
    }
    if (self.selectedBtnposition == 9) {
        self.thirdImageView3.image = image;
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)setSubmitButton {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Height - StatusBarAndNavigationBarHeight - TabbarHeight, Width, TabbarHeight)];
    view.backgroundColor = color(180, 180, 180, 1);
    [self.view addSubview:view];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    effectView.frame = view.bounds;
    [view addSubview:effectView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.6)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [effectView.contentView addSubview:lineView];
    
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"确认添加" forState:UIControlStateNormal];
    
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitClicked:) forControlEvents:UIControlEventTouchUpInside];
    submit.backgroundColor = MainBlueColor;
    submit.frame = CGRectMake(0, 0, Width, TabbarHeight);
    
    [effectView.contentView addSubview:submit];
    
}

- (void)submitClicked:(UIButton *)sender {
    
    if (!self.firstImageView1.image) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请至少选择一张图片";
        hud.label.font = font(14);
        [hud hideAnimated:YES afterDelay:1.f];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.minSize = CGSizeMake(100, 100);
    hud.label.text = @"上传中...";
    hud.label.font = font(14);
    NSMutableArray *dataList = [NSMutableArray array];
    NSInteger count = 0;
    
    for (NSInteger i = self.uploadCount + 1; i <= 9; i++) {
        UIImageView *imageView = [self.containerView viewWithTag:2000+i];
        
        if (imageView.image) {
            NSData *data = UIImageJPEGRepresentation(imageView.image, 0.1);
            count++;
            [dataList addObject:data];
        }else {
            break;
        }
    }
    

    NSMutableArray *fileNameList = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        [fileNameList addObject:[NSString stringWithFormat:@"profile_picture%@.jpeg",@(i+1)]];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    UserModel *userModel = [UserModel readUserModel];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    
    NSString *url = [NSString stringWithFormat:@"%@task.ashx?action=uploadtaskfile",HomeURL];
    NSDictionary *params = @{
                             @"taskid":self.taskID,
                             @"comid":@(userModel.comid)
                             };

    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSInteger i = 0; i < count; i ++) {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.jpeg",[formatter stringFromDate:date],(long)i];

            [formData appendPartWithFileData:dataList[i] name:fileNameList[i] fileName:fileName mimeType:@"image/jpeg"];
            
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"上传成功", @"HUD completed title");
        hud.label.font = font(14);
        [hud hideAnimated:YES afterDelay:1.5f];
        [hud removeFromSuperViewOnHide];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
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
    }];
    
}


- (void)setNaviTitle {
    self.navigationItem.title = @"添加图片";
}

@end
