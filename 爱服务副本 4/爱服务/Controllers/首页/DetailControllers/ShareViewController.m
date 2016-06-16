//
//  ShareViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//
//@"爱服务 -- 中国专业家电售后服务交易平台！"
#import "ShareViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface ShareViewController ()
@property (nonatomic, strong) HomeViewController *homeVC;
@end
//static NSInteger height;
@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.homeVC = (HomeViewController *)[(UINavigationController *)[((UITabBarController *)[self presentingViewController]) selectedViewController] topViewController];
}

- (void)setBackgroundView {
//    height = 258;
    
    NSArray *list = @[
                      @"微信好友",
                      @"微信朋友圈",
                      @"QQ",
                      @"新浪微博",
                      @"信息",
                      @"电子邮件"
                      ];

    for (NSInteger i = 0; i < 4 ; i++) {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ZHActionShareNormal%@",@(i+1)]] forState:UIControlStateNormal];
        [shareButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ZHActionShareHighlight%@",@(i+1)]] forState:UIControlStateHighlighted];
        [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        shareButton.tag = 100 + i;
        shareButton.frame = CGRectMake((Width/4)*i, 30, Width/4, 54);
        
        [self.view addSubview:shareButton];
    }
    
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ZHActionShareNormal%@",@(i+5)]] forState:UIControlStateNormal];
        [shareButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ZHActionShareHighlight%@",@(i+5)]] forState:UIControlStateHighlighted];
        [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        shareButton.tag = 200 + i;
        shareButton.frame = CGRectMake((Width/4)*i, 30 + 54 + 5 + 20 + 10, Width/4, 54);
        
        [self.view addSubview:shareButton];
    }
    
    
    for (NSInteger i = 0; i < 4 ; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((Width/4) * i, 30 + 54 + 5, Width/4, 20)];
        label.text = list[i];
        label.font = font(12);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = color(150, 150, 150, 1);
        [self.view addSubview:label];
    }
    
    for (NSInteger i = 0; i < 2; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((Width/4) * i, 30 + 54 + 5 + 20 + 10 + 54 + 5, Width/4, 20)];
        label.text = list[i+4];
        label.font = font(12);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = color(150, 150, 150, 1);
        [self.view addSubview:label];
    }
    
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:color(150, 150, 150, 1) forState:UIControlStateNormal];
    
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 208.5, Width, 0.5)];
    line.backgroundColor = color(150, 150, 150, 1);
    [self.view addSubview:line];
    
    cancelButton.frame = CGRectMake(0, 210, Width, 48);
    [self.view addSubview:cancelButton];

}

- (void)shareButtonClicked:(UIButton *)sender {
    if (sender.tag == 100) {
        
        if (![WXApi isWXAppInstalled]) {

            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请先安装微信客户端再进行分享" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertview show];
            return;
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        //微信好友
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.text = @"爱服务 -- 中国专业家电售后服务交易平台！ https://itunes.apple.com/cn/app/ai-fu-wu/id1109327376?mt=8";
        // 发送消息的类型，包括文本消息和多媒体消息两种，两者只能选择其一，不能同时发送文本和多媒体消息
        req.bText = YES;
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
    }else if (sender.tag == 101) {
        if (![WXApi isWXAppInstalled]) {
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请先安装微信客户端再进行分享" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertview show];
            return;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        //朋友圈
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.text = @"爱服务 -- 中国专业家电售后服务交易平台！ https://itunes.apple.com/cn/app/ai-fu-wu/id1109327376?mt=8";
        // 发送消息的类型，包括文本消息和多媒体消息两种，两者只能选择其一，不能同时发送文本和多媒体消息
        req.bText = YES;
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req];
    }else if (sender.tag == 102) {
        if (![QQApiInterface isQQInstalled]) {
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请先安装QQ客户端再进行分享" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertview show];
            return;
            
        }
        //QQ
        [self dismissViewControllerAnimated:YES completion:nil];
        QQApiTextObject *textObj = [QQApiTextObject objectWithText:@"爱服务 -- 中国专业家电售后服务交易平台！ https://itunes.apple.com/cn/app/ai-fu-wu/id1109327376?mt=8"];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:textObj];
        //将内容分享到qq
        [QQApiInterface sendReq:req];

    }else if (sender.tag == 103) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]]) {
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请先安装微博客户端再进行分享" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertview show];
            return;
            
        }
        //微博
        [self dismissViewControllerAnimated:YES completion:nil];
        
        /**
         第三方应用向微博客户端请求认证的消息结构
         
         第三方应用向微博客户端申请认证时，需要调用 [WeiboSDK sendRequest:]函数， 向微博客户端发送一个 WBAuthorizeRequest 的消息结构。
         
         微博客户端处理完后会向第三方应用发送一个结构为 WBAuthorizeResponse 的处理结果。
         */
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        // 微博开放平台第三方应用授权回调页地址，默认为`http://`
        authRequest.redirectURI = WBRedirectURL;
        // 微博开放平台第三方应用scope，多个scope用逗号分隔
        authRequest.scope = @"all";
        // 第三方应用发送消息至微博客户端程序的消息结构体，其中message类型我会在下面放出
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:nil];
        // 自定义信息字典，用于数据传输过程中存储相关的上下文环境数据
        
        // 第三方应用给微博客户端程序发送 request 时，可以在 userInfo 中存储请求相关的信息。
        request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        // 发送请求给微博客户端程序，并切换到微博
        
        // 请求发送给微博客户端程序之后，微博客户端程序会进行相关的处理，处理完成之后一定会调用 [WeiboSDKDelegate didReceiveWeiboResponse:] 方法将处理结果返回给第三方应用
        [WeiboSDK sendRequest:request];
        
        
    }else if (sender.tag == 200) {
        //信息

    }else {
        //邮件
    }
    
}

- (WBMessageObject *)messageToShare {
    WBMessageObject *message = [WBMessageObject message];
    message.text = NSLocalizedString(@"爱服务 -- 中国专业家电售后服务交易平台！ https://itunes.apple.com/cn/app/ai-fu-wu/id1109327376?mt=8", nil);
    return message;
}

- (void)cancelButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
