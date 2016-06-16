//
//  DatePickerViewController.h
//  WeiKe
//
//  Created by 张冬冬 on 16/4/6.
//  Copyright © 2016年 Ji_YuFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnDate)(NSString *date);
@interface DatePickerViewController : UIViewController
@property (nonatomic, copy) ReturnDate returnDate;
@property (nonatomic, assign) NSInteger ID;
@end
