//
//  AppendFeesViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/4/11.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "DetailPageBaseViewController.h"

@interface AppendFeesViewController : DetailPageBaseViewController
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *product;
@property (nonatomic, strong) NSString *price;

@property (nonatomic, strong) NSString *comid;
@end
