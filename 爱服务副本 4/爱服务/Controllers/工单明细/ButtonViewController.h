//
//  ButtonViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/4/18.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnText) (NSString *text);
@interface ButtonViewController : UIViewController
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) ReturnText returnText;
@property (nonatomic, assign) NSInteger ID;
@end
