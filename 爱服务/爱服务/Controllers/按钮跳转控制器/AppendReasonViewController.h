//
//  AppendReasonViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/7/21.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnReason)(NSString *reason);
@interface AppendReasonViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *reasonList;
@property (nonatomic, copy) ReturnReason returnReason;
@end
