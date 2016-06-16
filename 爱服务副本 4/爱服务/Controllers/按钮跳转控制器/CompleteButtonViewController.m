//
//  completeButtonViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/18.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "completeButtonViewController.h"
#import "DatePickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BarCodeViewController.h"
#import "AFNetworking.h"
#import "UserModel.h"
#import "MBProgressHUD.h"
@interface CompleteButtonViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
AVCaptureMetadataOutputObjectsDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) BarCodeViewController *barVC;

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;

@property (nonatomic, assign) NSInteger selectedBtnposition;

@property (nonatomic, strong) NSData *imageData1;
@property (nonatomic, strong) NSData *imageData2;
@property (nonatomic, strong) NSData *imageData3;

@end
static NSInteger number;
@implementation CompleteButtonViewController

- (BarCodeViewController *)barVC {
    if (!_barVC) {
        _barVC = [[BarCodeViewController alloc]init];
    }
    return _barVC;
}

- (AVCaptureDevice *)device {
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)input {
    if (!_input) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}

- (AVCaptureMetadataOutput *)output {
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_output setRectOfInterest:[self rectOfInterestByScanViewRect:CGRectMake(40, 150, Width - 80, Width - 80)]];
    }
    return _output;
}

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        [_session addInput:self.input];
        [_session addOutput:self.output];
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _previewLayer;
}

- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.barVC.bgView.frame);
    CGFloat height = CGRectGetHeight(self.barVC.bgView.frame);
    
    CGFloat x = (height - CGRectGetHeight(rect)) / 2 / height;
    CGFloat y = (width - CGRectGetWidth(rect)) / 2 / width;
    
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
    
    return CGRectMake(x, y, w, h);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviTitle];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = color(241, 241, 241, 1);
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, (Height - StatusBarAndNavigationBarHeight)*10/12) style:UITableViewStylePlain];
    self.tableView.backgroundColor = color(241, 241, 241, 1);
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    [self addKeyBoardNotification];
    [self configPreviewLayer];
    [self setSubmitButton];
}

- (void)setSubmitButton {
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    
    [submit setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    submit.backgroundColor = color(23, 133, 255, 1);
    submit.frame = CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*11/12, Width, (Height - StatusBarAndNavigationBarHeight)/12);
    [self.view addSubview:submit];

}

- (void)configPreviewLayer {
    self.previewLayer.frame = self.barVC.bgView.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.barVC.bgView.layer addSublayer:self.previewLayer];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, Height)];
    leftView.backgroundColor = [UIColor blackColor];
    leftView.alpha = 0.5;
    [self.barVC.bgView addSubview:leftView];
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(Width - 40, 0, 40, Height)];
    rightView.backgroundColor = [UIColor blackColor];
    rightView.alpha = 0.5;
    [self.barVC.bgView addSubview:rightView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(40, 0, Width - 80, 150)];
    topView.backgroundColor = [UIColor blackColor];
    topView.alpha = 0.5;
    [self.barVC.bgView addSubview:topView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(40, 150 +(Width - 80), Width - 80, Height- 150 - Width + 80)];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.5;
    [self.barVC.bgView addSubview:bottomView];
    
    
    
    UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(41, 151, 1, Width - 82)];
    UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(Width - 41, 151, 1, Width - 82)];
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(41, 151, Width - 82, 1)];
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(41, 150 +(Width - 80) - 1, Width - 82, 1 )];
    
    leftLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    rightLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    topLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    bottomLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    
    UIView *leftTopLine1 = [[UIView alloc]initWithFrame:CGRectMake(42, 152, 20, 2)];
    UIView *leftTopLine2 = [[UIView alloc]initWithFrame:CGRectMake(42, 152, 2, 20)];
    
    leftTopLine1.backgroundColor = color(53, 175, 255, 1);
    leftTopLine2.backgroundColor = color(53, 175, 255, 1);
    
    UIView *rightTopLine1 = [[UIView alloc]initWithFrame:CGRectMake(Width - 61, 152, 20, 2)];
    UIView *rightTopLine2 = [[UIView alloc]initWithFrame:CGRectMake(Width - 43, 152, 2, 20)];
    
    rightTopLine1.backgroundColor = color(53, 175, 255, 1);
    rightTopLine2.backgroundColor = color(53, 175, 255, 1);
    
    UIView *leftBottomLine1 = [[UIView alloc]initWithFrame:CGRectMake(42, 150 +(Width - 80) - 3, 20, 2)];
    UIView *leftBottomLine2 = [[UIView alloc]initWithFrame:CGRectMake(42, 150 +(Width - 80) - 21, 2, 20)];
    
    leftBottomLine1.backgroundColor = color(53, 175, 255, 1);
    leftBottomLine2.backgroundColor = color(53, 175, 255, 1);
    
    UIView *rightBottomLine1 = [[UIView alloc]initWithFrame:CGRectMake(Width - 61, 150 +(Width - 80) - 3, 20, 2)];
    UIView *rightBottomLine2 = [[UIView alloc]initWithFrame:CGRectMake(Width - 43, 150 +(Width - 80) - 21, 2, 20)];
    
    rightBottomLine1.backgroundColor = color(53, 175, 255, 1);
    rightBottomLine2.backgroundColor = color(53, 175, 255, 1);
    
    [self.barVC.bgView addSubview:leftTopLine1];
    [self.barVC.bgView addSubview:leftTopLine2];
    [self.barVC.bgView addSubview:rightTopLine1];
    [self.barVC.bgView addSubview:rightTopLine2];
    [self.barVC.bgView addSubview:leftBottomLine1];
    [self.barVC.bgView addSubview:leftBottomLine2];
    [self.barVC.bgView addSubview:rightBottomLine1];
    [self.barVC.bgView addSubview:rightBottomLine2];
    
    [self.barVC.bgView addSubview:leftLine];
    [self.barVC.bgView addSubview:rightLine];
    [self.barVC.bgView addSubview:topLine];
    [self.barVC.bgView addSubview:bottomLine];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, bottomView.bounds.size.width, 50)];
    label.text = @"将条形码放入框内，即可自动扫描";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = color(53, 175, 255, 1);
    label.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:label];
    
    
    //接受类型写在输出添加到会话之后，不然崩溃
    [self.output setMetadataObjectTypes:@[
                                          AVMetadataObjectTypeEAN13Code,
                                          AVMetadataObjectTypeEAN8Code,
                                          AVMetadataObjectTypeCode128Code,
                                          AVMetadataObjectTypeCode39Code,
                                          AVMetadataObjectTypeCode93Code
                                          ]];
}

- (void)keyBoardWillShow {
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    self.tap.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:self.tap];
}

- (void)keyBoardWillHide {
    [self.tableView removeGestureRecognizer:self.tap];
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
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CompleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSArray *labelList = @[
                           @"完成时间",
                           @"产品条码",
                           @"故障原因",
                           @"配件更换",
                           @"备注内容",
                           @"验证码",
                           @"现场拍照",
                           @"",
                           
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
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dateButton.tag = 500;
        dateButton.backgroundColor = [UIColor whiteColor];
        [dateButton setTitle:dateString forState:UIControlStateNormal];
        [dateButton setTitleColor:color(51, 102, 255, 1) forState:UIControlStateNormal];
        dateButton.frame = CGRectMake(Width*5/16, 5, Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10);
        [dateButton addTarget:self action:@selector(dateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        dateButton.titleLabel.font = font(fontsize);
        dateButton.layer.cornerRadius = 5;
        dateButton.layer.masksToBounds = YES;
        [cell addSubview:dateButton];
    }else if (indexPath.row == 1) {
    
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(Width*5/16, 5, Width*7/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
        
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.font = font(fontsize);
        textfield.layer.cornerRadius = 5;
        textfield.layer.masksToBounds = YES;
        
        textfield.tag = 1000 + indexPath.row;
        [cell addSubview:textfield];
        
        UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [barButton setTitle:@"扫码" forState:UIControlStateNormal];
        
        [barButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
        [barButton addTarget:self action:@selector(barButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        barButton.layer.cornerRadius = 5;
        barButton.layer.masksToBounds = YES;
        barButton.titleLabel.font = font(fontsize);
        barButton.backgroundColor = color(23, 133, 255, 1);
        barButton.frame = CGRectMake(Width * 13 / 16, 5, Width *2 / 16, (Height - StatusBarAndNavigationBarHeight)/12 - 10);
        [cell addSubview:barButton];

    }else if (indexPath.row > 1 && indexPath.row <= 5) {

            UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(Width*5/16, 5, Width*10/16, (Height - StatusBarAndNavigationBarHeight)/12 - 10)];
            
            textfield.backgroundColor = [UIColor whiteColor];
            textfield.font = font(fontsize);
            textfield.layer.cornerRadius = 5;
            textfield.layer.masksToBounds = YES;
            
            textfield.tag = 1000 + indexPath.row;
            [cell addSubview:textfield];
        if (indexPath.row == 5) {
            textfield.keyboardType = UIKeyboardTypeNumberPad;
        }
        
    }else if (indexPath.row == 7) {
    
        UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(20, 10, (Width - 120)/3, 4*(Width - 120)/9)];
        firstView.backgroundColor = color(230, 230, 230, 1);
        
        UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3, 10, (Width - 120)/3, 4*(Width - 120)/9)];
        secondView.backgroundColor = color(230, 230, 230, 1);
        UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3, 10, (Width - 120)/3, 4*(Width - 120)/9)];
        thirdView.backgroundColor = color(230, 230, 230, 1);
        
        [cell addSubview:firstView];
        [cell addSubview:secondView];
        [cell addSubview:thirdView];
        {
            UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(20 + (Width - 120)/6 - 1, 20, 1, 4*(Width - 120)/9 - 20)];
            firstLineView.backgroundColor = [UIColor whiteColor];
            UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(25, 10 + 2*(Width - 120)/9 - 1, (Width - 120)/3 - 10, 1)];
            secondLineView.backgroundColor = [UIColor whiteColor];
            
            [cell addSubview:firstLineView];
            [cell addSubview:secondLineView];
        }
        
        {
            UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3 + (Width - 120)/6 - 1, 20, 1, 4*(Width - 120)/9 - 20)];
            firstLineView.backgroundColor = [UIColor whiteColor];
            UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(65 + (Width - 120)/3, 10 + 2*(Width - 120)/9 - 1, (Width - 120)/3 - 10, 1)];
            secondLineView.backgroundColor = [UIColor whiteColor];
            
            [cell addSubview:firstLineView];
            [cell addSubview:secondLineView];
            
        }
        
        {
            UIView *firstLineView = [[UIView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3 + (Width - 120)/6 - 1, 20, 1, 4*(Width - 120)/9 - 20)];
            firstLineView.backgroundColor = [UIColor whiteColor];
            UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(Width - 15 - (Width - 120)/3, 10 + 2*(Width - 120)/9 - 1, (Width - 120)/3 - 10, 1)];
            secondLineView.backgroundColor = [UIColor whiteColor];
            
            [cell addSubview:firstLineView];
            [cell addSubview:secondLineView];
            
        }
        
        self.firstImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, (Width - 120)/3, 4*(Width - 120)/9)];
        self.secondImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60 + (Width - 120)/3, 10, (Width - 120)/3, 4*(Width - 120)/9)];
        self.thirdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Width - 20 - (Width - 120)/3, 10, (Width - 120)/3, 4*(Width - 120)/9)];
        
        [cell addSubview:self.firstImageView];
        [cell addSubview:self.secondImageView];
        [cell addSubview:self.thirdImageView];
        
        UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        firstButton.backgroundColor = [UIColor clearColor];
        firstButton.frame = CGRectMake(20, 10, (Width - 120)/3, 4*(Width - 120)/9);
        [cell addSubview:firstButton];
        firstButton.tag = 4001;
        [firstButton addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        secondButton.backgroundColor = [UIColor clearColor];
        secondButton.frame = CGRectMake(60 + (Width - 120)/3, 10, (Width - 120)/3, 4*(Width - 120)/9);
        [cell addSubview:secondButton];
        secondButton.tag = 4002;
        [secondButton addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        thirdButton.backgroundColor = [UIColor clearColor];
        thirdButton.frame = CGRectMake(Width - 20 - (Width - 120)/3, 10, (Width - 120)/3, 4*(Width - 120)/9);
        [cell addSubview:thirdButton];
        thirdButton.tag = 4003;
        [thirdButton addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 7) {
        return (Height - StatusBarAndNavigationBarHeight)*3/12;
    }
    return (Height - StatusBarAndNavigationBarHeight)/12;
}

- (void)dateButtonClicked:(UIButton *)sender {
    DatePickerViewController *datePickerVC = [[DatePickerViewController alloc]init];
    
    datePickerVC.returnDate = ^(NSString *dateStr){
        NSString *year = [dateStr substringToIndex:4];
        NSString *month = [dateStr substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [dateStr substringFromIndex:8];
        
        NSString *date = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        
        [sender setTitle:date forState:UIControlStateNormal];
    };
    
    [self presentViewController:datePickerVC animated:YES completion:nil];
}

- (void)barButtonClicked:(UIButton *)sender {
    [self.navigationController pushViewController:self.barVC animated:YES];
    [self.session startRunning];
}

- (void)pictureAction:(UIButton *)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
        
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
        return;
    }
    
    number = 1;
    //验证码不定是否必填
    
//    if ([((UITextField *)[self.tableView viewWithTag:1005]).text isEqualToString:@""] || !((UITextField *)[self.tableView viewWithTag:1005]).text) {
//        MBProgressHUD *successHUD = [[MBProgressHUD alloc]initWithView:self.tableView];
//        successHUD.mode = MBProgressHUDModeText;
//        successHUD.label.font = font(14);
//        successHUD.label.text = @"请输入验证码";
//        [self.tableView addSubview:successHUD];
//        
//        [successHUD showAnimated:YES];
//        
//        
//        [successHUD hideAnimated:YES afterDelay:1.2];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            number = 0;
//        });
//        [successHUD removeFromSuperViewOnHide];
//        //                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//        
//        return ;
//    }
    
    
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.tableView];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [self.tableView addSubview:HUD];
    [HUD showAnimated:YES];
    
    
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
    NSArray *picNameArray = @[
                              @"profile_picture1",
                              @"profile_picture2",
                              @"profile_picture3"
                              ];
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
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 5;
    UserModel *userModel = [UserModel readUserModel];
    NSString *URL = [NSString stringWithFormat:@"%@Task.ashx?action=finish",HomeURL];
    NSDictionary *params = @{
                             @"id":@(self.ID),
                             @"comid":@(userModel.comid),
                             @"uid":@(userModel.uid),
                             @"finishTime":((UIButton *)[self.tableView viewWithTag:500]).titleLabel.text,
                             @"productCode":((UITextField *)[self.tableView viewWithTag:1001]).text,
                             @"reason":((UITextField *)[self.tableView viewWithTag:1002]).text,
                             @"change":((UITextField *)[self.tableView viewWithTag:1003]).text,
                             @"remark":((UITextField *)[self.tableView viewWithTag:1004]).text,
                             @"randNum":((UITextField *)[self.tableView viewWithTag:1005]).text
                             
                             };
    
    __weak typeof(self)weakSelf = self;
    
   
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSInteger i = 0; i < count; i ++) {
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString *fileName = [NSString stringWithFormat:@"%@%ld.jpeg",[formatter stringFromDate:date],(long)i];
            
            //name必须跟后台给的一致，fileName随便
                [formData appendPartWithFileData:picArray[i] name:fileName fileName:picNameArray[i] mimeType:@"image/jpeg"];
                
            }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseObject = %@",str);
        
        if ([str isEqualToString:@"0"]) {
            [HUD hideAnimated:YES];
            [HUD removeFromSuperViewOnHide];
            MBProgressHUD *successHUD = [[MBProgressHUD alloc]initWithView:self.tableView];
            successHUD.mode = MBProgressHUDModeText;
            successHUD.label.font = font(14);
            successHUD.label.text = @"验证码输入错误";
            [weakSelf.tableView addSubview:successHUD];
            
            [successHUD showAnimated:YES];
            number = 0;
            
            [successHUD hideAnimated:YES afterDelay:0.5];
            [successHUD removeFromSuperViewOnHide];
//                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            
            return ;
            
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBadgeValueChanged object:nil];
        
        
        [HUD hideAnimated:YES];
        [HUD removeFromSuperViewOnHide];
        MBProgressHUD *successHUD = [[MBProgressHUD alloc]initWithView:self.tableView];
        successHUD.mode = MBProgressHUDModeText;
        successHUD.label.font = font(14);
        successHUD.label.text = @"提交成功";
        [weakSelf.tableView addSubview:successHUD];

        [successHUD showAnimated:YES];
        number = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [successHUD hideAnimated:YES];
            [successHUD removeFromSuperViewOnHide];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        number = 0;
//        NSLog(@"error = %@",error.userInfo);
        [HUD hideAnimated:YES];
        [HUD removeFromSuperViewOnHide];
        MBProgressHUD *errorHUD = [[MBProgressHUD alloc]initWithView:self.tableView];
        errorHUD.mode = MBProgressHUDModeText;
        errorHUD.label.font = font(14);
        errorHUD.label.text = @"提交失败";
        [weakSelf.tableView addSubview:errorHUD];

        [errorHUD showAnimated:YES];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [errorHUD hideAnimated:YES];
            [errorHUD removeFromSuperViewOnHide];
            
        });
    }];
    
}

#pragma mark - AVCaptureMetaDataOutputObjectsDelegate -
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    [self.session stopRunning];
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        UITextField *textfield = [self.tableView viewWithTag:1001];
        textfield.text = obj.stringValue;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setNaviTitle {
    self.navigationItem.title = @"完成工单";
}

@end
