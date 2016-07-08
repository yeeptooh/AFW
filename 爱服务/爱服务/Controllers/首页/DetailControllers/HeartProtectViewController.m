//
//  HeartProtectViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/6/15.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "HeartProtectViewController.h"
#import "UserModel.h"
#import <WebKit/WebKit.h>
#import "AFNetworking.h"
@interface HeartProtectViewController ()
<
WKNavigationDelegate,
WKUIDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *noNetWorkingView;

@end

@implementation HeartProtectViewController

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

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, Width, 2)];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = BlueColor;
    }
    return _progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setWebView];
    [self setNaviTitle];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_noNetWorkingView) {
        [self.noNetWorkingView removeFromSuperview];
        self.noNetWorkingView = nil;
    }
}



- (void)setWebView {
//    UserModel *userModel = [UserModel readUserModel];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight)];
    
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.228:89/API/AiXinBao.aspx"]]]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.view addSubview:self.progressView];
    [self.view insertSubview:self.webView belowSubview:self.progressView];
    
    
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //        self.progressView.hidden = self.webView.estimatedProgress == 1;
        //        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        self.progressView.progress = self.webView.estimatedProgress;
    }
    //加载完成
    if (!self.webView.isLoading) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
    }
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.progressView.alpha = 0;
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.view addSubview:self.noNetWorkingView];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:^{
        completionHandler();
    }];
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    
    if ([[URL.absoluteString lastPathComponent] isEqualToString:@"aixinbao"]) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        imagePickerController.navigationBar.barStyle = UIBarStyleBlack;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }

}

#pragma mark - UIImagePickcerControllerDelegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
//    NSURL *url = [NSURL URLWithString:@""];
    NSString *url = @"http://192.168.1.228:89/forapp/uploadFile.ashx?action=uploadimages";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg",[formatter stringFromDate:date]];
        
        
        [formData appendPartWithFileData:data name:fileName fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseObject = %@",string);
        
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getIOSImage(\"%@\")",string] completionHandler:^(id _Nullable js, NSError * _Nullable error) {
            NSLog(@"js = %@",js);
            NSLog(@"errorJS = %@",error.localizedDescription);
        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}





- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
}

- (void)setNaviTitle {
    self.navigationItem.title = @"爱心保";
}

@end
