//
//  ZDDWebViewViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/8/2.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

//封装的没用的带进度条的webView，对不起
#import "DetailPageBaseViewController.h"
#import <WebKit/WebKit.h>
@interface ZDDWebViewController : DetailPageBaseViewController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *url;
@end
