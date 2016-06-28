//
//  CityViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/6/28.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnInfo)(NSString *name, NSInteger row);
@interface CityViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *List;
@property (nonatomic, copy) ReturnInfo returnInfo;
@end
