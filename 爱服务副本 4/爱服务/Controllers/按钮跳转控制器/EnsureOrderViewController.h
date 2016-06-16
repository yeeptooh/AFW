//
//  EnsureOrderViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/4/28.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnsureOrderViewController : UIViewController
@property (nonatomic, strong) UILabel *serviceLabel;
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *wID;
@property (nonatomic, strong) NSString *wName;
@property (nonatomic, strong) NSString *wPhone;

@end
